part of 'public_tracking_bloc.dart';

sealed class PublicTrackingEvent {}

class PublicTrackingSearchByAwb extends PublicTrackingEvent {
  final String awb;
  PublicTrackingSearchByAwb(this.awb);
}

class PublicTrackingSearchByPhone extends PublicTrackingEvent {
  final String countryDialCode;
  final String localNumber;
  PublicTrackingSearchByPhone({
    required this.countryDialCode,
    required this.localNumber,
  });
}

class PublicTrackingShipmentSelected extends PublicTrackingEvent {
  final String awb;
  PublicTrackingShipmentSelected(this.awb);
}

class PublicTrackingReset extends PublicTrackingEvent {}
