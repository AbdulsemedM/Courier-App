import 'package:courier_app/core/update/remote_config_service.dart';
import 'package:flutter/foundation.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urovo_scanner/urovo_scanner.dart';

class ForceUpdateCheckResult {
  final bool shouldBlock;
  final String? localVersion;
  final String? storeVersion;
  final String? storeUrl;
  final String? minimumSupportedVersion;

  const ForceUpdateCheckResult({
    required this.shouldBlock,
    this.localVersion,
    this.storeVersion,
    this.storeUrl,
    this.minimumSupportedVersion,
  });
}

class ForceUpdateService {
  static const _bypassVersionKey = 'force_update_bypass_local_version';

  const ForceUpdateService({
    this.remoteConfigService,
  });

  final RemoteConfigService? remoteConfigService;

  Future<bool> isUrovoDevice() async {
    try {
      return await UrovoScanner.isUrovoDevice ?? false;
    } catch (error) {
      debugPrint('[ForceUpdate] Urovo device check failed: $error');
      return false;
    }
  }

  Future<bool> hasBypassedForVersion(String localVersion) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_bypassVersionKey) == localVersion;
  }

  Future<void> saveBypassForVersion(String localVersion) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_bypassVersionKey, localVersion);
  }

  Future<ForceUpdateCheckResult> checkForRequiredUpdate() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final localVersion = packageInfo.version;

      final rc = remoteConfigService;
      if (rc != null) {
        await rc.ensureInitialized();
        final minimum = rc.minimumSupportedVersion;
        final latestRc = rc.latestStoreVersion;
        debugPrint('[ForceUpdate] RC minimum_supported_version: $minimum');
        debugPrint(
          '[ForceUpdate] RC latest_store_version '
          '(${defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android'}): '
          '$latestRc',
        );

        if (_isVersionHigher(minimum, localVersion)) {
          debugPrint(
            '[ForceUpdate] Below Remote Config minimum — blocking update',
          );
          final storeResult = await _lookupStoreStatus(packageInfo);
          return ForceUpdateCheckResult(
            shouldBlock: true,
            localVersion: localVersion,
            storeVersion: storeResult?.storeVersion ?? latestRc,
            storeUrl: storeResult?.storeUrl,
            minimumSupportedVersion: minimum,
          );
        }
      }

      final storeResult = await _lookupStoreStatus(packageInfo);
      if (storeResult == null) {
        return ForceUpdateCheckResult(
          shouldBlock: false,
          localVersion: localVersion,
          minimumSupportedVersion: rc?.minimumSupportedVersion,
        );
      }

      final requiresUpdate = storeResult.shouldBlock;
      debugPrint('[ForceUpdate] Installed version on device: $localVersion');
      debugPrint('[ForceUpdate] Latest version on store: ${storeResult.storeVersion}');
      debugPrint('[ForceUpdate] Store URL: ${storeResult.storeUrl}');
      debugPrint('[ForceUpdate] Update required: $requiresUpdate');

      return ForceUpdateCheckResult(
        shouldBlock: requiresUpdate,
        localVersion: localVersion,
        storeVersion: storeResult.storeVersion,
        storeUrl: storeResult.storeUrl,
        minimumSupportedVersion: rc?.minimumSupportedVersion,
      );
    } catch (error) {
      debugPrint('[ForceUpdate] Store version check failed: $error');
      // Fail open: app continues if lookup is temporarily unavailable.
      return const ForceUpdateCheckResult(shouldBlock: false);
    }
  }

  Future<ForceUpdateCheckResult?> _lookupStoreStatus(
    PackageInfo packageInfo,
  ) async {
    try {
      final newVersion = NewVersionPlus(androidId: packageInfo.packageName);
      final status = await newVersion.getVersionStatus();

      if (status == null) {
        debugPrint(
          '[ForceUpdate] Store version check returned no data for package: ${packageInfo.packageName}',
        );
        return null;
      }

      final local = status.localVersion;
      final store = status.storeVersion;
      final requiresUpdate =
          status.canUpdate || _isVersionHigher(store, local);

      return ForceUpdateCheckResult(
        shouldBlock: requiresUpdate,
        localVersion: local,
        storeVersion: store,
        storeUrl: status.appStoreLink,
      );
    } catch (error) {
      debugPrint('[ForceUpdate] Store lookup error: $error');
      return null;
    }
  }

  /// Returns true when [candidate] is strictly greater than [baseline].
  bool _isVersionHigher(String candidate, String baseline) {
    final candidateParts = _normalizeVersion(candidate);
    final baselineParts = _normalizeVersion(baseline);
    final maxLen = candidateParts.length > baselineParts.length
        ? candidateParts.length
        : baselineParts.length;

    for (var i = 0; i < maxLen; i++) {
      final c = i < candidateParts.length ? candidateParts[i] : 0;
      final b = i < baselineParts.length ? baselineParts[i] : 0;
      if (c > b) return true;
      if (c < b) return false;
    }

    return false;
  }

  List<int> _normalizeVersion(String version) {
    final clean = version.split('+').first.trim();
    return clean
        .split('.')
        .map((part) => int.tryParse(part.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0)
        .toList();
  }
}
