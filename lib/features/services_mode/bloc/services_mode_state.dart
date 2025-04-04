part of 'services_mode_bloc.dart';

@immutable
sealed class ServicesModeState {}

final class ServicesModeInitial extends ServicesModeState {}

final class ServicesModeLoading extends ServicesModeState {}

final class ServicesModeLoaded extends ServicesModeState {
  final List<ServicesModeModels> servicesMode;
  ServicesModeLoaded({required this.servicesMode});
}

final class ServicesModeError extends ServicesModeState {
  final String message;
  ServicesModeError({required this.message});
}

final class AddServicesModeLoading extends ServicesModeState {}

final class AddServicesModeLoaded extends ServicesModeState {
  final String message;
  AddServicesModeLoaded({required this.message});
}

final class AddServicesModeError extends ServicesModeState {
  final String message;
  AddServicesModeError({required this.message});
}
