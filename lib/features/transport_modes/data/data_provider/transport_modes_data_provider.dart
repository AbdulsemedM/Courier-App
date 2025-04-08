import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class TransportModesDataProvider {
  Future<String> fetchTransportModes() async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest("/api/v1/transport-modes");
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> addTransportMode(Map<String, dynamic> transportMode) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.postRequest(
          "/api/v1/transport-mode", transportMode);
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}
