// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TrackShipmentModel {
  final String awb;
  final String senderName;
  final String senderMobile;
  final String receiverName;
  final String receiverMobile;
  final String name;
  final String netFee;
  final String shipmentDescription;
  final String method;
  final String updatedBy;
  final String description;
  final String createdAt;
  final int? senderBranchId;
  final int? receiverBranchId;
  final String? barcodeUrl;
  final String? transactionReference;
  final String? paymentStatus;
  final String? paymentStatusDescription;
  final String? deliveryType;
  final String? transportMode;
  final String? shipmentType;
  final double? totalAmount;
  final int? qty;
  final String? unit;
  final int? numBoxes;
  final String? statusCode;
  final String? statusDescription;
  final String? addedByFirstName;
  final String? addedByLastName;
  TrackShipmentModel({
    required this.awb,
    required this.senderName,
    required this.senderMobile,
    required this.receiverName,
    required this.receiverMobile,
    required this.name,
    required this.netFee,
    required this.shipmentDescription,
    required this.method,
    required this.updatedBy,
    required this.description,
    required this.createdAt,
    this.senderBranchId,
    this.receiverBranchId,
    this.barcodeUrl,
    this.transactionReference,
    this.paymentStatus,
    this.paymentStatusDescription,
    this.deliveryType,
    this.transportMode,
    this.shipmentType,
    this.totalAmount,
    this.qty,
    this.unit,
    this.numBoxes,
    this.statusCode,
    this.statusDescription,
    this.addedByFirstName,
    this.addedByLastName,
  });

  TrackShipmentModel copyWith({
    String? awb,
    String? senderName,
    String? senderMobile,
    String? receiverName,
    String? receiverMobile,
    String? name,
    String? netFee,
    String? shipmentDescription,
    String? method,
    String? updatedBy,
    String? description,
    String? createdAt,
    int? senderBranchId,
    int? receiverBranchId,
    String? barcodeUrl,
    String? transactionReference,
    String? paymentStatus,
    String? paymentStatusDescription,
    String? deliveryType,
    String? transportMode,
    String? shipmentType,
    double? totalAmount,
    int? qty,
    String? unit,
    int? numBoxes,
    String? statusCode,
    String? statusDescription,
    String? addedByFirstName,
    String? addedByLastName,
  }) {
    return TrackShipmentModel(
      awb: awb ?? this.awb,
      senderName: senderName ?? this.senderName,
      senderMobile: senderMobile ?? this.senderMobile,
      receiverName: receiverName ?? this.receiverName,
      receiverMobile: receiverMobile ?? this.receiverMobile,
      name: name ?? this.name,
      netFee: netFee ?? this.netFee,
      shipmentDescription: shipmentDescription ?? this.shipmentDescription,
      method: method ?? this.method,
      updatedBy: updatedBy ?? this.updatedBy,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      senderBranchId: senderBranchId ?? this.senderBranchId,
      receiverBranchId: receiverBranchId ?? this.receiverBranchId,
      barcodeUrl: barcodeUrl ?? this.barcodeUrl,
      transactionReference: transactionReference ?? this.transactionReference,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentStatusDescription:
          paymentStatusDescription ?? this.paymentStatusDescription,
      deliveryType: deliveryType ?? this.deliveryType,
      transportMode: transportMode ?? this.transportMode,
      shipmentType: shipmentType ?? this.shipmentType,
      totalAmount: totalAmount ?? this.totalAmount,
      qty: qty ?? this.qty,
      unit: unit ?? this.unit,
      numBoxes: numBoxes ?? this.numBoxes,
      statusCode: statusCode ?? this.statusCode,
      statusDescription: statusDescription ?? this.statusDescription,
      addedByFirstName: addedByFirstName ?? this.addedByFirstName,
      addedByLastName: addedByLastName ?? this.addedByLastName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'awb': awb,
      'senderName': senderName,
      'senderMobile': senderMobile,
      'receiverName': receiverName,
      'receiverMobile': receiverMobile,
      'name': name,
      'netFee': netFee,
      'shipmentDescription': shipmentDescription,
      'method': method,
      'updatedBy': updatedBy,
      'description': description,
      'createdAt': createdAt,
      'senderBranchId': senderBranchId,
      'receiverBranchId': receiverBranchId,
      'barcodeUrl': barcodeUrl,
      'transactionReference': transactionReference,
      'paymentStatus': paymentStatus,
      'paymentStatusDescription': paymentStatusDescription,
      'deliveryType': deliveryType,
      'transportMode': transportMode,
      'shipmentType': shipmentType,
      'totalAmount': totalAmount,
      'qty': qty,
      'unit': unit,
      'numBoxes': numBoxes,
      'statusCode': statusCode,
      'statusDescription': statusDescription,
      'addedByFirstName': addedByFirstName,
      'addedByLastName': addedByLastName,
    };
  }

  factory TrackShipmentModel.fromMap(Map<String, dynamic> map) {
    final shipment = map['shipment'] ?? map;
    final status = map['status'] ?? shipment['shipmentStatus'];

    // Handle senderBranch - can be int (ID) or Map
    final senderBranch = shipment['senderBranch'];
    int? senderBranchId;
    if (senderBranch is int) {
      senderBranchId = senderBranch;
    } else if (senderBranch is Map<String, dynamic>) {
      senderBranchId = senderBranch['id'] as int?;
    }

    // Handle receiverBranch - can be int (ID) or Map
    final receiverBranch = shipment['receiverBranch'];
    int? receiverBranchId;
    String? receiverBranchName;
    if (receiverBranch is int) {
      receiverBranchId = receiverBranch;
    } else if (receiverBranch is Map<String, dynamic>) {
      receiverBranchId = receiverBranch['id'] as int?;
      receiverBranchName = receiverBranch['name'] as String?;
    }

    // Extract delivery type
    final deliveryTypeObj = shipment['deliveryType'];
    String? deliveryType;
    if (deliveryTypeObj is Map<String, dynamic>) {
      deliveryType = deliveryTypeObj['description'] as String? ??
          deliveryTypeObj['type'] as String?;
    }

    // Extract transport mode
    final transportModeObj = shipment['transportMode'];
    String? transportMode;
    if (transportModeObj is Map<String, dynamic>) {
      transportMode = transportModeObj['description'] as String? ??
          transportModeObj['mode'] as String?;
    }

    // Extract shipment type
    final shipmentTypeObj = shipment['shipmentType'];
    String? shipmentType;
    if (shipmentTypeObj is Map<String, dynamic>) {
      shipmentType = shipmentTypeObj['type'] as String? ??
          shipmentTypeObj['description'] as String?;
    }

    // Extract status information
    String? statusCode;
    String? statusDescription;
    if (status is Map<String, dynamic>) {
      statusCode = status['code'] as String?;
      statusDescription = status['description'] as String?;
    }

    // Extract addedBy information
    final addedBy = shipment['addedBy'];
    String? addedByFirstName;
    String? addedByLastName;
    if (addedBy is Map<String, dynamic>) {
      addedByFirstName = addedBy['firstName'] as String?;
      addedByLastName = addedBy['lastName'] as String?;
    }

    // Extract description - prefer status description, then shipment status description
    String description = '';
    if (map['description'] != null) {
      description = map['description'].toString();
    } else if (statusDescription != null) {
      description = statusDescription;
    } else if (shipment['shipmentStatus'] is Map<String, dynamic>) {
      description = shipment['shipmentStatus']['description'] as String? ?? '';
    }

    return TrackShipmentModel(
      awb: shipment['awb'] as String? ?? '',
      senderName: shipment['senderName'] as String? ?? '',
      senderMobile: shipment['senderMobile'] as String? ?? '',
      receiverName: shipment['receiverName'] as String? ?? '',
      receiverMobile: shipment['receiverMobile'] as String? ?? '',
      name: receiverBranchName ?? '',
      netFee: (shipment['netFee'] ?? '').toString(),
      shipmentDescription: shipment['shipmentDescription'] as String? ?? '',
      method: shipment['paymentMethod']?['method'] as String? ?? '',
      updatedBy: addedByFirstName ?? '',
      description: description,
      createdAt:
          map['createdAt'] as String? ?? shipment['createdAt'] as String? ?? '',
      senderBranchId: senderBranchId,
      receiverBranchId: receiverBranchId,
      barcodeUrl: shipment['barcodeUrl'] as String?,
      transactionReference: shipment['transactionReference'] as String?,
      paymentStatus: shipment['paymentStatus'] as String?,
      paymentStatusDescription: shipment['paymentStatusDescription'] as String?,
      deliveryType: deliveryType,
      transportMode: transportMode,
      shipmentType: shipmentType,
      totalAmount: shipment['totalAmount'] != null
          ? (shipment['totalAmount'] is double
              ? shipment['totalAmount'] as double
              : (shipment['totalAmount'] as num).toDouble())
          : null,
      qty: shipment['qty'] != null
          ? (shipment['qty'] is int
              ? shipment['qty'] as int
              : (shipment['qty'] as num).toInt())
          : null,
      unit: shipment['unit'] as String?,
      numBoxes: shipment['numBoxes'] != null
          ? (shipment['numBoxes'] is int
              ? shipment['numBoxes'] as int
              : (shipment['numBoxes'] as num).toInt())
          : null,
      statusCode: statusCode,
      statusDescription: statusDescription,
      addedByFirstName: addedByFirstName,
      addedByLastName: addedByLastName,
    );
  }

  String toJson() => json.encode(toMap());

  factory TrackShipmentModel.fromJson(String source) =>
      TrackShipmentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TrackShipmentModel(awb: $awb, senderName: $senderName, senderMobile: $senderMobile, receiverName: $receiverName, receiverMobile: $receiverMobile, name: $name, netFee: $netFee, shipmentDescription: $shipmentDescription, method: $method, updatedBy: $updatedBy, description: $descriptionو createdAt:$createdAt)';
  }

  @override
  bool operator ==(covariant TrackShipmentModel other) {
    if (identical(this, other)) return true;

    return other.awb == awb &&
        other.senderName == senderName &&
        other.senderMobile == senderMobile &&
        other.receiverName == receiverName &&
        other.receiverMobile == receiverMobile &&
        other.name == name &&
        other.netFee == netFee &&
        other.shipmentDescription == shipmentDescription &&
        other.method == method &&
        other.updatedBy == updatedBy &&
        other.createdAt == createdAt &&
        other.description == description &&
        other.senderBranchId == senderBranchId &&
        other.receiverBranchId == receiverBranchId &&
        other.barcodeUrl == barcodeUrl &&
        other.transactionReference == transactionReference &&
        other.paymentStatus == paymentStatus &&
        other.paymentStatusDescription == paymentStatusDescription &&
        other.deliveryType == deliveryType &&
        other.transportMode == transportMode &&
        other.shipmentType == shipmentType &&
        other.totalAmount == totalAmount &&
        other.qty == qty &&
        other.unit == unit &&
        other.numBoxes == numBoxes &&
        other.statusCode == statusCode &&
        other.statusDescription == statusDescription &&
        other.addedByFirstName == addedByFirstName &&
        other.addedByLastName == addedByLastName;
  }

  @override
  int get hashCode {
    return awb.hashCode ^
        senderName.hashCode ^
        senderMobile.hashCode ^
        receiverName.hashCode ^
        receiverMobile.hashCode ^
        name.hashCode ^
        netFee.hashCode ^
        shipmentDescription.hashCode ^
        method.hashCode ^
        updatedBy.hashCode ^
        createdAt.hashCode ^
        description.hashCode ^
        senderBranchId.hashCode ^
        receiverBranchId.hashCode ^
        barcodeUrl.hashCode ^
        transactionReference.hashCode ^
        paymentStatus.hashCode ^
        paymentStatusDescription.hashCode ^
        deliveryType.hashCode ^
        transportMode.hashCode ^
        shipmentType.hashCode ^
        totalAmount.hashCode ^
        qty.hashCode ^
        unit.hashCode ^
        numBoxes.hashCode ^
        statusCode.hashCode ^
        statusDescription.hashCode ^
        addedByFirstName.hashCode ^
        addedByLastName.hashCode;
  }
}
