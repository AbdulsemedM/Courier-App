part of 'track_order_bloc.dart';

@immutable
sealed class TrackOrderEvent {}

class TrackOrder extends TrackOrderEvent {}

class FetchStatuses extends TrackOrderEvent {}

class ChangeStatus extends TrackOrderEvent {
  final List<String> shipmentIds;
  final String status;

  ChangeStatus({required this.shipmentIds, required this.status});
}

class ClearShipments extends TrackOrderEvent {}
