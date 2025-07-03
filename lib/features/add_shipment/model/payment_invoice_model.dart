// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PaymentInvoiceModel {
  final int? id;
  final String? awb;
  final String? senderName;
  final String? senderMobile;
  final String? senderBranch;
  final String? senderBranchPhone;
  final String? receiverName;
  final String? receiverMobile;
  final String? receiverBranch;
  final String? receiverBranchPhone;
  final String? shipmentDescription;
  final String? paymentMethod;
  final String? paymentMode;
  final String? deliveryType;
  final String? shipmentStatus;
  final String? paymentStatus;
  final String? paymentReference;
  final String? createdAt;
  PaymentInvoiceModel({
    this.id,
    this.awb,
    this.senderName,
    this.senderMobile,
    this.senderBranch,
    this.senderBranchPhone,
    this.receiverName,
    this.receiverMobile,
    this.receiverBranch,
    this.receiverBranchPhone,
    this.shipmentDescription,
    this.paymentMethod,
    this.paymentMode,
    this.deliveryType,
    this.shipmentStatus,
    this.paymentStatus,
    this.paymentReference,
    this.createdAt,
  });

  PaymentInvoiceModel copyWith({
    int? id,
    String? awb,
    String? senderName,
    String? senderMobile,
    String? senderBranch,
    String? receiverName,
    String? receiverMobile,
    String? receiverBranch,
    String? receiverBranchPhone,
    String? shipmentDescription,
    String? paymentMethod,
    String? paymentMode,
    String? deliveryType,
    String? shipmentStatus,
    String? paymentStatus,
    String? paymentReference,
    String? createdAt,
  }) {
    return PaymentInvoiceModel(
      id: id ?? this.id,
      awb: awb ?? this.awb,
      senderName: senderName ?? this.senderName,
      senderMobile: senderMobile ?? this.senderMobile,
      senderBranch: senderBranch ?? this.senderBranch,
      senderBranchPhone: senderBranchPhone ?? this.senderBranchPhone,
      receiverName: receiverName ?? this.receiverName,
      receiverMobile: receiverMobile ?? this.receiverMobile,
      receiverBranch: receiverBranch ?? this.receiverBranch,
      receiverBranchPhone: receiverBranchPhone ?? this.receiverBranchPhone,
      shipmentDescription: shipmentDescription ?? this.shipmentDescription,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentMode: paymentMode ?? this.paymentMode,
      deliveryType: deliveryType ?? this.deliveryType,
      shipmentStatus: shipmentStatus ?? this.shipmentStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentReference: paymentReference ?? this.paymentReference,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'awb': awb,
      'senderName': senderName,
      'senderMobile': senderMobile,
      'senderBranch': senderBranch,
      'senderBranchPhone': senderBranchPhone,
      'receiverName': receiverName,
      'receiverMobile': receiverMobile,
      'receiverBranch': receiverBranch,
      'receiverBranchPhone': receiverBranchPhone,
      'shipmentDescription': shipmentDescription,
      'paymentMethod': paymentMethod,
      'paymentMode': paymentMode,
      'deliveryType': deliveryType,
      'shipmentStatus': shipmentStatus,
      'paymentStatus': paymentStatus,
      'paymentReference': paymentReference,
      'createdAt': createdAt,
    };
  }

  factory PaymentInvoiceModel.fromMap(Map<String, dynamic> map) {
    return PaymentInvoiceModel(
      id: map['id'] != null ? map['id'] as int : null,
      awb: map['awb'] != null ? map['awb'] as String : null,
      senderName:
          map['senderName'] != null ? map['senderName'] as String : null,
      senderMobile:
          map['senderMobile'] != null ? map['senderMobile'] as String : null,
      senderBranch: map['senderBranch']["name"] != null
          ? map['senderBranch']["name"] as String
          : null,
      senderBranchPhone: map['senderBranch']["phone"] != null
          ? map['senderBranch']["phone"] as String
          : null,
      receiverName:
          map['receiverName'] != null ? map['receiverName'] as String : null,
      receiverMobile: map['receiverMobile'] != null
          ? map['receiverMobile'] as String
          : null,
      receiverBranch: map['receiverBranch']["name"] != null
          ? map['receiverBranch']["name"] as String
          : null,
      receiverBranchPhone: map['receiverBranch']["phone"] != null
          ? map['receiverBranch']["phone"] as String
          : null,
      shipmentDescription: map['shipmentDescription'] != null
          ? map['shipmentDescription'] as String
          : null,
      paymentMethod: map['paymentMethod']["method"] != null
          ? map['paymentMethod']["method"] as String
          : null,
      paymentMode: map['paymentMethod']["mode"] != null
          ? map['paymentMethod']["mode"] as String
          : null,
      deliveryType: map['deliveryType']["type"] != null
          ? map['deliveryType']["type"] as String
          : null,
      shipmentStatus: map['shipmentStatus']["code"] != null
          ? map['shipmentStatus']["code"] as String
          : null,
      paymentStatus:
          map['paymentStatus'] != null ? map['paymentStatus'] as String : null,
      paymentReference: map['paymentReference'] != null
          ? map['paymentReference'] as String
          : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentInvoiceModel.fromJson(String source) =>
      PaymentInvoiceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PaymentInvoiceModel(id: $id, awb: $awb, senderName: $senderName, senderMobile: $senderMobile, senderBranch: $senderBranch, senderBranchPhone: $senderBranchPhone, receiverName: $receiverName, receiverMobile: $receiverMobile, receiverBranch: $receiverBranch, receiverBranchPhone: $receiverBranchPhone  , paymentMethod: $paymentMethod, paymentMode: $paymentMode, deliveryType: $deliveryType, shipmentStatus: $shipmentStatus, paymentStatus: $paymentStatus, paymentReference: $paymentReference, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant PaymentInvoiceModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.awb == awb &&
        other.senderName == senderName &&
        other.senderMobile == senderMobile &&
        other.senderBranch == senderBranch &&
        other.senderBranchPhone == senderBranchPhone &&
        other.receiverName == receiverName &&
        other.receiverMobile == receiverMobile &&
        other.receiverBranch == receiverBranch &&
        other.receiverBranchPhone == receiverBranchPhone &&
        other.shipmentDescription == shipmentDescription &&
        other.paymentMethod == paymentMethod &&
        other.paymentMode == paymentMode &&
        other.deliveryType == deliveryType &&
        other.shipmentStatus == shipmentStatus &&
        other.paymentStatus == paymentStatus &&
        other.paymentReference == paymentReference &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        awb.hashCode ^
        senderName.hashCode ^
        senderMobile.hashCode ^
        senderBranch.hashCode ^
        senderBranchPhone.hashCode ^
        receiverName.hashCode ^
        receiverMobile.hashCode ^
        receiverBranch.hashCode ^
        receiverBranchPhone.hashCode ^
        shipmentDescription.hashCode ^
        paymentMethod.hashCode ^
        paymentMode.hashCode ^
        deliveryType.hashCode ^
        shipmentStatus.hashCode ^
        paymentStatus.hashCode ^
        paymentReference.hashCode ^
        createdAt.hashCode;
  }
}
