import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Reads from secure storage, returning null when the key is missing or
/// unreadable (e.g. Android Keystore mismatch / BadPaddingException).
Future<String?> safeRead(FlutterSecureStorage storage, String key) async {
  try {
    return await storage.read(key: key);
  } on PlatformException {
    await safeDelete(storage, key);
    return null;
  }
}

/// Deletes a secure-storage key, ignoring platform failures.
Future<void> safeDelete(FlutterSecureStorage storage, String key) async {
  try {
    await storage.delete(key: key);
  } on PlatformException {
    // Key may already be gone or keystore may be unusable.
  }
}

/// Writes to secure storage without propagating platform failures.
Future<void> safeWrite(
  FlutterSecureStorage storage,
  String key,
  String value,
) async {
  try {
    await storage.write(key: key, value: value);
  } on PlatformException {
    // Caller treats write failure as best-effort (e.g. remember-me).
  }
}
