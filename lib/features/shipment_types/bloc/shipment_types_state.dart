part of 'shipment_types_bloc.dart';

@immutable
sealed class ShipmentTypesState {}

final class ShipmentTypesInitial extends ShipmentTypesState {}

final class ShipmentTypesLoading extends ShipmentTypesState {}

final class ShipmentTypesLoaded extends ShipmentTypesState {
  final List<ShipmentTypesModels> shipmentTypes;
  ShipmentTypesLoaded({required this.shipmentTypes});
}

final class ShipmentTypesError extends ShipmentTypesState {
  final String message;
  ShipmentTypesError({required this.message});
}

final class AddShipmentTypesLoading extends ShipmentTypesState {}

final class AddShipmentTypesLoaded extends ShipmentTypesState {
  final String message;
  AddShipmentTypesLoaded({required this.message});
}

final class AddShipmentTypesError extends ShipmentTypesState {
  final String message;
  AddShipmentTypesError({required this.message});
}
