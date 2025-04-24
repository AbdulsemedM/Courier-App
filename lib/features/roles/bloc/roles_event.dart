part of 'roles_bloc.dart';

@immutable
sealed class RolesEvent {}

class FetchRolesEvent extends RolesEvent {}

class AddRolesEvent extends RolesEvent {
  final Map<String, dynamic> roles;
  AddRolesEvent({required this.roles});
}
