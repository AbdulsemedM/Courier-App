import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class TellerDataProvider {
  Future<String> fetchTellers() async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest("/api/v1/tellers");
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> addTeller(Map<String, dynamic> servicesMode) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response =
          await apiProvider.postRequest("/api/v1/teller", servicesMode);
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> updateTeller(
      Map<String, dynamic> servicesMode, String tellerId) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.putRequest(
          "/api/v1/tellers/$tellerId", servicesMode);
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}
