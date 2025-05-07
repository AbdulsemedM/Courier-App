import 'package:courier_app/features/add_shipment/data/repository/add_shipment_repository.dart';
import 'package:courier_app/features/add_shipment/model/branch_model.dart';
import 'package:courier_app/features/add_shipment/model/delivery_types_model.dart';
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
  AddShipmentBloc(this.addShipmentRepository) : super(AddShipmentInitial()) {
    on<FetchBranches>(_fetchBranches);
    on<FetchDeliveryTypes>(_fetchDeliveryTypes);
    on<FetchPaymentMethods>(_fetchPaymentMethods);
    on<FetchPaymentModes>(_fetchPaymentModes);
    on<FetchServices>(_fetchServices);
    on<FetchShipmentTypes>(_fetchShipmentTypes);
    on<FetchTransportModes>(_fetchTransportModes);
    on<AddShipment>(_addShipment);
  }

  void _fetchBranches(
      FetchBranches event, Emitter<AddShipmentState> emit) async {
    emit(FetchBranchesLoading());
    try {
      final branches = await addShipmentRepository.fetchBranches();
      print("success here");
      emit(FetchBranchesSuccess(branches: branches));
    } catch (e) {
      emit(FetchBranchesFailure(errorMessage: e.toString()));
    }
  }

  void _fetchDeliveryTypes(
      FetchDeliveryTypes event, Emitter<AddShipmentState> emit) async {
    emit(FetchDeliveryTypesLoading());
    try {
      final deliveryTypes = await addShipmentRepository.fetchDeliveryTypes();
      print("success here");
      emit(FetchDeliveryTypesSuccess(deliveryTypes: deliveryTypes));
    } catch (e) {
      emit(FetchDeliveryTypesFailure(errorMessage: e.toString()));
    }
  }

  void _fetchPaymentMethods(
      FetchPaymentMethods event, Emitter<AddShipmentState> emit) async {
    emit(FetchPaymentMethodsLoading());
    try {
      final paymentMethods = await addShipmentRepository.fetchPaymentMethods();
      print("success here");
      emit(FetchPaymentMethodsSuccess(paymentMethods: paymentMethods));
    } catch (e) {
      emit(FetchPaymentMethodsFailure(errorMessage: e.toString()));
    }
  }

  void _fetchPaymentModes(
      FetchPaymentModes event, Emitter<AddShipmentState> emit) async {
    emit(FetchPaymentModesLoading());
    try {
      final paymentModes = await addShipmentRepository.fetchPaymentModes();
      print("success here");
      emit(FetchPaymentModesSuccess(paymentModes: paymentModes));
    } catch (e) {
      emit(FetchPaymentModesFailure(errorMessage: e.toString()));
    }
  }

  void _fetchServices(
      FetchServices event, Emitter<AddShipmentState> emit) async {
    emit(FetchServicesLoading());
    try {
      final services = await addShipmentRepository.fetchServices();
      print("success here");
      emit(FetchServicesSuccess(services: services));
    } catch (e) {
      emit(FetchServicesFailure(errorMessage: e.toString()));
    }
  }

  void _fetchShipmentTypes(
      FetchShipmentTypes event, Emitter<AddShipmentState> emit) async {
    emit(FetchShipmentTypesLoading());
    try {
      final shipmentTypes = await addShipmentRepository.fetchShipmentTypes();
      print("success here");
      emit(FetchShipmentTypesSuccess(shipmentTypes: shipmentTypes));
    } catch (e) {
      emit(FetchShipmentTypesFailure(errorMessage: e.toString()));
    }
  }

  void _fetchTransportModes(
      FetchTransportModes event, Emitter<AddShipmentState> emit) async {
    emit(FetchTransportModesLoading());
    try {
      final transportModes = await addShipmentRepository.fetchTransportModes();
      print("success here");
      emit(FetchTransportModesSuccess(transportModes: transportModes));
    } catch (e) {
      emit(FetchTransportModesFailure(errorMessage: e.toString()));
    }
  }

  void _addShipment(AddShipment event, Emitter<AddShipmentState> emit) async {
    emit(AddShipmentLoading());
    try {
      final response = await addShipmentRepository.addShipment(event.body);
      emit(AddShipmentSuccess(message: response));
    } catch (e) {
      emit(AddShipmentFailure(errorMessage: e.toString()));
    }
  }
}
