import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigService {
  static const minimumSupportedVersionKey = 'minimum_supported_version';
  static const latestStoreVersionAndroidKey = 'latest_store_version_android';
  static const latestStoreVersionIosKey = 'latest_store_version_ios';
  static const killSwitchPatchDisabledKey = 'kill_switch_patch_disabled';
  static const patchRolloutPercentageKey = 'patch_rollout_percentage';

  static const _defaults = <String, dynamic>{
    minimumSupportedVersionKey: '0.0.0',
    latestStoreVersionAndroidKey: '0.0.0',
    latestStoreVersionIosKey: '0.0.0',
    killSwitchPatchDisabledKey: false,
    patchRolloutPercentageKey: 100,
  };

  RemoteConfigService({FirebaseRemoteConfig? remoteConfig})
      : _remoteConfig = remoteConfig ?? FirebaseRemoteConfig.instance;

  final FirebaseRemoteConfig _remoteConfig;
  bool _initialized = false;

  Future<void> ensureInitialized() async {
    if (_initialized) return;

    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: kDebugMode
              ? Duration.zero
              : const Duration(hours: 1),
        ),
      );
      await _remoteConfig.setDefaults(_defaults);
      await _remoteConfig.fetchAndActivate();
      _initialized = true;
      debugPrint('[RemoteConfig] Fetched and activated');
    } catch (error, stackTrace) {
      debugPrint('[RemoteConfig] Init/fetch failed (fail-open): $error');
      debugPrint('$stackTrace');
      // Keep defaults so callers can still read safe values.
      try {
        await _remoteConfig.setDefaults(_defaults);
      } catch (_) {}
      _initialized = true;
    }
  }

  String get minimumSupportedVersion =>
      _remoteConfig.getString(minimumSupportedVersionKey);

  String get latestStoreVersionAndroid =>
      _remoteConfig.getString(latestStoreVersionAndroidKey);

  String get latestStoreVersionIos =>
      _remoteConfig.getString(latestStoreVersionIosKey);

  /// Latest store version for the running platform (Android or iOS).
  String get latestStoreVersion {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return latestStoreVersionIos;
    }
    return latestStoreVersionAndroid;
  }

  bool get killSwitchPatchDisabled =>
      _remoteConfig.getBool(killSwitchPatchDisabledKey);

  int get patchRolloutPercentage {
    final value = _remoteConfig.getInt(patchRolloutPercentageKey);
    if (value < 0) return 0;
    if (value > 100) return 100;
    return value;
  }
}
