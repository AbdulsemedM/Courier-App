// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:courier_app/features/track_order/data/data_provider/track_order_data_provider.dart';
import 'package:courier_app/features/track_order/model/shipmet_status_model.dart';

class TrackOrderRepository {
  final TrackOrderDataProvider trackOrderDataProvider;
  // final UserManager userManager;
  TrackOrderRepository(this.trackOrderDataProvider);

  Future<List<ShipmentModel>> fetchOrders() async {
    try {
      // print("here we gooooo");
      final fetchedOrders = await trackOrderDataProvider.fetchOrders();

      final data = jsonDecode(fetchedOrders);
      if (data['status'] != 200) {
        // print('Error Message: ${data['message']}');

        // Throw only the message part
        throw data['message'];
      }

      if (data['data'] is List) {
        final orders = (data['data'] as List)
            .map((order) => ShipmentModel.fromJson(order))
            .toList();
        return orders;
      } else {
        throw "Invalid response format: Expected a list";
      }

      // return data['data'];
    } catch (e) {
      print(e.toString());
      rethrow; // This will throw only the `message` part if thrown from above
    }
  }
}
