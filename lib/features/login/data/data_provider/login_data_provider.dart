import 'package:courier_app/configuration/api_constants.dart';
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
}
