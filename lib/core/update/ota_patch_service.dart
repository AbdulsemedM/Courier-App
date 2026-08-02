import 'dart:math';

import 'package:courier_app/core/update/remote_config_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

enum OtaPatchOutcome {
  skippedUnavailable,
  skippedKillSwitch,
  upToDate,
  downloaded,
  restartRequired,
  failed,
}

class OtaPatchService {
  static const _groupKey = 'ota_patch_device_group';

  OtaPatchService({
    required RemoteConfigService remoteConfigService,
    ShorebirdUpdater? updater,
    FirebaseCrashlytics? crashlytics,
  })  : _remoteConfigService = remoteConfigService,
        _updater = updater ?? ShorebirdUpdater(),
        _crashlytics = crashlytics ?? FirebaseCrashlytics.instance;

  final RemoteConfigService _remoteConfigService;
  final ShorebirdUpdater _updater;
  final FirebaseCrashlytics _crashlytics;

  Future<OtaPatchOutcome> checkAndDownloadIfAvailable() async {
    if (!_updater.isAvailable) {
      _log('Updater unavailable on this build');
      return OtaPatchOutcome.skippedUnavailable;
    }

    await _remoteConfigService.ensureInitialized();

    if (_remoteConfigService.killSwitchPatchDisabled) {
      _log('Kill switch enabled — skipping patch check');
      await _breadcrumb('ota_kill_switch_enabled');
      return OtaPatchOutcome.skippedKillSwitch;
    }

    final track = await _resolveTrack();
    _log('Checking for patch on track=${track.value}');
    await _breadcrumb('ota_check_start', {'track': track.value});

    try {
      final status = await _updater.checkForUpdate(track: track);
      _log('Update status: $status');

      switch (status) {
        case UpdateStatus.upToDate:
          await _breadcrumb('ota_up_to_date');
          return OtaPatchOutcome.upToDate;
        case UpdateStatus.restartRequired:
          await _breadcrumb('ota_restart_required');
          return OtaPatchOutcome.restartRequired;
        case UpdateStatus.unavailable:
          await _breadcrumb('ota_status_unavailable');
          return OtaPatchOutcome.skippedUnavailable;
        case UpdateStatus.outdated:
          break;
      }

      await _breadcrumb('ota_download_start', {'track': track.value});
      await _updater.update(track: track);
      _log('Patch downloaded; applies on next restart');
      await _breadcrumb('ota_download_success', {'track': track.value});
      return OtaPatchOutcome.downloaded;
    } catch (error, stackTrace) {
      _log('Patch check/download failed: $error');
      await _crashlytics.recordError(
        error,
        stackTrace,
        reason: 'ota_patch_failed',
        fatal: false,
      );
      return OtaPatchOutcome.failed;
    }
  }

  Future<UpdateTrack> _resolveTrack() async {
    final group = await _deviceGroup();
    final percentage = _remoteConfigService.patchRolloutPercentage;
    _log('Device group=$group rollout%=$percentage');
    if (group <= percentage) {
      return UpdateTrack.beta;
    }
    return UpdateTrack.stable;
  }

  Future<int> _deviceGroup() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getInt(_groupKey);
    if (cached != null && cached >= 1 && cached <= 100) {
      return cached;
    }
    final group = Random().nextInt(100) + 1;
    await prefs.setInt(_groupKey, group);
    return group;
  }

  void _log(String message) {
    debugPrint('[OtaPatch] $message');
  }

  Future<void> _breadcrumb(
    String name, [
    Map<String, Object?>? data,
  ]) async {
    try {
      await _crashlytics.log(
        data == null || data.isEmpty
            ? name
            : '$name ${data.entries.map((e) => '${e.key}=${e.value}').join(' ')}',
      );
    } catch (_) {
      // Crashlytics may be unavailable in some debug/desktop contexts.
    }
  }
}
