import 'package:courier_app/features/roles/data/repository/roles_repository.dart';
import 'package:courier_app/features/roles/model/roles_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
part 'roles_event.dart';
part 'roles_state.dart';

class RolesBloc extends Bloc<RolesEvent, RolesState> {
  final RolesRepository rolesRepository;
  RolesBloc(this.rolesRepository) : super(RolesInitial()) {
    on<FetchRolesEvent>(_fetchRoles);
    on<AddRolesEvent>(_addRoles);
  }

  void _fetchRoles(FetchRolesEvent event, Emitter<RolesState> emit) async {
    emit(FetchRolesLoading());
    try {
      final roles = await rolesRepository.fetchRoles();
      emit(FetchRolesSuccess(roles: roles));
    } catch (e) {
      emit(FetchRolesError(message: e.toString()));
    }
  }

  void _addRoles(AddRolesEvent event, Emitter<RolesState> emit) async {
    emit(AddRolesLoading());
    try {
      final message = await rolesRepository.addRoles(event.roles);
      emit(AddRolesSuccess(message: message));
    } catch (e) {
      emit(AddRolesError(message: e.toString()));
    }
  }
}