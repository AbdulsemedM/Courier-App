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

final class FetchStatusLoading extends TrackOrderState {}

final class FetchStatusSuccess extends TrackOrderState {
  final List<StatusModel> statuses;

  FetchStatusSuccess({required this.statuses});
}

final class FetchStatusFailure extends TrackOrderState {
  final String errorMessage;

  FetchStatusFailure({required this.errorMessage});
}
