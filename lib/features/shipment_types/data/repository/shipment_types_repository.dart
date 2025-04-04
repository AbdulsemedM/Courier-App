import 'dart:convert';

import 'package:courier_app/features/shipment_types/data/data_provider/shipment_types_data_provider.dart';
import 'package:courier_app/features/shipment_types/models/shipment_types_models.dart';

class ShipmentTypesRepository {
  final ShipmentTypesDataProvider _shipmentTypesDataProvider =
      ShipmentTypesDataProvider();

  ShipmentTypesRepository(ShipmentTypesDataProvider shipmentTypesDataProvider);

  Future<List<ShipmentTypesModels>> fetchShipmentTypes() async {
    try {
      final response = await _shipmentTypesDataProvider.fetchShipmentTypes();
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final shipmentTypes = (data['data'] as List)
            .map((shipmentType) => ShipmentTypesModels.fromMap(shipmentType))
            .toList();
        return shipmentTypes;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }

  Future<String> addShipmentType(Map<String, dynamic> shipmentType) async {
    try {
      final response =
          await _shipmentTypesDataProvider.addShipmentType(shipmentType);
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      return data['message'];
    } catch (e) {
      throw e.toString();
    }
  }
}
