import 'package:courier_app/features/shipment_invoice/data/repository/shipment_invoice_repository.dart';
import 'package:courier_app/features/shipment_invoice/model/shipment_invoice_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'shipment_invoice_event.dart';
part 'shipment_invoice_state.dart';

class ShipmentInvoiceBloc
    extends Bloc<ShipmentInvoiceEvent, ShipmentInvoiceState> {
  final ShipmentInvoiceRepository shipmentInvoiceRepository;
  ShipmentInvoiceBloc(this.shipmentInvoiceRepository)
      : super(ShipmentInvoiceInitial()) {
    on<FetchShipmentInvoice>(_fetchShipmentInvoice);
  }
  void _fetchShipmentInvoice(
      FetchShipmentInvoice event, Emitter<ShipmentInvoiceState> emit) async {
    emit(FetchShipmentInvoiceLoading());
    try {
      final shipmentInvoice =
          await shipmentInvoiceRepository.fetchShipmentInvoice(event.awb);
      emit(FetchShipmentInvoiceSuccess(shipmentInvoice: shipmentInvoice));
    } catch (e) {
      emit(FetchShipmentInvoiceFailure(errorMessage: e.toString()));
    }
  }
}
