import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class ShipmentDataProvider {
  Future<String> fetchShipments({String? status}) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final params = status != null ? {'status': status} : null;
      final response = await apiProvider.getRequest(
        "/api/v1/shipments",
        params: params,
      );
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}
