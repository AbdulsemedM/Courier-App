import 'dart:convert';

import 'package:courier_app/features/manage_agent/data/data_provider/manage_agent_data_provider.dart';
import 'package:courier_app/features/manage_agent/model/agent_model.dart';

class ManageAgentRepository {
  final ManageAgentDataProvider _manageAgentDataProvider =
      ManageAgentDataProvider();

  ManageAgentRepository(ManageAgentDataProvider manageAgentDataProvider);

  Future<List<AgentModel>> fetchAgents() async {
    try {
      final response = await _manageAgentDataProvider.fetchAgents();
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final agents = (data['data'] as List)
            .map((agent) => AgentModel.fromMap(agent))
            .toList();
        return agents;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }

  Future<String> addAgent(Map<String, dynamic> agent) async {
    try {
      final response = await _manageAgentDataProvider.addAgent(agent);
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      return data['message'];
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> updateAgent(Map<String, dynamic> agent, String agentId) async {
    try {
      final response =
          await _manageAgentDataProvider.updateAgent(agent, agentId);
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
