import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class AddShipmentDataProvider {
  Future<String> fetchBranches() async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest("/api/v1/branches");
      // print(response.body);
      return response.body;
    } catch (e) {
      // print("here is the response");
      // print(e.toString());
      throw e.toString();
    }
  }

  Future<String> fetchDeliveryTypes() async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest("/api/v1/delivery-types");
      // print(response.body);
      return response.body;
    } catch (e) {
      // print("here is the response");
      // print(e.toString());
      throw e.toString();
    }
  }

  Future<String> fetchPaymentMethods() async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest("/api/v1/payment-methods");
      return response.body;
    } catch (e) {
      // print("here is the response");
      // print(e.toString());
      throw e.toString();
    }
  }

  Future<String> fetchPaymentModes() async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest("/api/v1/payment-modes");
      return response.body;
    } catch (e) {
      // print("here is the response");
      // print(e.toString());
      throw e.toString();
    }
  }

  Future<String> fetchServiceModes() async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest("/api/v1/service-modes");
      return response.body;
    } catch (e) {
      // print("here is the response");
      // print(e.toString());
      throw e.toString();
    }
  }

  Future<String> fetchShipmentTypes() async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest("/api/v1/shipment-types");
      return response.body;
    } catch (e) {
      // print("here is the response");
      // print(e.toString());
      throw e.toString();
    }
  }

  Future<String> fetchTransportModes() async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest("/api/v1/transport-modes");
      return response.body;
    } catch (e) {
      // print("here is the response");
      // print(e.toString());
      throw e.toString();
    }
  }

  Future<String> addNewShipment(Map<String, dynamic> body) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.postRequest("/api/v1/shipment", body);
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> fetchCustomerByPhone(String phone) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider
          .getRequest("/api/v1/customer", params: {"phone": phone});
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> fetchEstimatedRate(int originId, int destinationId) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest("/api/v1/rate",
          params: {"originId": originId, "destinationId": destinationId});
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> initiatePayment(
      String awb, String paymentMethod, int addedBy) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response =
          await apiProvider.postRequest("/api/v1/payment/initiate", {
        "awb": awb,
        "paymentMethod": paymentMethod,
        "addedBy": addedBy,
      });
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}
