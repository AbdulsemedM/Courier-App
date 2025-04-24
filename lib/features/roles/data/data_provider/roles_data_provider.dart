import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class RolesDataProvider {
  Future<String> fetchRoles() async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest("/api/v1/roles");
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
  Future<String> addRoles(Map<String, dynamic> roles) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.postRequest("/api/v1/roles", roles);
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}
