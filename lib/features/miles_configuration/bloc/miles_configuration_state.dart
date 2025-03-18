part of 'miles_configuration_bloc.dart';

@immutable
sealed class MilesConfigurationState {}

final class MilesConfigurationInitial extends MilesConfigurationState {}

final class MilesConfigurationLoading extends MilesConfigurationState {}

final class MilesConfigurationSuccess extends MilesConfigurationState {
  final List<MilesConfigurationModel> milesConfigurations;
  MilesConfigurationSuccess(this.milesConfigurations);
}

final class MilesConfigurationFailure extends MilesConfigurationState {
  final String message;
  MilesConfigurationFailure(this.message);
}
