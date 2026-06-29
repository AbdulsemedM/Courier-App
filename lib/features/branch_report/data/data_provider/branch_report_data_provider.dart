import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class BranchReportDataProvider {
  static const _defaultPageSize = 10000000;

  Future<String> fetchBranchShipments({
    required int branchId,
    required String startDate,
    required String endDate,
    String search = '',
  }) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final body = {
        'branchId': branchId,
        'startDate': startDate,
        'endDate': endDate,
        'limit': _defaultPageSize,
        'page': 1,
        'pageSize': _defaultPageSize,
        'search': search,
        'size': _defaultPageSize,
        'sortBy': 'createdAt',
        'sortOrder': 'desc',
      };
      final response = await apiProvider.postRequest(
        '/api/v1/reports/branch-shipment-report',
        body,
      );
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}
