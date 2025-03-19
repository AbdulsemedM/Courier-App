import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class ShipmentDataProvider {
  Future<String> fetchShipments() async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest("/api/v1/all-shipments");
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}
