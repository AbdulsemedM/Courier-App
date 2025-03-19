// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ShipmentInvoiceModel {
  final String awb;
  final String senderName;
  final String senderMobile;
  final String senderbranchName;
  final String receiverName;
  final String receiverMobile;
  final String receiverBranchName;
  final String paymentMethodName;
  final String shipmentDate;
  final String invoiceDate;
  final String shipmentDescription;
  final double netFee;
  ShipmentInvoiceModel({
    required this.awb,
    required this.senderName,
    required this.senderMobile,
    required this.senderbranchName,
    required this.receiverName,
    required this.receiverMobile,
    required this.receiverBranchName,
    required this.paymentMethodName,
    required this.shipmentDate,
    required this.invoiceDate,
    required this.shipmentDescription,
    required this.netFee,
  });

  ShipmentInvoiceModel copyWith({
    String? awb,
    String? senderName,
    String? senderMobile,
    String? senderbranchName,
    String? receiverName,
    String? receiverMobile,
    String? receiverBranchName,
    String? paymentMethodName,
    String? shipmentDate,
    String? invoiceDate,
    String? shipmentDescription,
    double? netFee,
  }) {
    return ShipmentInvoiceModel(
      awb: awb ?? this.awb,
      senderName: senderName ?? this.senderName,
      senderMobile: senderMobile ?? this.senderMobile,
      senderbranchName: senderbranchName ?? this.senderbranchName,
      receiverName: receiverName ?? this.receiverName,
      receiverMobile: receiverMobile ?? this.receiverMobile,
      receiverBranchName: receiverBranchName ?? this.receiverBranchName,
      paymentMethodName: paymentMethodName ?? this.paymentMethodName,
      shipmentDate: shipmentDate ?? this.shipmentDate,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      shipmentDescription: shipmentDescription ?? this.shipmentDescription,
      netFee: netFee ?? this.netFee,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'awb': awb,
      'senderName': senderName,
      'senderMobile': senderMobile,
      'senderbranchName': senderbranchName,
      'receiverName': receiverName,
      'receiverMobile': receiverMobile,
      'receiverBranchName': receiverBranchName,
      'paymentMethodName': paymentMethodName,
      'shipmentDate': shipmentDate,
      'invoiceDate': invoiceDate,
      'shipmentDescription': shipmentDescription,
      'netFee': netFee,
    };
  }

  factory ShipmentInvoiceModel.fromMap(Map<String, dynamic> map) {
    return ShipmentInvoiceModel(
      awb: map['awb'] as String,
      senderName: map['senderName'] as String,
      senderMobile: map['senderMobile'] as String,
      senderbranchName: map['senderBranch']['name'] as String,
      receiverName: map['receiverName'] as String,
      receiverMobile: map['receiverMobile'] as String,
      receiverBranchName: map['receiverBranch']['name'] as String,
      paymentMethodName: map['paymentMethod']['method'] as String,
      shipmentDate: map['createdAt'] as String,
      invoiceDate: map['updatedAt'] as String,
      shipmentDescription: map['shipmentDescription'] as String,
      netFee: map['netFee'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShipmentInvoiceModel.fromJson(String source) =>
      ShipmentInvoiceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ShipmentInvoiceModel(awb: $awb, senderName: $senderName, senderMobile: $senderMobile, senderbranchName: $senderbranchName, receiverName: $receiverName, receiverMobile: $receiverMobile, receiverBranchName: $receiverBranchName, paymentMethodName: $paymentMethodName, shipmentDate: $shipmentDate, invoiceDate: $invoiceDate, shipmentDescription: $shipmentDescription, netFee: $netFee)';
  }

  @override
  bool operator ==(covariant ShipmentInvoiceModel other) {
    if (identical(this, other)) return true;

    return other.awb == awb &&
        other.senderName == senderName &&
        other.senderMobile == senderMobile &&
        other.senderbranchName == senderbranchName &&
        other.receiverName == receiverName &&
        other.receiverMobile == receiverMobile &&
        other.receiverBranchName == receiverBranchName &&
        other.paymentMethodName == paymentMethodName &&
        other.shipmentDate == shipmentDate &&
        other.invoiceDate == invoiceDate &&
        other.shipmentDescription == shipmentDescription &&
        other.netFee == netFee;
  }

  @override
  int get hashCode {
    return awb.hashCode ^
        senderName.hashCode ^
        senderMobile.hashCode ^
        senderbranchName.hashCode ^
        receiverName.hashCode ^
        receiverMobile.hashCode ^
        receiverBranchName.hashCode ^
        paymentMethodName.hashCode ^
        shipmentDate.hashCode ^
        invoiceDate.hashCode ^
        shipmentDescription.hashCode ^
        netFee.hashCode;
  }
}
