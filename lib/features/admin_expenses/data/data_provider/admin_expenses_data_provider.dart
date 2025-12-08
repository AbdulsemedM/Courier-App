import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class AdminExpensesDataProvider {
  Future<String> fetchAdminExpenses({
    required int branchId,
    required String fromDate,
    required String toDate,
  }) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final params = {
        'branchId': branchId.toString(),
        'fromDate': fromDate,
        'toDate': toDate,
      };
      final response = await apiProvider.getRequest(
        '/api/v1/reports/branch/shipments',
        params: params,
      );
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}

