import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class LoginDataProvider {
  Future<String> sendLogin(String phoneNumber, String password) async {
    try {
      final body = {"phoneNumber": phoneNumber, "password": password};
      // print(body);
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.postRequest("/api/auth/signin", body);
      // print(response.body);
      return response.body;
    } catch (e) {
      // print("here is the response");
      // print(e.toString());
      throw e.toString();
    }
  }
}
