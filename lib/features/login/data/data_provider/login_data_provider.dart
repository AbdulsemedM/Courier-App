import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/features/login/models/permissions.dart';
import 'package:courier_app/providers/provider_setup.dart';

class LoginDataProvider {
  Future<String> sendLogin(String email, String password) async {
    try {
      final body = {"email": email, "password": password};
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.postRequest("/api/v1/login", body);
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Permissions> getPermissions(int roleId) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response =
          await apiProvider.getRequest("/api/v1/permission/role/$roleId");
      return Permissions.fromJson(response.body);
    } catch (e) {
      throw e.toString();
    }
  }
}
