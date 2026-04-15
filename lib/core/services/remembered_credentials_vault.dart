import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:courier_app/core/services/device_binding_id.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _kInstallSecret = 'remembered_cred_install_secret_v1';
const _kPayload = 'remembered_cred_payload_v1';

/// AES-GCM with default 12-byte nonce and 128-bit tag.
final _aes = AesGcm.with256bits();
final _pbkdf2 = Pbkdf2(
  macAlgorithm: Hmac.sha256(),
  iterations: 120000,
  bits: 256,
);

class RememberedCredentials {
  RememberedCredentials({required this.email, required this.password});

  final String email;
  final String password;
}

/// Stores email + password encrypted with a key derived from a per-install
/// secret and the current device binding id (PBKDF2 + AES-GCM).
class RememberedCredentialsVault {
  RememberedCredentialsVault({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  Future<Uint8List> _getOrCreateInstallSecret() async {
    final existing = await _storage.read(key: _kInstallSecret);
    if (existing != null && existing.isNotEmpty) {
      return Uint8List.fromList(base64Decode(existing));
    }
    final bytes = Uint8List.fromList(
      List<int>.generate(32, (_) => Random.secure().nextInt(256)),
    );
    await _storage.write(key: _kInstallSecret, value: base64Encode(bytes));
    return bytes;
  }

  List<int> _pbkdf2Password(Uint8List installSecret, String deviceId) {
    final idBytes = utf8.encode(deviceId);
    return [...installSecret, 0, ...idBytes];
  }

  Future<void> save({required String email, required String password}) async {
    final installSecret = await _getOrCreateInstallSecret();
    final deviceId = await resolveDeviceBindingId();

    final pbkdf2Salt = Uint8List.fromList(
      List<int>.generate(16, (_) => Random.secure().nextInt(256)),
    );

    final derived = await _pbkdf2.deriveKey(
      secretKey: SecretKey(_pbkdf2Password(installSecret, deviceId)),
      nonce: pbkdf2Salt,
    );

    final payload = utf8.encode(
      jsonEncode(<String, String>{'e': email, 'p': password}),
    );

    final deviceAad = utf8.encode(deviceId);
    final box = await _aes.encrypt(
      payload,
      secretKey: derived,
      aad: deviceAad,
    );

    final wrapped = <String, dynamic>{
      'v': 1,
      'pbkdf2_salt': base64Encode(pbkdf2Salt),
      'box': base64Encode(box.concatenation()),
    };
    await _storage.write(key: _kPayload, value: jsonEncode(wrapped));
  }

  /// Returns decrypted credentials, or null if none stored or binding fails.
  Future<RememberedCredentials?> load() async {
    final raw = await _storage.read(key: _kPayload);
    if (raw == null || raw.isEmpty) return null;

    final installSecretB64 = await _storage.read(key: _kInstallSecret);
    if (installSecretB64 == null || installSecretB64.isEmpty) return null;

    final installSecret = Uint8List.fromList(base64Decode(installSecretB64));
    final deviceId = await resolveDeviceBindingId();
    final deviceAad = utf8.encode(deviceId);

    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      if (map['v'] != 1) return null;
      final pbkdf2Salt = base64Decode(map['pbkdf2_salt'] as String);
      final boxBytes = base64Decode(map['box'] as String);

      final derived = await _pbkdf2.deriveKey(
        secretKey: SecretKey(_pbkdf2Password(installSecret, deviceId)),
        nonce: pbkdf2Salt,
      );

      final box = SecretBox.fromConcatenation(
        boxBytes,
        nonceLength: _aes.nonceLength,
        macLength: _aes.macAlgorithm.macLength,
      );

      final clear = await _aes.decrypt(
        box,
        secretKey: derived,
        aad: deviceAad,
      );

      final decoded = jsonDecode(utf8.decode(clear)) as Map<String, dynamic>;
      final email = decoded['e'] as String?;
      final password = decoded['p'] as String?;
      if (email == null || password == null) return null;
      return RememberedCredentials(email: email, password: password);
    } on Object {
      return null;
    }
  }

  Future<void> clear() async {
    await _storage.delete(key: _kPayload);
  }
}
