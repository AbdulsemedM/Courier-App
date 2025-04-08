import 'dart:convert';

import 'package:courier_app/features/transport_modes/data/data_provider/transport_modes_data_provider.dart';
import 'package:courier_app/features/transport_modes/model/transport_modes_model.dart';

class TransportModesRepository {
  final TransportModesDataProvider _transportModesDataProvider =
      TransportModesDataProvider();

  TransportModesRepository(
      TransportModesDataProvider transportModesDataProvider);

  Future<List<TransportModesModel>> fetchTransportModes() async {
    try {
      final response = await _transportModesDataProvider.fetchTransportModes();
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final transportModes = (data['data'] as List)
            .map((transportMode) => TransportModesModel.fromMap(transportMode))
            .toList();
        return transportModes;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }

  Future<String> addTransportMode(Map<String, dynamic> transportMode) async {
    try {
      final response =
          await _transportModesDataProvider.addTransportMode(transportMode);
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
