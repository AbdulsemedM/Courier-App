part of 'track_shipment_bloc.dart';

@immutable
sealed class TrackShipmentEvent {}

class TrackShipment extends TrackShipmentEvent {
  final String awb;
  final bool preservePreviousData;

  TrackShipment(this.awb, {this.preservePreviousData = false});
}

class TrackShipmentByPhone extends TrackShipmentEvent {
  final String phone;

  TrackShipmentByPhone(this.phone);
}

class TrackShipmentShowPhoneHistory extends TrackShipmentEvent {}

class TrackShipmentClear extends TrackShipmentEvent {}
