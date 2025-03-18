part of 'track_shipment_bloc.dart';

@immutable
sealed class TrackShipmentState {}

final class TrackShipmentInitial extends TrackShipmentState {}

final class TrackShipmentLoading extends TrackShipmentState {}

final class TrackShipmentSuccess extends TrackShipmentState {
  final List<TrackShipmentModel> trackShipmentModel;
  TrackShipmentSuccess(this.trackShipmentModel);
}

final class TrackShipmentFailure extends TrackShipmentState {
  final String message;
  TrackShipmentFailure(this.message);
}
