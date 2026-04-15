import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

/// Returns a stable per-device string used only for local crypto binding.
/// Not suitable as a global user identifier.
Future<String> resolveDeviceBindingId() async {
  if (kIsWeb) {
    return 'web';
  }
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    final ios = await DeviceInfoPlugin().iosInfo;
    return ios.identifierForVendor ?? 'ios-unknown';
  }
  if (defaultTargetPlatform == TargetPlatform.android) {
    final androidId = await const AndroidId().getId();
    if (androidId != null && androidId.isNotEmpty) {
      return androidId;
    }
    final a = await DeviceInfoPlugin().androidInfo;
    return '${a.fingerprint}|${a.model}|${a.device}';
  }
  return 'unknown-${defaultTargetPlatform.name}';
}
