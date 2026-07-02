import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class ShelvesDataProvider {
  Future<String> fetchShelves() async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest("/api/v1/shelves");
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> fetchShelvesByBranch(int branchId) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response =
          await apiProvider.getRequest("/api/v1/shelves/branch/$branchId");
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> transferShelf({
    required String awbNumber,
    required int toShelfId,
    required String reason,
  }) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.postRequest('/api/v1/shelf/transfer', {
        'awbNumber': awbNumber,
        'toShelfId': toShelfId,
        'reason': reason,
      });
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}
