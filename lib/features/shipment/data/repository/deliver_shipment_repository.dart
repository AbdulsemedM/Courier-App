import 'dart:convert';
import 'dart:io';
import 'package:courier_app/features/shipment/data/data_provider/deliver_shipment_data_provider.dart';

class DeliverShipmentRepository {
  final DeliverShipmentDataProvider deliverShipmentDataProvider;

  DeliverShipmentRepository({required this.deliverShipmentDataProvider});

  Future<String> deliverShipment({
    required String awb,
    required bool isSelf,
    File? customerIdFile,
    String? deliveredToName,
    String? deliveredToPhone,
  }) async {
    try {
      final response = await deliverShipmentDataProvider.deliverShipment(
        awb: awb,
        isSelf: isSelf,
        customerIdFile: customerIdFile,
        deliveredToName: deliveredToName,
        deliveredToPhone: deliveredToPhone,
      );
      
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'] ?? 'Failed to deliver shipment';
      }
      return data['message'] ?? 'Delivery successful';
    } catch (e) {
      throw e.toString();
    }
  }
}

