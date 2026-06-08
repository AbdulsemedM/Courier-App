import 'package:courier_app/features/branches/model/country_model.dart';

class CountryDefaults {
  static List<CountryModel> fallbackCountries() {
    return [
      CountryModel(id: 1, name: 'Somalia', isoCode: 'SO', countryCode: '+252'),
      CountryModel(id: 2, name: 'Kenya', isoCode: 'KE', countryCode: '+254'),
      CountryModel(id: 3, name: 'Ethiopia', isoCode: 'ET', countryCode: '+251'),
      CountryModel(id: 4, name: 'Djibouti', isoCode: 'DJ', countryCode: '+253'),
    ];
  }

  static CountryModel defaultCountry() => fallbackCountries().first;

  static String flagEmoji(String? isoCode) {
    if (isoCode == null || isoCode.length != 2) return '🌍';
    final upper = isoCode.toUpperCase();
    return String.fromCharCodes([
      upper.codeUnitAt(0) + 0x1F1A5,
      upper.codeUnitAt(1) + 0x1F1A5,
    ]);
  }
}
