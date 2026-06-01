import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/configuration/auth_service.dart';
import 'package:courier_app/providers/provider_setup.dart';

class ShipmentDataProvider {
  Future<String> fetchShipments({String? status}) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final branchId = await AuthService().getBranch();
      final params = <String, String>{};
      if (status != null) params['status'] = status;
      if (branchId != null && branchId.isNotEmpty) {
        params['branchId'] = branchId;
      }
      final response = await apiProvider.getRequest(
        "/api/v1/shipments",
        params: params.isEmpty ? null : params,
      );
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}
