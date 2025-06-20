part of 'add_shipment_bloc.dart';

@immutable
sealed class AddShipmentEvent {}

class FetchBranches extends AddShipmentEvent {
  final bool sync;
  FetchBranches(this.sync);
}

class FetchDeliveryTypes extends AddShipmentEvent {
  final bool sync;
  FetchDeliveryTypes(this.sync);
}

class FetchPaymentMethods extends AddShipmentEvent {
  final bool sync;
  FetchPaymentMethods(this.sync);
}

class FetchPaymentModes extends AddShipmentEvent {
  final bool sync;
  FetchPaymentModes(this.sync);
}

class FetchServices extends AddShipmentEvent {
  final bool sync;
  FetchServices(this.sync);
}

class FetchShipmentTypes extends AddShipmentEvent {
  final bool sync;
  FetchShipmentTypes(this.sync);
}

class FetchTransportModes extends AddShipmentEvent {
  final bool sync;
  FetchTransportModes(this.sync);
}

class AddShipment extends AddShipmentEvent {
  final Map<String, dynamic> body;
  AddShipment({required this.body});
}

class FetchCustomerByPhone extends AddShipmentEvent {
  final String phoneNumber;
  FetchCustomerByPhone({required this.phoneNumber});
}

class FetchSenderByPhone extends AddShipmentEvent {
  final String phoneNumber;
  FetchSenderByPhone({required this.phoneNumber});
}

class FetchEstimatedRate extends AddShipmentEvent {
  final int originId;
  final int destinationId;
  FetchEstimatedRate({required this.originId, required this.destinationId});
}
