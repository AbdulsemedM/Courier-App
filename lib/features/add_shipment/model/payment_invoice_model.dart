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
  final String? barcodeUrl;
  final String? transactionReference;
  final double? netFee;
  final double? totalAmount;
  final int? qty;
  final String? unit;
  final int? numPcs;
  final int? numBoxes;
  final int? senderBranchId;
  final int? receiverBranchId;
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
    this.barcodeUrl,
    this.transactionReference,
    this.netFee,
    this.totalAmount,
    this.qty,
    this.unit,
    this.numPcs,
    this.numBoxes,
    this.senderBranchId,
    this.receiverBranchId,
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
    String? barcodeUrl,
    String? transactionReference,
    double? netFee,
    double? totalAmount,
    int? qty,
    String? unit,
    int? numPcs,
    int? numBoxes,
    int? senderBranchId,
    int? receiverBranchId,
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
      barcodeUrl: barcodeUrl ?? this.barcodeUrl,
      transactionReference: transactionReference ?? this.transactionReference,
      netFee: netFee ?? this.netFee,
      totalAmount: totalAmount ?? this.totalAmount,
      qty: qty ?? this.qty,
      unit: unit ?? this.unit,
      numPcs: numPcs ?? this.numPcs,
      numBoxes: numBoxes ?? this.numBoxes,
      senderBranchId: senderBranchId ?? this.senderBranchId,
      receiverBranchId: receiverBranchId ?? this.receiverBranchId,
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
      'barcodeUrl': barcodeUrl,
      'transactionReference': transactionReference,
      'netFee': netFee,
      'totalAmount': totalAmount,
      'qty': qty,
      'unit': unit,
      'numPcs': numPcs,
      'numBoxes': numBoxes,
      'senderBranchId': senderBranchId,
      'receiverBranchId': receiverBranchId,
    };
  }

  factory PaymentInvoiceModel.fromMap(Map<String, dynamic> map) {
    try {
      print('[Model] PaymentInvoiceModel.fromMap called with map: $map');
      // Safely extract nested objects
      final senderBranch = map['senderBranch'];
      final receiverBranch = map['receiverBranch'];
      final paymentMethod = map['paymentMethod'];
      final deliveryType = map['deliveryType'];
      final shipmentStatus = map['shipmentStatus'];

      print(
          '[Model] senderBranch: $senderBranch (type: ${senderBranch.runtimeType})');
      print(
          '[Model] receiverBranch: $receiverBranch (type: ${receiverBranch.runtimeType})');
      print(
          '[Model] paymentMethod: $paymentMethod (type: ${paymentMethod.runtimeType})');
      print(
          '[Model] deliveryType: $deliveryType (type: ${deliveryType.runtimeType})');
      print(
          '[Model] shipmentStatus: $shipmentStatus (type: ${shipmentStatus.runtimeType})');

      // Handle senderBranch - can be int (ID) or Map
      int? senderBranchId;
      String? senderBranchName;
      String? senderBranchPhone;
      if (senderBranch is int) {
        senderBranchId = senderBranch;
      } else if (senderBranch is Map<String, dynamic>) {
        senderBranchId = senderBranch['id'] as int?;
        senderBranchName = senderBranch['name'] as String?;
        senderBranchPhone = senderBranch['phone'] as String?;
      }

      // Handle receiverBranch - can be int (ID) or Map
      int? receiverBranchId;
      String? receiverBranchName;
      String? receiverBranchPhone;
      if (receiverBranch is int) {
        receiverBranchId = receiverBranch;
      } else if (receiverBranch is Map<String, dynamic>) {
        receiverBranchId = receiverBranch['id'] as int?;
        receiverBranchName = receiverBranch['name'] as String?;
        receiverBranchPhone = receiverBranch['phone'] as String?;
      }

      return PaymentInvoiceModel(
        id: map['id'] != null ? map['id'] as int : null,
        awb: map['awb'] != null ? map['awb'] as String : null,
        senderName:
            map['senderName'] != null ? map['senderName'] as String : null,
        senderMobile:
            map['senderMobile'] != null ? map['senderMobile'] as String : null,
        senderBranch: senderBranchName,
        senderBranchPhone: senderBranchPhone,
        senderBranchId: senderBranchId,
        receiverName:
            map['receiverName'] != null ? map['receiverName'] as String : null,
        receiverMobile: map['receiverMobile'] != null
            ? map['receiverMobile'] as String
            : null,
        receiverBranch: receiverBranchName,
        receiverBranchPhone: receiverBranchPhone,
        receiverBranchId: receiverBranchId,
        shipmentDescription: map['shipmentDescription'] != null
            ? map['shipmentDescription'] as String
            : null,
        paymentMethod: (paymentMethod is Map<String, dynamic> &&
                paymentMethod["method"] != null)
            ? paymentMethod["method"] as String
            : null,
        paymentMode: (paymentMethod is Map<String, dynamic> &&
                paymentMethod["mode"] != null)
            ? paymentMethod["mode"] as String
            : (map['paymentMode'] is Map<String, dynamic> &&
                    map['paymentMode']["code"] != null)
                ? map['paymentMode']["code"] as String
                : null,
        deliveryType: (deliveryType is Map<String, dynamic> &&
                deliveryType["type"] != null)
            ? deliveryType["type"] as String
            : null,
        shipmentStatus: (shipmentStatus is Map<String, dynamic> &&
                shipmentStatus["code"] != null)
            ? shipmentStatus["code"] as String
            : null,
        paymentStatus: map['paymentStatus'] != null
            ? map['paymentStatus'] as String
            : null,
        paymentReference: map['paymentReference'] != null
            ? map['paymentReference'] as String
            : null,
        createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
        barcodeUrl:
            map['barcodeUrl'] != null ? map['barcodeUrl'] as String : null,
        transactionReference: map['transactionReference'] != null
            ? map['transactionReference'] as String
            : null,
        netFee: map['netFee'] != null
            ? (map['netFee'] is double
                ? map['netFee'] as double
                : (map['netFee'] as num).toDouble())
            : null,
        totalAmount: map['totalAmount'] != null
            ? (map['totalAmount'] is double
                ? map['totalAmount'] as double
                : (map['totalAmount'] as num).toDouble())
            : null,
        qty: map['qty'] != null
            ? (map['qty'] is int
                ? map['qty'] as int
                : (map['qty'] as num).toInt())
            : null,
        unit: map['unit'] != null ? map['unit'] as String : null,
        numPcs: map['numPcs'] != null
            ? (map['numPcs'] is int
                ? map['numPcs'] as int
                : (map['numPcs'] as num).toInt())
            : null,
        numBoxes: map['numBoxes'] != null
            ? (map['numBoxes'] is int
                ? map['numBoxes'] as int
                : (map['numBoxes'] as num).toInt())
            : null,
      );
    } catch (e) {
      print('[Model] Error in PaymentInvoiceModel.fromMap: ${e.toString()}');
      print('[Model] Error type: ${e.runtimeType}');
      print('[Model] Error stack trace: ${StackTrace.current}');
      rethrow;
    }
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
        other.createdAt == createdAt &&
        other.barcodeUrl == barcodeUrl &&
        other.transactionReference == transactionReference &&
        other.netFee == netFee &&
        other.totalAmount == totalAmount &&
        other.qty == qty &&
        other.unit == unit &&
        other.numPcs == numPcs &&
        other.numBoxes == numBoxes &&
        other.senderBranchId == senderBranchId &&
        other.receiverBranchId == receiverBranchId;
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
        createdAt.hashCode ^
        barcodeUrl.hashCode ^
        transactionReference.hashCode ^
        netFee.hashCode ^
        totalAmount.hashCode ^
        qty.hashCode ^
        unit.hashCode ^
        numPcs.hashCode ^
        numBoxes.hashCode ^
        senderBranchId.hashCode ^
        receiverBranchId.hashCode;
  }
}
