import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class AnalyticsDataProvider {
  Future<String> fetchAnalyticsDashboard({
    required int branchId,
    required String fromDate,
    required String toDate,
  }) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest(
        "/api/v1/analytics/dashboard",
        params: {
          'branchId': branchId.toString(),
          'fromDate': fromDate,
          'toDate': toDate,
        },
      );
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}
