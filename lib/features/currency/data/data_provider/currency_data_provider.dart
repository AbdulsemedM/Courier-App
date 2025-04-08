import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class CurrencyDataProvider {
  Future<String> fetchCurrencies() async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest("/api/v1/currencies");
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> addCurrency(Map<String, dynamic> servicesMode) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response =
          await apiProvider.postRequest("/api/v1/currencies", servicesMode);
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}
