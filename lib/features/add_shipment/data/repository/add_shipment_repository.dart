import 'dart:convert';

import 'package:courier_app/core/services/cache_service.dart';
import 'package:courier_app/features/add_shipment/data/data_provider/add_shipment_data_provider.dart';
import 'package:courier_app/features/add_shipment/model/branch_model.dart';
import 'package:courier_app/features/add_shipment/model/customer_by_phone.dart';
import 'package:courier_app/features/add_shipment/model/delivery_types_model.dart';
import 'package:courier_app/features/add_shipment/model/estimated_rate_model.dart';
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
      final response = await addShipmentDataProvider.addNewShipment(body);
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      final message = data['message'];
      final subString = message.substring(0, 9);
      return subString;
    } catch (e) {
      print('Error in addShipment: ${e.toString()}');
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
      int originId, int destinationId) async {
    try {
      final response = await addShipmentDataProvider.fetchEstimatedRate(
          originId, destinationId);
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      return EstimatedRateModel.fromMap(data['data']);
    } catch (e) {
      print('Error in fetchEstimatedRate: ${e.toString()}');
      rethrow;
    }
  }

  Future<String> initiatePayment(
      String awb, String paymentMethod, int addedBy) async {
    try {
      final response = await addShipmentDataProvider.initiatePayment(
          awb, paymentMethod, addedBy);
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
}
