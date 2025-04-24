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
