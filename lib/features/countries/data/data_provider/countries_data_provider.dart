import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class CountriesDataProvider {
  Future<String> fetchCountries() async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest("/api/v1/countries");
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> addCountry(Map<String, dynamic> country) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response =
          await apiProvider.postRequest("/api/v1/countries", country);
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}
