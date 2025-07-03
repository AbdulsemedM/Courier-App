part of 'add_shipment_bloc.dart';

abstract class AddShipmentEvent extends Equatable {
  const AddShipmentEvent();

  @override
  List<Object> get props => [];
}

class FetchBranches extends AddShipmentEvent {
  final bool sync;
  FetchBranches(this.sync);

  @override
  List<Object> get props => [sync];
}

class FetchDeliveryTypes extends AddShipmentEvent {
  final bool sync;
  FetchDeliveryTypes(this.sync);

  @override
  List<Object> get props => [sync];
}

class FetchPaymentMethods extends AddShipmentEvent {
  final bool sync;
  FetchPaymentMethods(this.sync);

  @override
  List<Object> get props => [sync];
}

class FetchPaymentModes extends AddShipmentEvent {
  final bool sync;
  FetchPaymentModes(this.sync);

  @override
  List<Object> get props => [sync];
}

class FetchServices extends AddShipmentEvent {
  final bool sync;
  FetchServices(this.sync);

  @override
  List<Object> get props => [sync];
}

class FetchShipmentTypes extends AddShipmentEvent {
  final bool sync;
  FetchShipmentTypes(this.sync);

  @override
  List<Object> get props => [sync];
}

class FetchTransportModes extends AddShipmentEvent {
  final bool sync;
  FetchTransportModes(this.sync);

  @override
  List<Object> get props => [sync];
}

class AddShipment extends AddShipmentEvent {
  final Map<String, dynamic> body;
  AddShipment({required this.body});

  @override
  List<Object> get props => [body];
}

class FetchCustomerByPhone extends AddShipmentEvent {
  final String phoneNumber;
  FetchCustomerByPhone({required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}

class FetchSenderByPhone extends AddShipmentEvent {
  final String phoneNumber;
  FetchSenderByPhone({required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}

class FetchEstimatedRate extends AddShipmentEvent {
  final int originId;
  final int destinationId;
  FetchEstimatedRate({required this.originId, required this.destinationId});

  @override
  List<Object> get props => [originId, destinationId];
}

class InitiatePaymentEvent extends AddShipmentEvent {
  final String awb;
  final String paymentMethod;
  final int addedBy;
  InitiatePaymentEvent({
    required this.awb,
    required this.paymentMethod,
    required this.addedBy,
  });

  @override
  List<Object> get props => [awb, paymentMethod, addedBy];
}

class CheckPaymentStatusEvent extends AddShipmentEvent {
  final String awb;
  CheckPaymentStatusEvent({required this.awb});

  @override
  List<Object> get props => [awb];
}

class FetchShipmentDetailsEvent extends AddShipmentEvent {
  final String trackingNumber;
  const FetchShipmentDetailsEvent({required this.trackingNumber});

  @override
  List<Object> get props => [trackingNumber];
}
