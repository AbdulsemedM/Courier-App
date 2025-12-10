part of 'add_shipment_bloc.dart';

abstract class AddShipmentState extends Equatable {
  const AddShipmentState();

  @override
  List<Object> get props => [];
}

class AddShipmentInitial extends AddShipmentState {}

class AddShipmentLoading extends AddShipmentState {}

class ShipmentDetailsFetched extends AddShipmentState {
  final PaymentInvoiceModel shipmentDetails;
  const ShipmentDetailsFetched({required this.shipmentDetails});

  @override
  List<Object> get props => [shipmentDetails];
}

class ShipmentDetailsFetchError extends AddShipmentState {
  final String error;
  const ShipmentDetailsFetchError({required this.error});

  @override
  List<Object> get props => [error];
}

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

final class AddShipmentSuccess extends AddShipmentState {
  final String trackingNumber;

  AddShipmentSuccess({required this.trackingNumber});
}

final class AddShipmentFailure extends AddShipmentState {
  final String errorMessage;

  AddShipmentFailure({required this.errorMessage});
}

final class FetchCustomerByPhoneLoading extends AddShipmentState {}

final class FetchCustomerByPhoneSuccess extends AddShipmentState {
  final CustomerByPhone customer;

  FetchCustomerByPhoneSuccess({required this.customer});
}

final class FetchCustomerByPhoneFailure extends AddShipmentState {
  final String errorMessage;

  FetchCustomerByPhoneFailure({required this.errorMessage});
}

final class FetchSenderByPhoneLoading extends AddShipmentState {}

final class FetchSenderByPhoneSuccess extends AddShipmentState {
  final CustomerByPhone customer;

  FetchSenderByPhoneSuccess({required this.customer});
}

final class FetchSenderByPhoneFailure extends AddShipmentState {
  final String errorMessage;

  FetchSenderByPhoneFailure({required this.errorMessage});
}

final class FetchEstimatedRateLoading extends AddShipmentState {}

final class FetchEstimatedRateSuccess extends AddShipmentState {
  final EstimatedRateModel estimatedRate;

  FetchEstimatedRateSuccess({required this.estimatedRate});
}

final class FetchEstimatedRateFailure extends AddShipmentState {
  final String errorMessage;

  FetchEstimatedRateFailure({required this.errorMessage});
}

final class CheckDiscountLoading extends AddShipmentState {}

final class CheckDiscountSuccess extends AddShipmentState {
  final DiscountModel discount;

  CheckDiscountSuccess({required this.discount});

  @override
  List<Object> get props => [discount];
}

final class CheckDiscountFailure extends AddShipmentState {
  final String errorMessage;

  CheckDiscountFailure({required this.errorMessage});
}

final class InitiatePaymentLoading extends AddShipmentState {}

final class InitiatePaymentSuccess extends AddShipmentState {
  final String message;

  InitiatePaymentSuccess({required this.message});
}

final class InitiatePaymentFailure extends AddShipmentState {
  final String errorMessage;
  InitiatePaymentFailure({required this.errorMessage});
}

final class CheckPaymentStatusLoading extends AddShipmentState {}

final class CheckPaymentStatusSuccess extends AddShipmentState {
  final String message;

  CheckPaymentStatusSuccess({required this.message});
}

final class CheckPaymentStatusFailure extends AddShipmentState {
  final String errorMessage;

  CheckPaymentStatusFailure({required this.errorMessage});
}

final class FetchShipmentDetailsLoading extends AddShipmentState {}

final class FetchShipmentDetailsSuccess extends AddShipmentState {
  final PaymentInvoiceModel shipmentDetails;

  FetchShipmentDetailsSuccess({required this.shipmentDetails});
}

final class FetchShipmentDetailsFailure extends AddShipmentState {
  final String errorMessage;

  FetchShipmentDetailsFailure({required this.errorMessage});
}
