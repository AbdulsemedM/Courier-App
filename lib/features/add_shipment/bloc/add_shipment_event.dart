part of 'add_shipment_bloc.dart';

@immutable
sealed class AddShipmentEvent {}

class FetchBranches extends AddShipmentEvent {}

class FetchDeliveryTypes extends AddShipmentEvent {}

class FetchPaymentMethods extends AddShipmentEvent {}

class FetchPaymentModes extends AddShipmentEvent {}

class FetchServices extends AddShipmentEvent {}

class FetchShipmentTypes extends AddShipmentEvent {}
class FetchTransportModes extends AddShipmentEvent {}
