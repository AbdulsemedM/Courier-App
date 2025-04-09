import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class ExchangeRateDataProvider {
  Future<String> fetchExchangeRates() async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest("/api/v1/exchange-rates");
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> addExchangeRate(Map<String, dynamic> exchangeRate) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response =
          await apiProvider.postRequest("/api/v1/exchange-rate", exchangeRate);
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}
