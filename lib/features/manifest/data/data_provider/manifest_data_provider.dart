import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class ManifestDataProvider {
  Future<String> fetchManifests({
    required int branchId,
    required String date,
  }) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest(
        '/api/v1/manifest-shipment',
        params: {
          'branchId': branchId,
          'date': date,
        },
      );
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> createManifest({
    required List<String> awbs,
    required String fileType,
    required int userId,
  }) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.postRequest(
        '/api/v1/shipments/manifest',
        {
          'awbs': awbs,
          'fileType': fileType,
          'userId': userId,
        },
      );
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}
