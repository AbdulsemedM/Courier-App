import 'dart:convert';

import 'package:courier_app/core/services/cache_service.dart';
import 'package:courier_app/features/add_shipment/data/data_provider/add_shipment_data_provider.dart';
import 'package:courier_app/features/add_shipment/model/branch_model.dart';
import 'package:courier_app/features/add_shipment/model/customer_by_phone.dart';
import 'package:courier_app/features/add_shipment/model/delivery_types_model.dart';
import 'package:courier_app/features/add_shipment/model/discount_model.dart';
import 'package:courier_app/features/add_shipment/model/estimated_rate_model.dart';
import 'package:courier_app/features/add_shipment/model/payment_invoice_model.dart';
import 'package:courier_app/features/add_shipment/model/payment_method_model.dart';
import 'package:courier_app/features/add_shipment/model/payment_mode_model.dart';
import 'package:courier_app/features/add_shipment/model/service_modes_model.dart';
import 'package:courier_app/features/add_shipment/model/shipment_type_model.dart';
import 'package:courier_app/features/add_shipment/model/transport_mode_model.dart';

class AddShipmentRepository {
  final AddShipmentDataProvider addShipmentDataProvider;
  final CacheService cacheService;

  AddShipmentRepository({
    required this.addShipmentDataProvider,
    required this.cacheService,
  });

  Future<List<BranchModel>> fetchBranches(bool sync) async {
    try {
      // Try to get from cache first
      if (sync == false) {
        final cachedData = await cacheService.getData('branches');
        if (cachedData != null) {
          print("branches from cache");
          final branches = (cachedData as List)
              .map((branch) => BranchModel.fromJson(branch))
              .toList();
          return branches;
        }
      }
      // If not in cache, fetch from API
      final fetchedBranches = await addShipmentDataProvider.fetchBranches();
      final data = jsonDecode(fetchedBranches);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final branches = (data['data'] as List)
            .map((branch) => BranchModel.fromJson(branch))
            .toList();
        // Save to cache
        await cacheService.saveData('branches', data['data']);
        return branches;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print('Error in fetchBranches: ${e.toString()}');
      rethrow;
    }
  }

  Future<List<DeliveryTypeModel>> fetchDeliveryTypes(bool sync) async {
    try {
      // Try to get from cache first
      if (sync == false) {
        final cachedData = await cacheService.getData('delivery_types');
        if (cachedData != null) {
          print("delivery types from cache");
          final deliveryTypes = (cachedData as List)
              .map((type) => DeliveryTypeModel.fromJson(type))
              .toList();
          return deliveryTypes;
        }
      }

      // If not in cache, fetch from API
      final fetchedDeliveryTypes =
          await addShipmentDataProvider.fetchDeliveryTypes();
      final data = jsonDecode(fetchedDeliveryTypes);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final deliveryTypes = (data['data'] as List)
            .map((type) => DeliveryTypeModel.fromJson(type))
            .toList();
        // Save to cache
        await cacheService.saveData('delivery_types', data['data']);
        return deliveryTypes;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print('Error in fetchDeliveryTypes: ${e.toString()}');
      rethrow;
    }
  }

  Future<List<PaymentMethodModel>> fetchPaymentMethods(bool sync) async {
    try {
      // Try to get from cache first
      if (sync == false) {
        final cachedData = await cacheService.getData('payment_methods');
        if (cachedData != null) {
          print("payment methods from cache");
          final paymentMethods = (cachedData as List)
              .map((method) => PaymentMethodModel.fromJson(method))
              .toList();
          return paymentMethods;
        }
      }

      // If not in cache, fetch from API
      final fetchedPaymentMethods =
          await addShipmentDataProvider.fetchPaymentMethods();
      final data = jsonDecode(fetchedPaymentMethods);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final paymentMethods = (data['data'] as List)
            .map((method) => PaymentMethodModel.fromJson(method))
            .toList();
        // Save to cache
        await cacheService.saveData('payment_methods', data['data']);
        return paymentMethods;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print('Error in fetchPaymentMethods: ${e.toString()}');
      rethrow;
    }
  }

  Future<List<PaymentModeModel>> fetchPaymentModes(bool sync) async {
    try {
      // Try to get from cache first
      if (sync == false) {
        final cachedData = await cacheService.getData('payment_modes');
        if (cachedData != null) {
          print("payment modes from cache");
          final paymentModes = (cachedData as List)
              .map((mode) => PaymentModeModel.fromJson(mode))
              .toList();
          return paymentModes;
        }
      }

      // If not in cache, fetch from API
      final fetchedPaymentModes =
          await addShipmentDataProvider.fetchPaymentModes();
      final data = jsonDecode(fetchedPaymentModes);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final paymentModes = (data['data'] as List)
            .map((mode) => PaymentModeModel.fromJson(mode))
            .toList();
        // Save to cache
        await cacheService.saveData('payment_modes', data['data']);
        return paymentModes;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print('Error in fetchPaymentModes: ${e.toString()}');
      rethrow;
    }
  }

  Future<List<ServiceModeModel>> fetchServices(bool sync) async {
    try {
      // Try to get from cache first
      if (sync == false) {
        final cachedData = await cacheService.getData('services');
        if (cachedData != null) {
          print("services from cache");
          final services = (cachedData as List)
              .map((service) => ServiceModeModel.fromJson(service))
              .toList();
          return services;
        }
      }

      // If not in cache, fetch from API
      final fetchedServices = await addShipmentDataProvider.fetchServiceModes();
      final data = jsonDecode(fetchedServices);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final services = (data['data'] as List)
            .map((service) => ServiceModeModel.fromJson(service))
            .toList();
        // Save to cache
        await cacheService.saveData('services', data['data']);
        return services;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print('Error in fetchServices: ${e.toString()}');
      rethrow;
    }
  }

  Future<List<ShipmentTypeModel>> fetchShipmentTypes(bool sync) async {
    try {
      // Try to get from cache first
      if (sync == false) {
        final cachedData = await cacheService.getData('shipment_types');
        if (cachedData != null) {
          print("shipment types from cache");
          final shipmentTypes = (cachedData as List)
              .map((type) => ShipmentTypeModel.fromJson(type))
              .toList();
          return shipmentTypes;
        }
      }

      // If not in cache, fetch from API
      final fetchedShipmentTypes =
          await addShipmentDataProvider.fetchShipmentTypes();
      final data = jsonDecode(fetchedShipmentTypes);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final shipmentTypes = (data['data'] as List)
            .map((type) => ShipmentTypeModel.fromJson(type))
            .toList();
        // Save to cache
        await cacheService.saveData('shipment_types', data['data']);
        return shipmentTypes;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print('Error in fetchShipmentTypes: ${e.toString()}');
      rethrow;
    }
  }

  Future<List<TransportModeModel>> fetchTransportModes(bool sync) async {
    try {
      // Try to get from cache first
      if (sync == false) {
        final cachedData = await cacheService.getData('transport_modes');
        if (cachedData != null) {
          print("transport modes from cache");
          final transportModes = (cachedData as List)
              .map((mode) => TransportModeModel.fromJson(mode))
              .toList();
          return transportModes;
        }
      }

      // If not in cache, fetch from API
      final fetchedTransportModes =
          await addShipmentDataProvider.fetchTransportModes();
      final data = jsonDecode(fetchedTransportModes);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final transportModes = (data['data'] as List)
            .map((mode) => TransportModeModel.fromJson(mode))
            .toList();
        // Save to cache
        await cacheService.saveData('transport_modes', data['data']);
        return transportModes;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print('Error in fetchTransportModes: ${e.toString()}');
      rethrow;
    }
  }

  // Note: We don't cache addShipment since it's a POST request
  Future<String> addShipment(Map<String, dynamic> body) async {
    try {
      print('[Repository] addShipment called with body: $body');
      final response = await addShipmentDataProvider.addNewShipment(body);
      print('[Repository] Received response: $response');
      final data = jsonDecode(response);
      print('[Repository] Parsed data: $data');
      if (data['status'] != 200) {
        print(
            '[Repository] Error status: ${data['status']}, message: ${data['message']}');
        throw data['message'];
      }
      // Extract AWB from message string or data.data.awb
      String? awb;
      if (data['data'] != null && data['data']['awb'] != null) {
        // If AWB is in data.data.awb
        awb = data['data']['awb'].toString();
        print('[Repository] Extracted AWB from data.data.awb: $awb');
      } else if (data['message'] != null) {
        // Extract AWB from message string (format: "ETAA34664 Shipment created successfully...")
        final message = data['message'].toString();
        print('[Repository] Message: $message');
        // AWB is typically at the start of the message, extract it using regex
        final awbMatch = RegExp(r'[A-Z]{3,4}\d{5,}').firstMatch(message);
        if (awbMatch != null) {
          awb = awbMatch.group(0);
          print('[Repository] Extracted AWB from message: $awb');
        }
      }

      if (awb != null && awb.isNotEmpty) {
        return awb;
      } else {
        print('[Repository] Error: AWB not found in response');
        throw 'AWB not found in response';
      }
    } catch (e) {
      print('[Repository] Error in addShipment: ${e.toString()}');
      rethrow;
    }
  }

  // Note: We don't cache customer phone lookups since they need to be real-time
  Future<CustomerByPhone> fetchCustomerByPhone(String phoneNumber) async {
    try {
      final response =
          await addShipmentDataProvider.fetchCustomerByPhone(phoneNumber);
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      return CustomerByPhone.fromMap(data['data']);
    } catch (e) {
      print('Error in fetchCustomerByPhone: ${e.toString()}');
      rethrow;
    }
  }

  Future<EstimatedRateModel> fetchEstimatedRate(
    int originId,
    int destinationId,
    int serviceModeId,
    int shipmentTypeId,
    int deliveryTypeId,
    String unit,
  ) async {
    try {
      final response = await addShipmentDataProvider.fetchEstimatedRate(
        originId,
        destinationId,
        serviceModeId,
        shipmentTypeId,
        deliveryTypeId,
        unit,
      );
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      // API returns data as an array, so we need to access the first element
      final dataList = data['data'] as List;
      if (dataList.isEmpty) {
        throw 'No rate data found';
      }
      return EstimatedRateModel.fromMap(dataList[0] as Map<String, dynamic>);
    } catch (e) {
      print('Error in fetchEstimatedRate: ${e.toString()}');
      rethrow;
    }
  }

  Future<DiscountModel> checkDiscount(
    int originId,
    int destinationId,
    int serviceModeId,
    int shipmentTypeId,
    int deliveryTypeId,
    String unit,
    double weightKg,
    double discountPricePerKg,
  ) async {
    try {
      final response = await addShipmentDataProvider.checkDiscount(
        originId,
        destinationId,
        serviceModeId,
        shipmentTypeId,
        deliveryTypeId,
        unit,
        weightKg,
        discountPricePerKg,
      );
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      final discountData =
          DiscountModel.fromMap(data['data'] as Map<String, dynamic>);
      // Round big decimal numbers
      return discountData.rounded();
    } catch (e) {
      print('Error in checkDiscount: ${e.toString()}');
      rethrow;
    }
  }

  Future<String> initiatePayment(String awb, String paymentMethod,
      String payerAccount, int addedBy) async {
    try {
      final response = await addShipmentDataProvider.initiatePayment(
          awb, paymentMethod, payerAccount, addedBy);
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      return data['message'];
    } catch (e) {
      print('Error in initiatePayment: ${e.toString()}');
      rethrow;
    }
  }

  Future<String> checkPaymentStatus(String awb) async {
    try {
      final response = await addShipmentDataProvider.checkPaymentStatus(awb);

      final data = jsonDecode(response);
      if (data['message'] != "SUCCESS") {
        throw data['message'];
      }
      return data['message'];
    } catch (e) {
      print('Error in checkPaymentStatus: ${e.toString()}');
      rethrow;
    }
  }

  Future<PaymentInvoiceModel> fetchShipmentDetails(String awb) async {
    try {
      final response = await addShipmentDataProvider.fetchShipmentDetails(awb);
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      return PaymentInvoiceModel.fromJson(data['data']);
    } catch (e) {
      print('Error in fetchShipmentDetails: ${e.toString()}');
      rethrow;
    }
  }

  Future<PaymentInvoiceModel> fetchShipmentDetailsByTracking(
      String trackingNumber) async {
    try {
      print(
          '[Repository] fetchShipmentDetailsByTracking called with trackingNumber: $trackingNumber');
      final response = await addShipmentDataProvider
          .fetchShipmentDetailsByTracking(trackingNumber);
      print('[Repository] Received response: $response');
      final data = jsonDecode(response);
      print('[Repository] Parsed data: $data');
      if (data['status'] != 200) {
        print(
            '[Repository] Error status: ${data['status']}, message: ${data['message']}');
        throw data['message'];
      }
      if (data['data'] == null) {
        print('[Repository] Error: data field is null in response');
        throw 'Shipment details data is null';
      }
      print(
          '[Repository] Attempting to parse PaymentInvoiceModel from data: ${data['data']}');
      final model = PaymentInvoiceModel.fromMap(data['data']);
      print('[Repository] Successfully parsed PaymentInvoiceModel');
      return model;
    } catch (e) {
      print(
          '[Repository] Error in fetchShipmentDetailsByTracking: ${e.toString()}');
      print('[Repository] Error type: ${e.runtimeType}');
      print('[Repository] Error stack trace: ${StackTrace.current}');
      throw Exception('Failed to fetch shipment details: ${e.toString()}');
    }
  }
}
