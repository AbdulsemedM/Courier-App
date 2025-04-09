import 'package:courier_app/features/manage_agent/data/repository/manage_agent_repository.dart';
import 'package:courier_app/features/manage_agent/model/agent_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
part 'manage_agent_event.dart';
part 'manage_agent_state.dart';

class ManageAgentBloc extends Bloc<ManageAgentEvent, ManageAgentState> {
  final ManageAgentRepository manageAgentRepository;
  ManageAgentBloc(this.manageAgentRepository) : super(ManageAgentInitial()) {
    on<FetchAgentsEvent>(_fetchAgents);
    on<AddAgentEvent>(_addAgent);
    on<UpdateAgentEvent>(_updateAgent);
  }

  void _fetchAgents(
      FetchAgentsEvent event, Emitter<ManageAgentState> emit) async {
    emit(FetchAgentsLoading());
    try {
      final agents = await manageAgentRepository.fetchAgents();
      emit(FetchAgentsSuccess(agents: agents));
    } catch (e) {
      emit(FetchAgentsError(error: e.toString()));
    }
  }

  void _addAgent(AddAgentEvent event, Emitter<ManageAgentState> emit) async {
    emit(AddAgentLoading());
    try {
      final message = await manageAgentRepository.addAgent(event.agent);
      emit(AddAgentSuccess(message: message));
    } catch (e) {
      emit(AddAgentError(error: e.toString()));
    }
  }

  void _updateAgent(
      UpdateAgentEvent event, Emitter<ManageAgentState> emit) async {
    emit(UpdateAgentLoading());
    try {
      final message =
          await manageAgentRepository.updateAgent(event.agent, event.agentId);
      emit(UpdateAgentSuccess(message: message));
    } catch (e) {
      emit(UpdateAgentError(error: e.toString()));
    }
  }
}
