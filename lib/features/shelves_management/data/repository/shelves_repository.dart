import 'dart:convert';

import 'package:courier_app/core/utils/api_json_decoder.dart';
import 'package:courier_app/features/shelves_management/data/data_provider/shelves_data_provider.dart';
import 'package:courier_app/features/shelves_management/model/shelves_mdoel.dart';

class ShelvesRepository {
  final ShelvesDataProvider shelvesDataProvider;

  ShelvesRepository({required this.shelvesDataProvider});

  Future<List<ShelvesModel>> fetchShelves() async {
    return _parseShelvesResponse(await shelvesDataProvider.fetchShelves());
  }

  Future<List<ShelvesModel>> fetchShelvesByBranch(int branchId) async {
    return _parseShelvesResponse(
      await shelvesDataProvider.fetchShelvesByBranch(branchId),
    );
  }

  Future<String> transferShelf({
    required String awbNumber,
    required int toShelfId,
    required String reason,
  }) async {
    try {
      final response = await shelvesDataProvider.transferShelf(
        awbNumber: awbNumber,
        toShelfId: toShelfId,
        reason: reason,
      );
      final data = decodeApiMap(response);
      if (data['status'] != 200) {
        throw data['message']?.toString() ?? 'Failed to transfer shelf';
      }
      return data['message']?.toString() ?? 'Shelf transferred successfully';
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<ShelvesModel>> _parseShelvesResponse(String response) async {
    try {
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        return (data['data'] as List)
            .map((shelf) => ShelvesModel.fromMap(shelf))
            .toList();
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }
}
