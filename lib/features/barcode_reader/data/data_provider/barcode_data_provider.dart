import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class BarcodeDataProvider {
  Future<String> changeStatus(List<String> shipmentIds, String status) async {
    try {
      final body = {"awbList": shipmentIds, "toStatus": status};
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response =
          await apiProvider.putRequest("/api/v1/shipment-status-change", body);
      // print(response.body);
      return response.body;
    } catch (e) {
      // print("here is the response");
      // print(e.toString());
      throw e.toString();
    }
  }
}
