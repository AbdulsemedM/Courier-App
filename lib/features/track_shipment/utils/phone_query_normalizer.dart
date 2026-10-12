import 'package:courier_app/core/utils/ethiopian_phone_normalizer.dart';

/// Normalizes staff phone searches to the local `09…` form the history API expects.
class PhoneQueryNormalizer {
  static String normalize(String raw) => EthiopianPhoneNormalizer.normalize(raw);
}
