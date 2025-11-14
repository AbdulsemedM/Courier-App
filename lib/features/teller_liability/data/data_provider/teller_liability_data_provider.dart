import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class TellerLiabilityDataProvider {
  Future<String> fetchTellerLiabilities() async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest('/api/v1/teller/liabilities');
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}

