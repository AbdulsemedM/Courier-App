import 'dart:convert';

import 'package:courier_app/features/manage_user/data/data_provider/manage_user_data_provider.dart';
import 'package:courier_app/features/manage_user/model/user_model.dart';

class ManageUsersRepository {
  final ManageUsersDataProvider _manageUsersDataProvider =
      ManageUsersDataProvider();

  ManageUsersRepository(ManageUsersDataProvider manageUsersDataProvider);

  Future<List<UserModel>> fetchUsers() async {
    try {
      final response = await _manageUsersDataProvider.fetchUsers();
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final users = (data['data'] as List)
            .map((user) => UserModel.fromMap(user))
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

  // Future<String> addUser(Map<String, dynamic> user) async {
  //   try {
  //     final response = await _manageUsersDataProvider.addUser(user);
  //     final data = jsonDecode(response);
  //     if (data['status'] != 200) {
  //       throw data['message'];
  //     }
  //     return data['message'];
  //   } catch (e) {
  //     throw e.toString();
  //   }
  // }

  Future<String> updateUser(Map<String, dynamic> user, String userId) async {
    try {
      final response = await _manageUsersDataProvider.updateUser(user, userId);
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
