part of 'manage_agent_bloc.dart';

@immutable
sealed class ManageAgentEvent {}

class FetchAgentsEvent extends ManageAgentEvent {}

class AddAgentEvent extends ManageAgentEvent {
  final Map<String, dynamic> agent;
  AddAgentEvent({required this.agent});
}

class UpdateAgentEvent extends ManageAgentEvent {
  final Map<String, dynamic> agent;
  final String agentId;
  UpdateAgentEvent({required this.agent, required this.agentId});
}
