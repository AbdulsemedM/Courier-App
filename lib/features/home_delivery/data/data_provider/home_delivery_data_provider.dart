import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class HomeDeliveryDataProvider {
  Future<String> fetchByBranch(int branchId, {String? status}) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final params = status != null ? {'status': status} : null;
      final response = await apiProvider.getRequest(
        '/api/v1/home-delivery/branch/$branchId',
        params: params,
      );
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> fetchUnassigned(int branchId) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest(
        '/api/v1/home-delivery/unassigned/$branchId',
      );
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> fetchOverdue(int branchId) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest(
        '/api/v1/home-delivery/overdue/$branchId',
      );
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> assignMessenger({
    required String awb,
    required int messengerId,
    required int assignedBy,
    required String estimatedDeliveryTime,
  }) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.postRequest(
        '/api/v1/home-delivery/assign',
        {
          'awb': awb,
          'messengerId': messengerId,
          'assignedBy': assignedBy,
          'estimatedDeliveryTime': estimatedDeliveryTime,
        },
      );
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}
