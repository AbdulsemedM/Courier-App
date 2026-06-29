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

  const ForceUpdateCheckResult({
    required this.shouldBlock,
    this.localVersion,
    this.storeVersion,
    this.storeUrl,
  });
}

class ForceUpdateService {
  static const _bypassVersionKey = 'force_update_bypass_local_version';

  const ForceUpdateService();

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
      final newVersion = NewVersionPlus(androidId: packageInfo.packageName);
      final status = await newVersion.getVersionStatus();

      if (status == null) {
        debugPrint(
          '[ForceUpdate] Store version check returned no data for package: ${packageInfo.packageName}',
        );
        return const ForceUpdateCheckResult(shouldBlock: false);
      }

      final local = status.localVersion;
      final store = status.storeVersion;
      final requiresUpdate = status.canUpdate || _isStoreVersionHigher(local, store);
      debugPrint('[ForceUpdate] Installed version on device: $local');
      debugPrint('[ForceUpdate] Latest version on store: $store');
      debugPrint('[ForceUpdate] Store URL: ${status.appStoreLink}');
      debugPrint('[ForceUpdate] Update required: $requiresUpdate');

      return ForceUpdateCheckResult(
        shouldBlock: requiresUpdate,
        localVersion: local,
        storeVersion: store,
        storeUrl: status.appStoreLink,
      );
    } catch (error) {
      debugPrint('[ForceUpdate] Store version check failed: $error');
      // Fail open: app continues if lookup is temporarily unavailable.
      return const ForceUpdateCheckResult(shouldBlock: false);
    }
  }

  bool _isStoreVersionHigher(String localVersion, String storeVersion) {
    final localParts = _normalizeVersion(localVersion);
    final storeParts = _normalizeVersion(storeVersion);
    final maxLen = localParts.length > storeParts.length
        ? localParts.length
        : storeParts.length;

    for (var i = 0; i < maxLen; i++) {
      final local = i < localParts.length ? localParts[i] : 0;
      final store = i < storeParts.length ? storeParts[i] : 0;
      if (store > local) return true;
      if (store < local) return false;
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
