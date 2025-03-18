import 'dart:convert';

import 'package:courier_app/features/track_shipment/data/data_provider/track_shipment_data_provider.dart';
import 'package:courier_app/features/track_shipment/model/track_shipment_model.dart';

class TrackShipmentRepository {
  final TrackShipmentDataProvider trackShipmentDataProvider;
  TrackShipmentRepository(this.trackShipmentDataProvider);
  Future<List<TrackShipmentModel>> getTrackShipment(String awb) async {
    try {
      final response = await trackShipmentDataProvider.getTrackShipment(awb);
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final orders = (data['data'] as List)
            .map((order) => TrackShipmentModel.fromMap(order))
            .toList();
        return orders;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
