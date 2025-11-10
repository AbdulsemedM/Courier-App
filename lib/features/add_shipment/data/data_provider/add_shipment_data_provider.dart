import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

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
      print('[DataProvider] addNewShipment called');
      print('[DataProvider] Request body: $body');
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      print('[DataProvider] Making POST request to /api/v1/shipment');
      final response = await apiProvider.postRequest("/api/v1/shipment", body);
      print('[DataProvider] Response status: ${response.statusCode}');
      print('[DataProvider] Response body: ${response.body}');
      return response.body;
    } catch (e) {
      print('[DataProvider] Error in addNewShipment: ${e.toString()}');
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

  Future<String> fetchEstimatedRate(
    int originId,
    int destinationId,
    int serviceModeId,
    int shipmentTypeId,
    int deliveryTypeId,
    String unit,
  ) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest(
        "/api/v1/rate",
        params: {
          "originId": originId,
          "destinationId": destinationId,
          "serviceModeId": serviceModeId,
          "shipmentTypeId": shipmentTypeId,
          "deliveryTypeId": deliveryTypeId,
          "unit": unit.toLowerCase(),
        },
      );
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> initiatePayment(String awb, String paymentMethod,
      String payerAccount, int addedBy) async {
    try {
      final apiProvider =
          ProviderSetup.getApiProvider(ApiConstants.paymentBaseUrl);
      final response =
          await apiProvider.postRequest("/api/v1/payment/initiate", {
        "awb": awb,
        "paymentMethod": paymentMethod,
        "payerAccount": payerAccount,
        "addedBy": addedBy,
      });
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> checkPaymentStatus(String awb) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider
          .getRequest("/api/v1/payment/status", params: {"awb": awb});
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> fetchShipmentDetails(String awb) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider
          .getRequest("/api/v1/shipment-invoice", params: {"awb": awb});
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> fetchShipmentDetailsByTracking(String trackingNumber) async {
    try {
      print(
          '[DataProvider] fetchShipmentDetailsByTracking called with trackingNumber: $trackingNumber');
      // final response = await http.get(
      //   Uri.parse(
      //       '${ApiEndpoints.baseUrl}${ApiEndpoints.shipmentDetails(trackingNumber)}'),
      //   headers: await ApiEndpoints.getHeaders(),
      // );
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      print(
          '[DataProvider] Making GET request to /api/v1/shipment-invoice with awb: $trackingNumber');
      final response = await apiProvider.getRequest("/api/v1/shipment-invoice",
          params: {"awb": trackingNumber});
      print('[DataProvider] Response status: ${response.statusCode}');
      print('[DataProvider] Response body: ${response.body}');
      return response.body;
    } catch (e) {
      print(
          '[DataProvider] Error in fetchShipmentDetailsByTracking: ${e.toString()}');
      print('[DataProvider] Error stack trace: ${StackTrace.current}');
      throw Exception('Failed to fetch shipment details: ${e.toString()}');
    }
  }
}
