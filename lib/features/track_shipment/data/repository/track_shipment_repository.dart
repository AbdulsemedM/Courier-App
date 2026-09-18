import 'dart:convert';

import 'package:courier_app/features/shipment_invoice/data/data_provider/shipment_invoice_data_provider.dart';
import 'package:courier_app/features/shipment_invoice/model/shipment_invoice_model.dart';
import 'package:courier_app/features/track_shipment/data/data_provider/track_shipment_data_provider.dart';
import 'package:courier_app/features/track_shipment/model/track_shipment_model.dart';

class TrackShipmentRepository {
  final TrackShipmentDataProvider trackShipmentDataProvider;
  final ShipmentInvoiceDataProvider shipmentInvoiceDataProvider;

  TrackShipmentRepository(
    this.trackShipmentDataProvider, {
    ShipmentInvoiceDataProvider? shipmentInvoiceDataProvider,
  }) : shipmentInvoiceDataProvider =
            shipmentInvoiceDataProvider ?? ShipmentInvoiceDataProvider();

  Future<List<TrackShipmentModel>> getTrackShipment(String awb) async {
    try {
      final response = await trackShipmentDataProvider.getTrackShipment(awb);
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is! List) {
        throw "Invalid response format: Expected a list";
      }

      final searchedAwb = awb.trim();
      var orders = (data['data'] as List)
          .whereType<Map>()
          .map(
            (order) => TrackShipmentModel.fromMap(
              Map<String, dynamic>.from(order),
            ),
          )
          .map(
            (order) => order.awb.trim().isEmpty && searchedAwb.isNotEmpty
                ? order.copyWith(awb: searchedAwb)
                : order,
          )
          .toList();

      // Tracking history often omits shipment/payment fields; enrich from invoice.
      if (orders.isNotEmpty) {
        final invoice = await _tryFetchInvoice(searchedAwb);
        if (invoice != null) {
          orders = orders
              .asMap()
              .entries
              .map(
                (entry) => _mergeInvoiceDetails(
                  entry.value,
                  invoice,
                  applyCurrentStatus: entry.key == 0,
                ),
              )
              .toList();
        }
      }

      return orders;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<ShipmentInvoiceModel?> _tryFetchInvoice(String awb) async {
    try {
      final response =
          await shipmentInvoiceDataProvider.fetchShipmentInvoice(awb);
      final data = jsonDecode(response);
      if (data['status'] != 200 || data['data'] is! Map) {
        return null;
      }
      return ShipmentInvoiceModel.fromMap(
        Map<String, dynamic>.from(data['data'] as Map),
      );
    } catch (_) {
      return null;
    }
  }

  TrackShipmentModel _mergeInvoiceDetails(
    TrackShipmentModel order,
    ShipmentInvoiceModel invoice, {
    bool applyCurrentStatus = false,
  }) {
    return order.copyWith(
      awb: order.awb.trim().isEmpty ? invoice.awb : order.awb,
      senderName:
          order.senderName.trim().isEmpty ? invoice.senderName : order.senderName,
      senderMobile: order.senderMobile.trim().isEmpty
          ? invoice.senderMobile
          : order.senderMobile,
      receiverName: order.receiverName.trim().isEmpty
          ? invoice.receiverName
          : order.receiverName,
      receiverMobile: order.receiverMobile.trim().isEmpty
          ? invoice.receiverMobile
          : order.receiverMobile,
      name: order.name.trim().isEmpty
          ? (invoice.receiverBranchName.isNotEmpty
              ? invoice.receiverBranchName
              : order.name)
          : order.name,
      senderBranchName: order.senderBranchName ??
          (invoice.senderbranchName.isNotEmpty
              ? invoice.senderbranchName
              : null),
      receiverBranchName: order.receiverBranchName ??
          (invoice.receiverBranchName.isNotEmpty
              ? invoice.receiverBranchName
              : null),
      senderBranchId: order.senderBranchId ?? invoice.senderBranchId,
      receiverBranchId: order.receiverBranchId ?? invoice.receiverBranchId,
      netFee: order.netFee.trim().isEmpty
          ? invoice.netFee.toString()
          : order.netFee,
      shipmentDescription: order.shipmentDescription.trim().isEmpty
          ? invoice.shipmentDescription
          : order.shipmentDescription,
      method: order.method.trim().isEmpty
          ? (invoice.paymentModeName.isNotEmpty &&
                  invoice.paymentModeName != 'N/A'
              ? invoice.paymentModeName
              : (invoice.paymentMethodName.isNotEmpty
                  ? invoice.paymentMethodName
                  : order.method))
          : order.method,
      totalAmount: order.totalAmount ?? invoice.totalAmount,
      qty: order.qty ?? invoice.qty,
      unit: order.unit ?? invoice.unit,
      numBoxes: order.numBoxes ?? invoice.numPcs,
      paymentStatus: order.paymentStatus ?? invoice.paymentStatus,
      statusCode: applyCurrentStatus &&
              invoice.shipmentStatusCode != null &&
              invoice.shipmentStatusCode!.trim().isNotEmpty
          ? invoice.shipmentStatusCode
          : order.statusCode,
      statusDescription: applyCurrentStatus &&
              invoice.shipmentStatusDescription != null &&
              invoice.shipmentStatusDescription!.trim().isNotEmpty
          ? invoice.shipmentStatusDescription
          : order.statusDescription,
    );
  }
}
