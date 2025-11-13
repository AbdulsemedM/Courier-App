import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class TransactionHqToBranchDataProvider {
  Future<String> fetchTransactions(
      int branchId, String startDate, String endDate) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest(
          "/api/v1/transactions/branch?branchId=$branchId&startDate=$startDate&endDate=$endDate");
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}

