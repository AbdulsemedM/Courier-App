import 'package:courier_app/features/add_shipment/data/repository/add_shipment_repository.dart';
import 'package:courier_app/features/add_shipment/model/branch_model.dart';
import 'package:courier_app/features/add_shipment/model/customer_by_phone.dart';
import 'package:courier_app/features/add_shipment/model/delivery_types_model.dart';
import 'package:courier_app/features/add_shipment/model/estimated_rate_model.dart';
import 'package:courier_app/features/add_shipment/model/payment_method_model.dart';
import 'package:courier_app/features/add_shipment/model/payment_mode_model.dart';
import 'package:courier_app/features/add_shipment/model/service_modes_model.dart';
import 'package:courier_app/features/add_shipment/model/shipment_type_model.dart';
import 'package:courier_app/features/add_shipment/model/transport_mode_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

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
    on<InitiatePaymentEvent>(_initiatePayment);
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
    emit(AddShipmentLoading());
    try {
      final response = await _retryOperation(
          () => addShipmentRepository.addShipment(event.body), 'addShipment');
      emit(AddShipmentSuccess(trackingNumber: response));
    } catch (e) {
      emit(AddShipmentFailure(errorMessage: e.toString()));
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
      emit(FetchCustomerByPhoneFailure(errorMessage: e.toString()));
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
      emit(FetchSenderByPhoneFailure(errorMessage: e.toString()));
    }
  }

  void _fetchEstimatedRate(
      FetchEstimatedRate event, Emitter<AddShipmentState> emit) async {
    emit(FetchEstimatedRateLoading());
    try {
      final response = await _retryOperation(
          () => addShipmentRepository.fetchEstimatedRate(
              event.originId, event.destinationId),
          'fetchEstimatedRate');
      emit(FetchEstimatedRateSuccess(estimatedRate: response));
    } catch (e) {
      emit(FetchEstimatedRateFailure(errorMessage: e.toString()));
    }
  }

  void _initiatePayment(
      InitiatePaymentEvent event, Emitter<AddShipmentState> emit) async {
    emit(InitiatePaymentLoading());
    try {
      final response = await _retryOperation(
          () => addShipmentRepository.initiatePayment(
              event.awb, event.paymentMethod, event.addedBy),
          'initiatePayment');
      emit(InitiatePaymentSuccess(message: response));
    } catch (e) {
      emit(InitiatePaymentFailure(errorMessage: e.toString()));
    }
  }
}
