part of 'roles_bloc.dart';

@immutable
sealed class RolesState {}

final class RolesInitial extends RolesState {}

final class FetchRolesLoading extends RolesState {}

final class FetchRolesSuccess extends RolesState {
  final List<RolesModel> roles;
  FetchRolesSuccess({required this.roles});
}

final class FetchRolesError extends RolesState {
  final String message;
  FetchRolesError({required this.message});
}

final class AddRolesLoading extends RolesState {}

final class AddRolesSuccess extends RolesState {
  final String message;
  AddRolesSuccess({required this.message});
}

final class AddRolesError extends RolesState {
  final String message;
  AddRolesError({required this.message});
}

final class FetchAllPermissionsLoading extends RolesState {}

final class FetchAllPermissionsSuccess extends RolesState {
  final List<PermissionModel> permissions;
  FetchAllPermissionsSuccess({required this.permissions});
}

final class FetchAllPermissionsError extends RolesState {
  final String message;
  FetchAllPermissionsError({required this.message});
}

final class FetchRolePermissionsLoading extends RolesState {}

final class FetchRolePermissionsSuccess extends RolesState {
  final RolePermissionsModel rolePermissions;
  FetchRolePermissionsSuccess({required this.rolePermissions});
}

final class FetchRolePermissionsError extends RolesState {
  final String message;
  FetchRolePermissionsError({required this.message});
}

final class UpdateRolePermissionsLoading extends RolesState {}

final class UpdateRolePermissionsSuccess extends RolesState {
  final String message;
  UpdateRolePermissionsSuccess({required this.message});
}

final class UpdateRolePermissionsError extends RolesState {
  final String message;
  UpdateRolePermissionsError({required this.message});
}
