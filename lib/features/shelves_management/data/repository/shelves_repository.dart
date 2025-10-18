import 'dart:convert';

import 'package:courier_app/features/shelves_management/data/data_provider/shelves_data_provider.dart';
import 'package:courier_app/features/shelves_management/model/shelves_mdoel.dart';

class ShelvesRepository {
  final ShelvesDataProvider shelvesDataProvider;

  ShelvesRepository({required this.shelvesDataProvider});

  Future<List<ShelvesModel>> fetchShelves() async {
    try {
      final response = await shelvesDataProvider.fetchShelves();
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final shelves = (data['data'] as List)
            .map((shelves) => ShelvesModel.fromMap(shelves))
            .toList();
        return shelves;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }
}
