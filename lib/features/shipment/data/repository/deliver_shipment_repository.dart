import 'dart:convert';
import 'dart:io';
import 'package:courier_app/core/utils/shipment_status_helper.dart';
import 'package:courier_app/features/shipment/data/data_provider/deliver_shipment_data_provider.dart';
import 'package:courier_app/features/track_shipment/data/data_provider/track_shipment_data_provider.dart';
import 'package:courier_app/features/track_shipment/data/repository/track_shipment_repository.dart';
import 'package:flutter/foundation.dart';

class DeliverShipmentRepository {
  final DeliverShipmentDataProvider deliverShipmentDataProvider;

  DeliverShipmentRepository({required this.deliverShipmentDataProvider});

  static const _deliverTimeouts = [
    Duration(seconds: 30),
    Duration(seconds: 60),
    Duration(seconds: 120),
  ];

  static bool isTimeoutError(Object error) {
    final text = error.toString().toLowerCase();
    return text.contains('timeout') || text.contains('timed out');
  }

  /// After a client timeout, the server may still have completed delivery.
  Future<String?> verifyDeliveredAfterTimeout(String awb) async {
    try {
      final trackRepo =
          TrackShipmentRepository(TrackShipmentDataProvider());
      final shipments = await trackRepo.getTrackShipment(awb);
      for (final shipment in shipments) {
        if (ShipmentStatusHelper.isAlreadyDelivered(
          shipmentStatusCode: shipment.statusCode,
          shipmentStatusLabel: shipment.statusDescription,
        )) {
          return 'Shipment delivered successfully';
        }
      }
    } catch (_) {}
    return null;
  }

  String _parseSuccessMessage(String response) {
    final data = jsonDecode(response);
    if (data['status'] != 200) {
      throw data['message'] ?? 'Failed to deliver shipment';
    }
    return data['message'] ?? 'Delivery successful';
  }

  Future<String> deliverShipment({
    required String awb,
    required bool isSelf,
    File? customerIdFile,
    String? deliveredToName,
    String? deliveredToPhone,
  }) async {
    Object? lastError;

    for (var i = 0; i < _deliverTimeouts.length; i++) {
      final timeout = _deliverTimeouts[i];
      debugPrint(
        'Deliver $awb attempt ${i + 1}/${_deliverTimeouts.length}, '
        'timeout ${timeout.inSeconds}s',
      );

      try {
        final response = await deliverShipmentDataProvider.deliverShipment(
          awb: awb,
          isSelf: isSelf,
          customerIdFile: customerIdFile,
          deliveredToName: deliveredToName,
          deliveredToPhone: deliveredToPhone,
          timeout: timeout,
        );
        return _parseSuccessMessage(response);
      } catch (e) {
        lastError = e;

        if (!isTimeoutError(e)) {
          throw e.toString();
        }

        final recovered = await verifyDeliveredAfterTimeout(awb);
        if (recovered != null) {
          return recovered;
        }

        if (i == _deliverTimeouts.length - 1) {
          throw e.toString();
        }
      }
    }

    throw lastError?.toString() ?? 'Request timed out';
  }
}
