part of 'miles_configuration_bloc.dart';

@immutable
sealed class MilesConfigurationEvent {}

class FetchMilesConfiguration extends MilesConfigurationEvent {}
