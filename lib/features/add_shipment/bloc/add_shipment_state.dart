part of 'add_shipment_bloc.dart';

@immutable
sealed class AddShipmentState {}

final class AddShipmentInitial extends AddShipmentState {}

final class FetchBranchesLoading extends AddShipmentState {}

final class FetchBranchesSuccess extends AddShipmentState {
  final List<BranchModel> branches;

  FetchBranchesSuccess({required this.branches});
}

final class FetchBranchesFailure extends AddShipmentState {
  final String errorMessage;

  FetchBranchesFailure({required this.errorMessage});
}

final class FetchDeliveryTypesLoading extends AddShipmentState {}

final class FetchDeliveryTypesSuccess extends AddShipmentState {
  final List<DeliveryTypeModel> deliveryTypes;

  FetchDeliveryTypesSuccess({required this.deliveryTypes});
}

final class FetchDeliveryTypesFailure extends AddShipmentState {
  final String errorMessage;

  FetchDeliveryTypesFailure({required this.errorMessage});
}

final class FetchPaymentMethodsLoading extends AddShipmentState {}

final class FetchPaymentMethodsSuccess extends AddShipmentState {
  final List<PaymentMethodModel> paymentMethods;

  FetchPaymentMethodsSuccess({required this.paymentMethods});
}

final class FetchPaymentMethodsFailure extends AddShipmentState {
  final String errorMessage;

  FetchPaymentMethodsFailure({required this.errorMessage});
}

final class FetchPaymentModesLoading extends AddShipmentState {}

final class FetchPaymentModesSuccess extends AddShipmentState {
  final List<PaymentModeModel> paymentModes;

  FetchPaymentModesSuccess({required this.paymentModes});
}

final class FetchPaymentModesFailure extends AddShipmentState {
  final String errorMessage;

  FetchPaymentModesFailure({required this.errorMessage});
}

final class FetchServicesLoading extends AddShipmentState {}

final class FetchServicesSuccess extends AddShipmentState {
  final List<ServiceModeModel> services;

  FetchServicesSuccess({required this.services});
}

final class FetchServicesFailure extends AddShipmentState {
  final String errorMessage;

  FetchServicesFailure({required this.errorMessage});
}

final class FetchShipmentTypesLoading extends AddShipmentState {}

final class FetchShipmentTypesSuccess extends AddShipmentState {
  final List<ShipmentTypeModel> shipmentTypes;

  FetchShipmentTypesSuccess({required this.shipmentTypes});
}

final class FetchShipmentTypesFailure extends AddShipmentState {
  final String errorMessage;

  FetchShipmentTypesFailure({required this.errorMessage});
}

final class FetchTransportModesLoading extends AddShipmentState {}

final class FetchTransportModesSuccess extends AddShipmentState {
  final List<TransportModeModel> transportModes;

  FetchTransportModesSuccess({required this.transportModes});
}

final class FetchTransportModesFailure extends AddShipmentState {
  final String errorMessage;

  FetchTransportModesFailure({required this.errorMessage});
}

final class AddShipmentLoading extends AddShipmentState {}

final class AddShipmentSuccess extends AddShipmentState {
  final String message;

  AddShipmentSuccess({required this.message});
}

final class AddShipmentFailure extends AddShipmentState {
  final String errorMessage;

  AddShipmentFailure({required this.errorMessage});
}
