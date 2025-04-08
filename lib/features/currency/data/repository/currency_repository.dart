import 'dart:convert';

import 'package:courier_app/features/currency/data/data_provider/currency_data_provider.dart';
import 'package:courier_app/features/currency/model/currency_model.dart';

class CurrencyRepository {
  final CurrencyDataProvider _currencyDataProvider = CurrencyDataProvider();

  CurrencyRepository(CurrencyDataProvider currencyDataProvider);

  Future<List<CurrencyModel>> fetchCurrencies() async {
    try {
      final response = await _currencyDataProvider.fetchCurrencies();
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final currencies = (data['data'] as List)
            .map((currency) => CurrencyModel.fromMap(currency))
            .toList();
        return currencies;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }

  Future<String> addCurrency(Map<String, dynamic> currency) async {
    try {
      final response = await _currencyDataProvider.addCurrency(currency);
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
