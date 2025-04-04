import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class ShipmentTypesDataProvider {
  Future<String> fetchShipmentTypes() async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest("/api/v1/shipment-types");
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> addShipmentType(Map<String, dynamic> shipmentType) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response =
          await apiProvider.postRequest("/api/v1/shipment-type", shipmentType);
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}
