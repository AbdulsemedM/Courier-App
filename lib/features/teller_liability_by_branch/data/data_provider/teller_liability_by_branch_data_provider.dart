import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class TellerLiabilityByBranchDataProvider {
  Future<String> fetchTellerLiabilitiesByBranch({
    required int branchId,
  }) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final params = {
        'branchId': branchId.toString(),
      };
      final response = await apiProvider.getRequest(
        '/api/v1/branch/teller-liabilities',
        params: params,
      );
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}

