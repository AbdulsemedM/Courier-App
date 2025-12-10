import 'dart:convert';
import 'package:courier_app/features/add_shipment/data/repository/add_shipment_repository.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';

part 'add_shipment_event.dart';
part 'add_shipment_state.dart';

class AddShipmentBloc extends Bloc<AddShipmentEvent, AddShipmentState> {
  final AddShipmentRepository addShipmentRepository;
  static const maxRetries = 3;

  AddShipmentBloc(this.addShipmentRepository) : super(AddShipmentInitial()) {
    on<FetchBranches>(_fetchBranches);
    on<FetchDeliveryTypes>(_fetchDeliveryTypes);
    on<FetchPaymentMethods>(_fetchPaymentMethods);
    on<FetchPaymentModes>(_fetchPaymentModes);
    on<FetchServices>(_fetchServices);
    on<FetchShipmentTypes>(_fetchShipmentTypes);
    on<FetchTransportModes>(_fetchTransportModes);
    on<AddShipment>(_addShipment);
    on<FetchCustomerByPhone>(_fetchCustomerByPhone);
    on<FetchSenderByPhone>(_fetchSenderByPhone);
    on<FetchEstimatedRate>(_fetchEstimatedRate);
    on<CheckDiscount>(_checkDiscount);
    on<InitiatePaymentEvent>(_initiatePayment);
    on<CheckPaymentStatusEvent>(_checkPaymentStatus);
    on<FetchShipmentDetailsEvent>(_fetchShipmentDetails);
  }

  // Helper method to extract error message from exception
  String _extractErrorMessage(dynamic e) {
    String errorMessage = e.toString();

    // Remove "Exception: " prefix if present
    if (errorMessage.startsWith('Exception: ')) {
      errorMessage = errorMessage.substring(11);
    }

    // Try to parse as JSON and extract message field
    try {
      final data = jsonDecode(errorMessage);
      if (data is Map && data.containsKey('message')) {
        return data['message'].toString();
      }
    } catch (_) {
      // If parsing fails, return the error message as is
    }

    return errorMessage;
  }

  // Helper method to handle retries
  Future<T> _retryOperation<T>(
      Future<T> Function() operation, String operationName) async {
    int attempts = 0;
    while (attempts < maxRetries) {
      try {
        return await operation();
      } catch (e) {
        attempts++;
        if (attempts == maxRetries) {
          print(
              '$operationName failed after $maxRetries attempts: ${e.toString()}');
          rethrow;
        }
        // Exponential backoff: 500ms, 1000ms, 2000ms
        await Future.delayed(
            Duration(milliseconds: 500 * (1 << (attempts - 1))));
        print('Retrying $operationName attempt $attempts');
      }
    }
    throw Exception('Should not reach here');
  }

  void _fetchBranches(
      FetchBranches event, Emitter<AddShipmentState> emit) async {
    emit(FetchBranchesLoading());
    try {
      final branches = await _retryOperation(
          () => addShipmentRepository.fetchBranches(event.sync),
          'fetchBranches');
      emit(FetchBranchesSuccess(branches: branches));
    } catch (e) {
      emit(FetchBranchesFailure(errorMessage: e.toString()));
    }
  }

  void _fetchDeliveryTypes(
      FetchDeliveryTypes event, Emitter<AddShipmentState> emit) async {
    emit(FetchDeliveryTypesLoading());
    try {
      final deliveryTypes = await _retryOperation(
          () => addShipmentRepository.fetchDeliveryTypes(event.sync),
          'fetchDeliveryTypes');
      emit(FetchDeliveryTypesSuccess(deliveryTypes: deliveryTypes));
    } catch (e) {
      emit(FetchDeliveryTypesFailure(errorMessage: e.toString()));
    }
  }

  void _fetchPaymentMethods(
      FetchPaymentMethods event, Emitter<AddShipmentState> emit) async {
    emit(FetchPaymentMethodsLoading());
    try {
      final paymentMethods = await _retryOperation(
          () => addShipmentRepository.fetchPaymentMethods(event.sync),
          'fetchPaymentMethods');
      emit(FetchPaymentMethodsSuccess(paymentMethods: paymentMethods));
    } catch (e) {
      emit(FetchPaymentMethodsFailure(errorMessage: e.toString()));
    }
  }

  void _fetchPaymentModes(
      FetchPaymentModes event, Emitter<AddShipmentState> emit) async {
    emit(FetchPaymentModesLoading());
    try {
      final paymentModes = await _retryOperation(
          () => addShipmentRepository.fetchPaymentModes(event.sync),
          'fetchPaymentModes');
      emit(FetchPaymentModesSuccess(paymentModes: paymentModes));
    } catch (e) {
      emit(FetchPaymentModesFailure(errorMessage: e.toString()));
    }
  }

  void _fetchServices(
      FetchServices event, Emitter<AddShipmentState> emit) async {
    emit(FetchServicesLoading());
    try {
      final services = await _retryOperation(
          () => addShipmentRepository.fetchServices(event.sync),
          'fetchServices');
      emit(FetchServicesSuccess(services: services));
    } catch (e) {
      emit(FetchServicesFailure(errorMessage: e.toString()));
    }
  }

  void _fetchShipmentTypes(
      FetchShipmentTypes event, Emitter<AddShipmentState> emit) async {
    emit(FetchShipmentTypesLoading());
    try {
      final shipmentTypes = await _retryOperation(
          () => addShipmentRepository.fetchShipmentTypes(event.sync),
          'fetchShipmentTypes');
      emit(FetchShipmentTypesSuccess(shipmentTypes: shipmentTypes));
    } catch (e) {
      emit(FetchShipmentTypesFailure(errorMessage: e.toString()));
    }
  }

  void _fetchTransportModes(
      FetchTransportModes event, Emitter<AddShipmentState> emit) async {
    emit(FetchTransportModesLoading());
    try {
      final transportModes = await _retryOperation(
          () => addShipmentRepository.fetchTransportModes(event.sync),
          'fetchTransportModes');
      emit(FetchTransportModesSuccess(transportModes: transportModes));
    } catch (e) {
      emit(FetchTransportModesFailure(errorMessage: e.toString()));
    }
  }

  void _addShipment(AddShipment event, Emitter<AddShipmentState> emit) async {
    print('[Bloc] _addShipment called');
    print('[Bloc] Event body: ${event.body}');
    emit(AddShipmentLoading());
    try {
      print('[Bloc] Calling repository.addShipment');
      final response = await _retryOperation(
          () => addShipmentRepository.addShipment(event.body), 'addShipment');
      print('[Bloc] Received tracking number from repository: $response');
      emit(AddShipmentSuccess(trackingNumber: response));
      print('[Bloc] Emitted AddShipmentSuccess with trackingNumber: $response');
    } catch (e) {
      // Extract just the message from the exception
      String errorMessage = _extractErrorMessage(e);
      print('[Bloc] Error in _addShipment: $errorMessage');
      emit(AddShipmentFailure(errorMessage: errorMessage));
    }
  }

  void _fetchCustomerByPhone(
      FetchCustomerByPhone event, Emitter<AddShipmentState> emit) async {
    emit(FetchCustomerByPhoneLoading());
    try {
      final response = await _retryOperation(
          () => addShipmentRepository.fetchCustomerByPhone(event.phoneNumber),
          'fetchCustomerByPhone');
      emit(FetchCustomerByPhoneSuccess(customer: response));
    } catch (e) {
      // Extract just the message from the exception
      String errorMessage = _extractErrorMessage(e);
      emit(FetchCustomerByPhoneFailure(errorMessage: errorMessage));
    }
  }

  void _fetchSenderByPhone(
      FetchSenderByPhone event, Emitter<AddShipmentState> emit) async {
    emit(FetchSenderByPhoneLoading());
    try {
      final response = await _retryOperation(
          () => addShipmentRepository.fetchCustomerByPhone(event.phoneNumber),
          'fetchSenderByPhone');
      emit(FetchSenderByPhoneSuccess(customer: response));
    } catch (e) {
      // Extract just the message from the exception
      String errorMessage = _extractErrorMessage(e);
      emit(FetchSenderByPhoneFailure(errorMessage: errorMessage));
    }
  }

  void _fetchEstimatedRate(
      FetchEstimatedRate event, Emitter<AddShipmentState> emit) async {
    emit(FetchEstimatedRateLoading());
    try {
      final response = await _retryOperation(
          () => addShipmentRepository.fetchEstimatedRate(
                event.originId,
                event.destinationId,
                event.serviceModeId,
                event.shipmentTypeId,
                event.deliveryTypeId,
                event.unit,
              ),
          'fetchEstimatedRate');
      emit(FetchEstimatedRateSuccess(estimatedRate: response));
    } catch (e) {
      // Extract just the message from the exception
      String errorMessage = _extractErrorMessage(e);
      emit(FetchEstimatedRateFailure(errorMessage: errorMessage));
    }
  }

  void _checkDiscount(
      CheckDiscount event, Emitter<AddShipmentState> emit) async {
    emit(CheckDiscountLoading());
    try {
      final response = await _retryOperation(
          () => addShipmentRepository.checkDiscount(
                event.originId,
                event.destinationId,
                event.serviceModeId,
                event.shipmentTypeId,
                event.deliveryTypeId,
                event.unit,
                event.weightKg,
                event.discountPricePerKg,
              ),
          'checkDiscount');
      emit(CheckDiscountSuccess(discount: response));
    } catch (e) {
      // Extract just the message from the exception
      String errorMessage = _extractErrorMessage(e);
      emit(CheckDiscountFailure(errorMessage: errorMessage));
    }
  }

  void _initiatePayment(
      InitiatePaymentEvent event, Emitter<AddShipmentState> emit) async {
    emit(InitiatePaymentLoading());
    try {
      final response = await _retryOperation(
          () => addShipmentRepository.initiatePayment(event.awb,
              event.paymentMethod, event.payerAccount, event.addedBy),
          'initiatePayment');
      emit(InitiatePaymentSuccess(message: response));
    } catch (e) {
      emit(InitiatePaymentFailure(errorMessage: e.toString()));
    }
  }

  void _checkPaymentStatus(
      CheckPaymentStatusEvent event, Emitter<AddShipmentState> emit) async {
    emit(CheckPaymentStatusLoading());
    try {
      final response = await _retryOperation(
          () => addShipmentRepository.checkPaymentStatus(event.awb),
          'checkPaymentStatus');
      emit(CheckPaymentStatusSuccess(message: response));
    } catch (e) {
      emit(CheckPaymentStatusFailure(errorMessage: e.toString()));
    }
  }

  void _fetchShipmentDetails(
      FetchShipmentDetailsEvent event, Emitter<AddShipmentState> emit) async {
    try {
      print(
          '[Bloc] _fetchShipmentDetails called with trackingNumber: ${event.trackingNumber}');
      emit(FetchShipmentDetailsLoading());
      print('[Bloc] Emitted FetchShipmentDetailsLoading');
      final details = await addShipmentRepository
          .fetchShipmentDetailsByTracking(event.trackingNumber);
      print('[Bloc] Received shipment details from repository');
      print('[Bloc] Shipment details: ${details.toString()}');
      emit(ShipmentDetailsFetched(shipmentDetails: details));
      print('[Bloc] Emitted ShipmentDetailsFetched');
    } catch (e) {
      String errorMessage = _extractErrorMessage(e);
      print('[Bloc] Error in _fetchShipmentDetails: $errorMessage');
      print('[Bloc] Error type: ${e.runtimeType}');
      print('[Bloc] Error stack trace: ${StackTrace.current}');
      emit(ShipmentDetailsFetchError(error: errorMessage));
      print('[Bloc] Emitted ShipmentDetailsFetchError');
    }
  }
}
