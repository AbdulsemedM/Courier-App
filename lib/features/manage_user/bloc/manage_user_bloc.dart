import 'package:courier_app/features/manage_user/data/repository/manage_user_repository.dart';
import 'package:courier_app/features/manage_user/model/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'manage_user_event.dart';
part 'manage_user_state.dart';

class ManageUserBloc extends Bloc<ManageUserEvent, ManageUserState> {
  final ManageUsersRepository manageUsersRepository;
  ManageUserBloc(this.manageUsersRepository) : super(ManageUserInitial()) {
    on<FetchUsersEvent>(_fetchUsers);
    // on<AddCustomerEvent>(_addCustomer);
    on<UpdateUserEvent>(_updateUser);
  }

  void _fetchUsers(FetchUsersEvent event, Emitter<ManageUserState> emit) async {
    emit(FetchUsersLoading());
    try {
      final users = await manageUsersRepository.fetchUsers();
      emit(FetchUsersSuccess(users: users));
    } catch (e) {
      emit(FetchUsersError(message: e.toString()));
    }
  }

  void _updateUser(UpdateUserEvent event, Emitter<ManageUserState> emit) async {
    emit(UpdateUserLoading());
    try {
      final message =
          await manageUsersRepository.updateUser(event.user, event.userId);
      emit(UpdateUserSuccess(message: message));
    } catch (e) {
      emit(UpdateUserFailure(message: e.toString()));
    }
  }
}
