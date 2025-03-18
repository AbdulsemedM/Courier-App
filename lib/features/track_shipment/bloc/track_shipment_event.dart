part of 'track_shipment_bloc.dart';

@immutable
sealed class TrackShipmentEvent {}

class TrackShipment extends TrackShipmentEvent {
  final String awb;
  TrackShipment(this.awb);
}
