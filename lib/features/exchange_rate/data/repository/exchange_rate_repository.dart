import 'dart:convert';

import 'package:courier_app/features/exchange_rate/data/data_provider/exchange_rate_data_provider.dart';
import 'package:courier_app/features/exchange_rate/model/exchange_rate_model.dart';

class ExchangeRateRepository {
  final ExchangeRateDataProvider _exchangeRateDataProvider =
      ExchangeRateDataProvider();

  ExchangeRateRepository(ExchangeRateDataProvider exchangeRateDataProvider);

  Future<List<ExchangeRateModel>> fetchExchangeRates() async {
    try {
      final response = await _exchangeRateDataProvider.fetchExchangeRates();
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final exchangeRates = (data['data'] as List)
            .map((exchangeRate) => ExchangeRateModel.fromMap(exchangeRate))
            .toList();
        return exchangeRates;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }

  Future<String> addExchangeRate(Map<String, dynamic> exchangeRate) async {
    try {
      final response = await _exchangeRateDataProvider.addExchangeRate(exchangeRate);
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
