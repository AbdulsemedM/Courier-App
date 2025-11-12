import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class BalanceSheetDataProvider {
  Future<String> fetchBalanceSheet(int branchId, String asOfDate) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest(
          "/api/v1/financial/balance-sheet?branchId=$branchId&asOfDate=$asOfDate");
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}

