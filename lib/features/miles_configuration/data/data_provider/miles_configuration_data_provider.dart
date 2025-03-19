import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class MilesConfigurationDataProvider {
  Future<String> getMilesConfiguration() async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest("/api/v1/miles-config");
      // print(response.body);
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> addMilesConfiguration(int originBranchId,
      int destinationBranchId, String unit, int milesPerUnit) async {
    try {
      final body = {
        "originBranchId": originBranchId,
        "destinationBranchId": destinationBranchId,
        "unit": unit,
        "milesPerUnit": milesPerUnit
      };
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response =
          await apiProvider.postRequest("/api/v1/mile-config", body);
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}
