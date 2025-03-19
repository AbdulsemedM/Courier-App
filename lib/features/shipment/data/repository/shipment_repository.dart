import 'dart:convert';

import 'package:courier_app/features/shipment/data/data_provider/shipment_data_provider.dart';
import 'package:courier_app/features/track_order/model/shipmet_status_model.dart';

class ShipmentRepository {
  final ShipmentDataProvider shipmentDataProvider;

  ShipmentRepository({required this.shipmentDataProvider});

  Future<List<ShipmentModel>> fetchShipments() async {
    try {
      final response = await shipmentDataProvider.fetchShipments();
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final shipments = (data['data'] as List)
            .map((shipmnet) => ShipmentModel.fromJson(shipmnet))
            .toList();
        return shipments;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
