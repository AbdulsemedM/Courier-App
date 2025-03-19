import 'dart:convert';

import 'package:courier_app/features/add_shipment/data/data_provider/add_shipment_data_provider.dart';
import 'package:courier_app/features/add_shipment/model/branch_model.dart';
import 'package:courier_app/features/add_shipment/model/delivery_types_model.dart';
import 'package:courier_app/features/add_shipment/model/payment_method_model.dart';
import 'package:courier_app/features/add_shipment/model/payment_mode_model.dart';
import 'package:courier_app/features/add_shipment/model/service_modes_model.dart';
import 'package:courier_app/features/add_shipment/model/shipment_type_model.dart';
import 'package:courier_app/features/add_shipment/model/transport_mode_model.dart';

class AddShipmentRepository {
  final AddShipmentDataProvider addShipmentDataProvider =
      AddShipmentDataProvider();

  Future<List<BranchModel>> fetchBranches() async {
    try {
      final response = await addShipmentDataProvider.fetchBranches();
      final data = jsonDecode(response);

      if (data['status'] != 200) {
        throw data['message'] ?? 'Failed to fetch branches';
      }

      if (data['data'] is List) {
        final branches = (data['data'] as List)
            .map((branch) => BranchModel.fromJson(branch))
            .toList();
        return branches;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print('Error in fetchBranches: ${e.toString()}');
      rethrow;
    }
  }

  Future<List<DeliveryTypeModel>> fetchDeliveryTypes() async {
    try {
      final fetchedDeliveryTypes =
          await addShipmentDataProvider.fetchDeliveryTypes();

      final data = jsonDecode(fetchedDeliveryTypes);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final deliveryTypes = (data['data'] as List)
            .map((deliveryType) => DeliveryTypeModel.fromJson(deliveryType))
            .toList();
        return deliveryTypes;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print('Error in fetchDeliveryTypes: ${e.toString()}');
      rethrow;
    }
  }

  Future<List<PaymentMethodModel>> fetchPaymentMethods() async {
    try {
      final fetchedPaymentMethods =
          await addShipmentDataProvider.fetchPaymentMethods();

      final data = jsonDecode(fetchedPaymentMethods);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final paymentMethods = (data['data'] as List)
            .map((paymentMethod) => PaymentMethodModel.fromJson(paymentMethod))
            .toList();
        return paymentMethods;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print('Error in fetchPaymentMethods: ${e.toString()}');
      rethrow;
    }
  }

  Future<List<PaymentModeModel>> fetchPaymentModes() async {
    try {
      final fetchedPaymentModes =
          await addShipmentDataProvider.fetchPaymentModes();

      final data = jsonDecode(fetchedPaymentModes);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final paymentModes = (data['data'] as List)
            .map((paymentMode) => PaymentModeModel.fromJson(paymentMode))
            .toList();
        return paymentModes;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print('Error in fetchPaymentModes: ${e.toString()}');
      rethrow;
    }
  }

  Future<List<ServiceModeModel>> fetchServices() async {
    try {
      final fetchedServices = await addShipmentDataProvider.fetchServiceModes();

      final data = jsonDecode(fetchedServices);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final services = (data['data'] as List)
            .map((service) => ServiceModeModel.fromJson(service))
            .toList();
        return services;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print('Error in fetchServices: ${e.toString()}');
      rethrow;
    }
  }

  Future<List<ShipmentTypeModel>> fetchShipmentTypes() async {
    try {
      final fetchedShipmentTypes =
          await addShipmentDataProvider.fetchShipmentTypes();
      final data = jsonDecode(fetchedShipmentTypes);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final shipmentTypes = (data['data'] as List)
            .map((shipmentType) => ShipmentTypeModel.fromJson(shipmentType))
            .toList();
        return shipmentTypes;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print('Error in fetchShipmentTypes: ${e.toString()}');
      rethrow;
    }
  }

  Future<List<TransportModeModel>> fetchTransportModes() async {
    try {
      final fetchedTransportModes =
          await addShipmentDataProvider.fetchTransportModes();

      final data = jsonDecode(fetchedTransportModes);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final transportModes = (data['data'] as List)
            .map((transportMode) => TransportModeModel.fromJson(transportMode))
            .toList();
        return transportModes;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print('Error in fetchTransportModes: ${e.toString()}');
      rethrow;
    }
  }
  
}
