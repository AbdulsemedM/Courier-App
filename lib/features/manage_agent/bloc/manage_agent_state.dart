part of 'manage_agent_bloc.dart';

@immutable
sealed class ManageAgentState {}

final class ManageAgentInitial extends ManageAgentState {}

final class FetchAgentsLoading extends ManageAgentState {}

final class FetchAgentsSuccess extends ManageAgentState {
  final List<AgentModel> agents;
  FetchAgentsSuccess({required this.agents});
}

final class FetchAgentsError extends ManageAgentState {
  final String error;
  FetchAgentsError({required this.error});
}

final class AddAgentLoading extends ManageAgentState {}

final class AddAgentSuccess extends ManageAgentState {
  final String message;
  AddAgentSuccess({required this.message});
}

final class AddAgentError extends ManageAgentState {
  final String error;
  AddAgentError({required this.error});
}

final class UpdateAgentLoading extends ManageAgentState {}

final class UpdateAgentSuccess extends ManageAgentState {
  final String message;
  UpdateAgentSuccess({required this.message});
}

final class UpdateAgentError extends ManageAgentState {
  final String error;
  UpdateAgentError({required this.error});
}
