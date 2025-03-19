part of 'shipment_invoice_bloc.dart';

@immutable
sealed class ShipmentInvoiceEvent {}

class FetchShipmentInvoice extends ShipmentInvoiceEvent {
  final String awb;

  FetchShipmentInvoice({required this.awb});
}
