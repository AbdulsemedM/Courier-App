import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class ServicesModeDataProvider {
  Future<String> fetchServicesMode() async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest("/api/v1/service-modes");
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> addServicesMode(Map<String, dynamic> servicesMode) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response =
          await apiProvider.postRequest("/api/v1/service-modes", servicesMode);
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}
