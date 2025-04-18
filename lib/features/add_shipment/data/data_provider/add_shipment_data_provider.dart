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

  Future<String> addNewShipment(
      String senderName,
      String senderMobile,
      String receiverName,
      String receiverMobile,
      int senderBranchId,
      int receiverBranchId,
      int quantity,
      String unit,
      int numPcs,
      int numBoxes,
      double rate,
      double extraFee,
      String extraFeeDescription,
      String shipmentDescription,
      int serviceModeId,
      int paymentMethodId,
      int deliveryTypeId,
      int transportModeId,
      String creditAccount,
      int addedBy,
      int shipmentTypeId,
      double hudhudPercent,
      double hudhudNet) async {
    final body = {
      "senderName": senderName,
      "senderMobile": senderMobile,
      "receiverName": receiverName,
      "receiverMobile": receiverMobile,
      "senderBranchId": senderBranchId,
      "receiverBranchId": receiverBranchId,
      "quantity": quantity,
      "unit": unit,
      "numPcs": numPcs,
      "numBoxes": numBoxes,
      "rate": rate,
      "extraFee": extraFee,
      "extraFeeDescription": extraFeeDescription,
      "shipmentDescription": shipmentDescription,
      "serviceModeId": serviceModeId,
      "paymentMethodId": paymentMethodId,
      "deliveryTypeId": deliveryTypeId,
      "transportModeId": transportModeId,
      "creditAccount": creditAccount,
      "addedBy": addedBy,
      "shipmentTypeId": shipmentTypeId,
      "hudhudPercent": hudhudPercent,
      "hudhudNet": hudhudNet
    };
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.postRequest("/api/v1/shipment", body);
      return response.body;
    } catch (e) {
      // print("here is the response");
      // print(e.toString());
      throw e.toString();
    }
  }
}
