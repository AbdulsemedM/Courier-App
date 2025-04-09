import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class ManageUsersDataProvider {
  Future<String> fetchUsers() async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest("/api/v1/users");
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  // Future<String> addUser(Map<String, dynamic> servicesMode) async {
  //   try {
  //     final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
  //     final response = await apiProvider.postRequest("/api/v1/users", servicesMode);
  //     return response.body;
  //   } catch (e) {
  //     throw e.toString();
  //   }
  // }

  Future<String> updateUser(
      Map<String, dynamic> servicesMode, String userId) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response =
          await apiProvider.putRequest("/api/v1/users/$userId", servicesMode);
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}
