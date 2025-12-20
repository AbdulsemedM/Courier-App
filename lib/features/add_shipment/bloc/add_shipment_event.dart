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
  final int serviceModeId;
  final int shipmentTypeId;
  final int deliveryTypeId;
  final String unit;
  FetchEstimatedRate({
    required this.originId,
    required this.destinationId,
    required this.serviceModeId,
    required this.shipmentTypeId,
    required this.deliveryTypeId,
    required this.unit,
  });

  @override
  List<Object> get props => [
        originId,
        destinationId,
        serviceModeId,
        shipmentTypeId,
        deliveryTypeId,
        unit,
      ];
}

class CheckDiscount extends AddShipmentEvent {
  final int originId;
  final int destinationId;
  final int serviceModeId;
  final int shipmentTypeId;
  final int deliveryTypeId;
  final String unit;
  final double weightKg;
  final double discountPricePerKg;
  CheckDiscount({
    required this.originId,
    required this.destinationId,
    required this.serviceModeId,
    required this.shipmentTypeId,
    required this.deliveryTypeId,
    required this.unit,
    required this.weightKg,
    required this.discountPricePerKg,
  });

  @override
  List<Object> get props => [
        originId,
        destinationId,
        serviceModeId,
        shipmentTypeId,
        deliveryTypeId,
        unit,
        weightKg,
        discountPricePerKg,
      ];
}

class InitiatePaymentEvent extends AddShipmentEvent {
  final String awb;
  final String paymentMethod;
  final String payerAccount;
  final int addedBy;
  InitiatePaymentEvent({
    required this.awb,
    required this.paymentMethod,
    required this.payerAccount,
    required this.addedBy,
  });

  @override
  List<Object> get props => [awb, paymentMethod, payerAccount, addedBy];
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
