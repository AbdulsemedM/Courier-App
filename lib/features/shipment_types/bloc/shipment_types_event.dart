part of 'shipment_types_bloc.dart';

@immutable
sealed class ShipmentTypesEvent {}

final class FetchShipmentTypes extends ShipmentTypesEvent {}

final class AddShipmentType extends ShipmentTypesEvent {
  final Map<String, dynamic> shipmentType;
  AddShipmentType({required this.shipmentType});
}
