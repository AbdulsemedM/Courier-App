import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class IncomeStatementDataProvider {
  Future<String> fetchIncomeStatement(
      int branchId, String fromDate, String toDate) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest(
          "/api/v1/financial/income-statement?branchId=$branchId&fromDate=$fromDate&toDate=$toDate");
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}

