import 'dart:convert';

import 'package:courier_app/features/shipment_invoice/data/data_provider/shipment_invoice_data_provider.dart';
import 'package:courier_app/features/shipment_invoice/model/shipment_invoice_model.dart';

class ShipmentInvoiceRepository {
  final ShipmentInvoiceDataProvider shipmentInvoiceDataProvider;

  ShipmentInvoiceRepository({required this.shipmentInvoiceDataProvider});

  Future<ShipmentInvoiceModel> fetchShipmentInvoice(String awb) async {
    try {
      final response =
          await shipmentInvoiceDataProvider.fetchShipmentInvoice(awb);
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      final invoice = ShipmentInvoiceModel.fromMap(data['data']);
      return invoice;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
