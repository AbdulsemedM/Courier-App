part of 'services_mode_bloc.dart';

@immutable
sealed class ServicesModeEvent {}

final class FetchServicesMode extends ServicesModeEvent {}

final class AddServicesMode extends ServicesModeEvent {
  final Map<String, dynamic> servicesMode;
  AddServicesMode({required this.servicesMode});
}
