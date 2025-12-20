part of 'roles_bloc.dart';

@immutable
sealed class RolesEvent {}

class FetchRolesEvent extends RolesEvent {}

class AddRolesEvent extends RolesEvent {
  final Map<String, dynamic> roles;
  AddRolesEvent({required this.roles});
}

class FetchAllPermissionsEvent extends RolesEvent {}

class FetchRolePermissionsEvent extends RolesEvent {
  final int roleId;
  FetchRolePermissionsEvent({required this.roleId});
}

class UpdateRolePermissionsEvent extends RolesEvent {
  final int roleId;
  final List<int> permissionIds;
  final int addedBy;
  UpdateRolePermissionsEvent({
    required this.roleId,
    required this.permissionIds,
    required this.addedBy,
  });
}
