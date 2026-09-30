/// Normalizes staff phone searches to the local `0…` form the history API expects.
class PhoneQueryNormalizer {
  static const _minDigits = 9;
  static const _ethiopiaDial = '251';

  static String normalize(String raw) {
    var digits = raw.trim().replaceAll(RegExp(r'[\s\-()]'), '');
    if (digits.startsWith('+')) {
      digits = digits.substring(1);
    }
    digits = digits.replaceAll(RegExp(r'\D'), '');

    if (digits.isEmpty) {
      throw 'Enter a phone number (09… or +251…)';
    }

    if (digits.startsWith(_ethiopiaDial) &&
        digits.length > _ethiopiaDial.length) {
      final national = digits.substring(_ethiopiaDial.length);
      digits = national.startsWith('0') ? national : '0$national';
    }

    if (digits.length < _minDigits) {
      throw 'Enter a valid phone number (09… or +251…)';
    }

    return digits;
  }
}
