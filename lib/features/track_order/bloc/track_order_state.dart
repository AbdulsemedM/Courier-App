part of 'track_order_bloc.dart';

@immutable
sealed class TrackOrderState {}

final class TrackOrderInitial extends TrackOrderState {}

final class TrackOrderLoading extends TrackOrderState {}

final class TrackOrderSuccess extends TrackOrderState {
  final List<ShipmentModel> shipments;

  TrackOrderSuccess({required this.shipments});
}

final class TrackOrdeFailure extends TrackOrderState {
  final String errorMessage;

  TrackOrdeFailure({required this.errorMessage});
}
