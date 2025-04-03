import 'dart:convert';

import 'package:courier_app/features/branches/model/country_model.dart';
import 'package:courier_app/features/countries/data/data_provider/countries_data_provider.dart';

class CountriesRepository {
  final CountriesDataProvider _countriesDataProvider = CountriesDataProvider();

  CountriesRepository(CountriesDataProvider countriesDataProvider);

  Future<List<CountryModel>> fetchCountry() async {
    try {
      final response = await _countriesDataProvider.fetchCountries();
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final countries = (data['data'] as List)
            .map((country) => CountryModel.fromMap(country))
            .toList();
        return countries;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }

  Future<String> addCountry(Map<String, dynamic> country) async {
    try {
      final response = await _countriesDataProvider.addCountry(country);
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      return data['message'];
    } catch (e) {
      throw e.toString();
    }
  }
}
