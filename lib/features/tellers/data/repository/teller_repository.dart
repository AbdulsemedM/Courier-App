import 'dart:convert';

import 'package:courier_app/features/tellers/data/data_provider/teller_data_provider.dart';
import 'package:courier_app/features/tellers/model/teller_model.dart';

class TellerRepository {
  final TellerDataProvider _tellerDataProvider = TellerDataProvider();

  TellerRepository(TellerDataProvider tellerDataProvider);

  Future<List<TellerModel>> fetchTellers() async {
    try {
      final response = await _tellerDataProvider.fetchTellers();
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final users = (data['data'] as List)
            .map((user) => TellerModel.fromMap(user))
            .toList();
        return users;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }

  Future<String> addTeller(Map<String, dynamic> user) async {
    try {
      final response = await _tellerDataProvider.addTeller(user);
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      return data['message'];
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> updateTeller(Map<String, dynamic> user, String userId) async {
    try {
      final response = await _tellerDataProvider.updateTeller(user, userId);
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
