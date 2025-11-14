import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class PendingCloseoutDataProvider {
  Future<String> fetchPendingCloseouts({
    int? branchId,
  }) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final params = <String, String>{};
      if (branchId != null) {
        params['branchId'] = branchId.toString();
      }
      final response = await apiProvider.getRequest(
        '/api/v1/pending-closeouts',
        params: params.isNotEmpty ? params : null,
      );
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}

