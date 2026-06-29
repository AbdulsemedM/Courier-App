import 'dart:convert';

import 'package:courier_app/features/branches/data/repository/branches_repository.dart';
import 'package:courier_app/features/shipment_invoice/data/data_provider/shipment_invoice_data_provider.dart';
import 'package:courier_app/features/shipment_invoice/model/shipment_invoice_model.dart';

class ShipmentInvoiceRepository {
  final ShipmentInvoiceDataProvider shipmentInvoiceDataProvider;
  final BranchesRepository branchesRepository;

  ShipmentInvoiceRepository({
    required this.shipmentInvoiceDataProvider,
    required this.branchesRepository,
  });

  Future<ShipmentInvoiceModel> fetchShipmentInvoice(String awb) async {
    try {
      final response =
          await shipmentInvoiceDataProvider.fetchShipmentInvoice(awb);
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      var invoice = ShipmentInvoiceModel.fromMap(data['data']);

      try {
        final branches = await branchesRepository.fetchBranches();
        invoice = invoice.withResolvedBranchNames(branches);
      } catch (_) {
        // Keep invoice if branch lookup fails.
      }

      return invoice;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
