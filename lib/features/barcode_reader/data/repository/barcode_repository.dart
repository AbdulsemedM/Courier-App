import 'dart:convert';

import '../data_provider/barcode_data_provider.dart';

class BarcodeRepository {
  final BarcodeDataProvider barcodeDataProvider;
  BarcodeRepository(this.barcodeDataProvider);
  Future<String> changeStatus(List<String> shipmentIds, String status) async {
    try {
      final response =
          await barcodeDataProvider.changeStatus(shipmentIds, status);
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      return data['message'];
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
