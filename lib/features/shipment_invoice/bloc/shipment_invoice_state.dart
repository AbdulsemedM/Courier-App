part of 'shipment_invoice_bloc.dart';

@immutable
sealed class ShipmentInvoiceState {}

final class ShipmentInvoiceInitial extends ShipmentInvoiceState {}

final class FetchShipmentInvoiceLoading extends ShipmentInvoiceState {}

final class FetchShipmentInvoiceSuccess extends ShipmentInvoiceState {
  final ShipmentInvoiceModel shipmentInvoice;

  FetchShipmentInvoiceSuccess({required this.shipmentInvoice});
}

final class FetchShipmentInvoiceFailure extends ShipmentInvoiceState {
  final String errorMessage;

  FetchShipmentInvoiceFailure({required this.errorMessage});
}
