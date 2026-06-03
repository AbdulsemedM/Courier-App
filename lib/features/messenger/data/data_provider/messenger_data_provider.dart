import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class MessengerDataProvider {
  Future<String> fetchMessengersByBranch(int branchId, {String? status}) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final params = status != null ? {'status': status} : null;
      final response = await apiProvider.getRequest(
        '/api/v1/messenger/branch/$branchId',
        params: params,
      );
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> fetchAvailableMessengers(int branchId) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest(
        '/api/v1/messenger/available/$branchId',
      );
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}
