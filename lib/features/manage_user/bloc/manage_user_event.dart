part of 'manage_user_bloc.dart';

@immutable
sealed class ManageUserEvent {}

class FetchUsersEvent extends ManageUserEvent {}

class UpdateUserEvent extends ManageUserEvent {
  final Map<String, dynamic> user;
  final String userId;

  UpdateUserEvent({required this.user, required this.userId});
}
