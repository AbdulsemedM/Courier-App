import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class ManageAgentDataProvider {
  Future<String> fetchAgents() async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest("/api/v1/agents");
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> addAgent(Map<String, dynamic> servicesMode) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response =
          await apiProvider.postRequest("/api/v1/agent", servicesMode);
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> updateAgent(
      Map<String, dynamic> servicesMode, String agentId) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response =
          await apiProvider.putRequest("/api/v1/agent/$agentId", servicesMode);
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}
