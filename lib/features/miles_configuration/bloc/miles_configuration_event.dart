part of 'miles_configuration_bloc.dart';

@immutable
sealed class MilesConfigurationEvent {}

class FetchMilesConfiguration extends MilesConfigurationEvent {}

class AddNewMilesConfiguration extends MilesConfigurationEvent {
  final int originBranchId;
  final int destinationBranchId;
  final String unit;
  final int milesPerUnit;

  AddNewMilesConfiguration(
      {required this.originBranchId,
      required this.destinationBranchId,
      required this.unit,
      required this.milesPerUnit});
}
