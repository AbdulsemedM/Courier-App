
import 'dart:convert';

import 'package:courier_app/features/roles/data/data_provider/roles_data_provider.dart';
import 'package:courier_app/features/roles/model/roles_model.dart';
import 'package:courier_app/features/roles/model/permission_model.dart';

class RolesRepository {
  final RolesDataProvider _rolesDataProvider = RolesDataProvider();

  RolesRepository(RolesDataProvider rolesDataProvider);

  Future<List<RolesModel>> fetchRoles() async {
    try {
      final response = await _rolesDataProvider.fetchRoles();
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final roles = (data['data'] as List)
            .map((roles) => RolesModel.fromMap(roles))
            .toList();
        return roles;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print(e.toString());
      throw e.toString();
    } 
  }
  
  Future<String> addRoles(Map<String, dynamic> roles) async {
    try {
      final response = await _rolesDataProvider.addRoles(roles);
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      return data['message'];
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<PermissionModel>> fetchAllPermissions() async {
    try {
      final response = await _rolesDataProvider.fetchAllPermissions();
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final permissions = (data['data'] as List)
            .map((p) => PermissionModel.fromMap(p as Map<String, dynamic>))
            .toList();
        return permissions;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }

  Future<RolePermissionsModel> fetchRolePermissions(int roleId) async {
    try {
      final response = await _rolesDataProvider.fetchRolePermissions(roleId);
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      return RolePermissionsModel.fromMap(data['data'] as Map<String, dynamic>);
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }

  Future<String> updateRolePermissions({
    required int roleId,
    required List<int> permissionIds,
    required int addedBy,
  }) async {
    try {
      final response = await _rolesDataProvider.updateRolePermissions(
        roleId: roleId,
        permissionIds: permissionIds,
        addedBy: addedBy,
      );
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'] ?? 'Failed to update permissions';
      }
      return data['message'] ?? 'Permissions updated successfully';
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }

}