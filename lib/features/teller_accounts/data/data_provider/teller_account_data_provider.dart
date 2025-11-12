import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class TellerAccountDataProvider {
  Future<String> fetchTellerAccounts(String accountType) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest(
          "/api/v1/accounts-by-type?type=$accountType");
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}

