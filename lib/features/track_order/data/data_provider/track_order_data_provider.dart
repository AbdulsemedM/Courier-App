import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class TrackOrderDataProvider {
  Future<String> fetchOrders() async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest("/api/v1/all-shipments");
      // print(response.body);
      return response.body;
    } catch (e) {
      // print("here is the response");
      // print(e.toString());
      throw e.toString();
    }
  }
}
