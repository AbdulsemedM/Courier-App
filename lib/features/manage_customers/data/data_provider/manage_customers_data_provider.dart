import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class ManageCustomersDataProvider {
  Future<String> fetchCustomers() async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest("/api/v1/customers");
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> addCustomer(Map<String, dynamic> servicesMode) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response =
          await apiProvider.postRequest("/api/v1/customer", servicesMode);
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> updateCustomer(
      Map<String, dynamic> servicesMode, String customerId) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response =
          await apiProvider.putRequest("/api/v1/customer/$customerId", servicesMode);
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}
