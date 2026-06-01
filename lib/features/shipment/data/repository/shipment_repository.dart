import 'package:courier_app/core/utils/api_json_decoder.dart';
import 'package:courier_app/features/shipment/data/data_provider/shipment_data_provider.dart';
import 'package:courier_app/features/track_order/model/shipmet_status_model.dart';

class ShipmentRepository {
  final ShipmentDataProvider shipmentDataProvider;

  ShipmentRepository({required this.shipmentDataProvider});

  Future<List<ShipmentModel>> fetchShipments({String? status}) async {
    try {
      final response =
          await shipmentDataProvider.fetchShipments(status: status);
      return _parseShipmentsResponse(response);
    } catch (e) {
      throw e.toString();
    }
  }

  List<ShipmentModel> _parseShipmentsResponse(String response) {
    Map<String, dynamic> data;
    try {
      data = decodeApiMap(response);
    } on FormatException {
      final recovered = parseDataArrayLenient(response);
      if (recovered.isEmpty) rethrow;
      return _mapShipments(recovered);
    }

    if (data['status'] != 200) {
      throw data['message']?.toString() ?? 'Failed to load shipments';
    }

    final payload = data['data'];
    if (payload is List) {
      return _mapShipments(
        payload
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList(),
      );
    }

    throw 'Invalid response format: Expected a list';
  }

  List<ShipmentModel> _mapShipments(List<Map<String, dynamic>> items) {
    final shipments = <ShipmentModel>[];
    for (final item in items) {
      try {
        shipments.add(ShipmentModel.fromJson(item));
      } catch (_) {
        // Skip individual records that fail model mapping.
      }
    }

    if (shipments.isEmpty && items.isNotEmpty) {
      throw 'Failed to parse shipment data';
    }

    return shipments;
  }
}
