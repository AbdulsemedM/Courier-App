/// Converts Ethiopian mobiles (`9…`, `09…`, `2519…`, `+2519…`) to the local `09…` form.
class EthiopianPhoneNormalizer {
  static const minDigits = 9;
  static const ethiopiaDial = '251';

  static String toLocal09(String raw) {
    var digits = raw.trim();
    if (digits.startsWith('+')) {
      digits = digits.substring(1);
    }
    digits = digits.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return '';
    }

    if (digits.startsWith(ethiopiaDial) &&
        digits.length > ethiopiaDial.length) {
      digits = digits.substring(ethiopiaDial.length);
    }

    if (digits.startsWith('0')) {
      return digits;
    }
    if (digits.startsWith('9')) {
      return '0$digits';
    }
    return digits;
  }

  static String normalize(String raw) {
    final digits = toLocal09(raw);
    if (digits.isEmpty) {
      throw 'Enter a phone number (09… or +251…)';
    }
    if (digits.length < minDigits) {
      throw 'Enter a valid phone number (09… or +251…)';
    }
    return digits;
  }
}
