part of 'manage_user_bloc.dart';

@immutable
sealed class ManageUserState {}

final class ManageUserInitial extends ManageUserState {}

final class FetchUsersLoading extends ManageUserState {}

final class FetchUsersSuccess extends ManageUserState {
  final List<UserModel> users;

  FetchUsersSuccess({required this.users});
}

final class FetchUsersError extends ManageUserState {
  final String message;

  FetchUsersError({required this.message});
}

final class UpdateUserLoading extends ManageUserState {}

final class UpdateUserSuccess extends ManageUserState {
  final String message;

  UpdateUserSuccess({required this.message});
}

final class UpdateUserFailure extends ManageUserState {
  final String message;

  UpdateUserFailure({required this.message});
}
