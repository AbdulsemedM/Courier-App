import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class TellerByBranchDataProvider {
  Future<String> fetchTellersByBranch(int branchId) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest(
          "/api/v1/teller-branch?branchId=$branchId");
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> fetchTellerAccountStatus(int tellerId) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest(
          "/api/v1/teller/$tellerId/account-status");
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}

