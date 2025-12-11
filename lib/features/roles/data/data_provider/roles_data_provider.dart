import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class RolesDataProvider {
  Future<String> fetchRoles() async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest("/api/v1/roles");
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
  
  Future<String> addRoles(Map<String, dynamic> roles) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.postRequest("/api/v1/roles", roles);
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> fetchAllPermissions() async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest("/api/v1/permissions");
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> fetchRolePermissions(int roleId) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest("/api/v1/permission/role/$roleId");
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> updateRolePermissions({
    required int roleId,
    required List<int> permissionIds,
    required int addedBy,
  }) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final body = {
        'roleId': roleId,
        'permissionIds': permissionIds,
        'addedBy': addedBy,
      };
      final response = await apiProvider.postRequest("/api/v1/role/permissions", body);
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}
