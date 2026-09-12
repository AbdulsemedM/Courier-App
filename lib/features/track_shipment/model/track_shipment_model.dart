// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

String _paymentMethodLabel(dynamic paymentData) {
  if (paymentData is Map<String, dynamic>) {
    return paymentData['method']?.toString() ??
        paymentData['code']?.toString() ??
        paymentData['description']?.toString() ??
        '';
  }
  if (paymentData is String) {
    return paymentData;
  }
  return '';
}

String _paymentModeLabel(dynamic paymentData) {
  if (paymentData is Map<String, dynamic>) {
    return paymentData['code']?.toString() ??
        paymentData['method']?.toString() ??
        paymentData['description']?.toString() ??
        '';
  }
  if (paymentData is String) {
    return paymentData;
  }
  return '';
}

String _resolvePaymentMode(Map<String, dynamic> shipment) {
  final fromMode = _paymentModeLabel(shipment['paymentMode']);
  if (fromMode.isNotEmpty) return fromMode;

  return _paymentMethodLabel(shipment['paymentMethod']);
}

String _asString(dynamic value, [String fallback = '']) {
  if (value == null) return fallback;
  final text = value.toString().trim();
  return text.isEmpty ? fallback : text;
}

String? _asNullableString(dynamic value) {
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

Map<String, dynamic>? _asStringKeyMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}

num? _asNum(dynamic value) {
  if (value is num) return value;
  if (value is String) return num.tryParse(value);
  return null;
}

class TrackShipmentModel {
  final String awb;
  final String senderName;
  final String senderMobile;
  final String receiverName;
  final String receiverMobile;
  final String name;
  final String? senderBranchName;
  final String? receiverBranchName;
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
  final int? addedByBranchId;
  final String? addedByBranchName;
  final String? shelfCode;
  final String? binCode;
  TrackShipmentModel({
    required this.awb,
    required this.senderName,
    required this.senderMobile,
    required this.receiverName,
    required this.receiverMobile,
    required this.name,
    this.senderBranchName,
    this.receiverBranchName,
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
    this.addedByBranchId,
    this.addedByBranchName,
    this.shelfCode,
    this.binCode,
  });

  /// Prefer bin code as shelf number; append shelf code when both exist.
  String? get shelfLabel {
    final bin = binCode?.trim() ?? '';
    final code = shelfCode?.trim() ?? '';
    if (bin.isNotEmpty && code.isNotEmpty) return '$bin — $code';
    if (bin.isNotEmpty) return bin;
    if (code.isNotEmpty) return code;
    return null;
  }

  TrackShipmentModel copyWith({
    String? awb,
    String? senderName,
    String? senderMobile,
    String? receiverName,
    String? receiverMobile,
    String? name,
    String? senderBranchName,
    String? receiverBranchName,
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
    int? addedByBranchId,
    String? addedByBranchName,
    String? shelfCode,
    String? binCode,
  }) {
    return TrackShipmentModel(
      awb: awb ?? this.awb,
      senderName: senderName ?? this.senderName,
      senderMobile: senderMobile ?? this.senderMobile,
      receiverName: receiverName ?? this.receiverName,
      receiverMobile: receiverMobile ?? this.receiverMobile,
      name: name ?? this.name,
      senderBranchName: senderBranchName ?? this.senderBranchName,
      receiverBranchName: receiverBranchName ?? this.receiverBranchName,
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
      addedByBranchId: addedByBranchId ?? this.addedByBranchId,
      addedByBranchName: addedByBranchName ?? this.addedByBranchName,
      shelfCode: shelfCode ?? this.shelfCode,
      binCode: binCode ?? this.binCode,
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
      'senderBranchName': senderBranchName,
      'receiverBranchName': receiverBranchName,
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
      'addedByBranchId': addedByBranchId,
      'addedByBranchName': addedByBranchName,
      'shelfCode': shelfCode,
      'binCode': binCode,
    };
  }

  factory TrackShipmentModel.fromMap(Map<String, dynamic> map) {
    // Extract shipment - handle different response structures
    final shipmentData = map['shipment'];
    final shipmentMap = _asStringKeyMap(shipmentData);
    // History events often omit nested shipment details; use the event itself.
    final shipment = shipmentMap ?? map;

    final status = _asStringKeyMap(map['status']) ??
        _asStringKeyMap(shipment['shipmentStatus']);

    // Handle senderBranch - can be int (ID) or Map
    final senderBranch = shipment['senderBranch'];
    int? senderBranchId;
    String? senderBranchName;
    if (senderBranch is int) {
      senderBranchId = senderBranch;
    } else if (senderBranch is num) {
      senderBranchId = senderBranch.toInt();
    } else {
      final senderBranchMap = _asStringKeyMap(senderBranch);
      if (senderBranchMap != null) {
        senderBranchId = _asNum(senderBranchMap['id'])?.toInt();
        senderBranchName = _asNullableString(senderBranchMap['name']);
      }
    }

    // Handle receiverBranch (destination) - can be int (ID) or Map
    final receiverBranch = shipment['receiverBranch'];
    int? receiverBranchId;
    String? receiverBranchName;
    if (receiverBranch is int) {
      receiverBranchId = receiverBranch;
    } else if (receiverBranch is num) {
      receiverBranchId = receiverBranch.toInt();
    } else {
      final receiverBranchMap = _asStringKeyMap(receiverBranch);
      if (receiverBranchMap != null) {
        receiverBranchId = _asNum(receiverBranchMap['id'])?.toInt();
        receiverBranchName = _asNullableString(receiverBranchMap['name']);
      }
    }

    // Fallback keys some APIs use for destination
    receiverBranchName ??= _asNullableString(shipment['destinationBranchName']) ??
        _asNullableString(shipment['destination']) ??
        _asNullableString(
          _asStringKeyMap(shipment['destinationBranch'])?['name'],
        );
    senderBranchName ??= _asNullableString(shipment['originBranchName']) ??
        _asNullableString(_asStringKeyMap(shipment['originBranch'])?['name']);

    // Extract delivery type
    final deliveryTypeObj = _asStringKeyMap(shipment['deliveryType']);
    String? deliveryType;
    if (deliveryTypeObj != null) {
      deliveryType = _asNullableString(deliveryTypeObj['description']) ??
          _asNullableString(deliveryTypeObj['type']);
    }

    // Extract transport mode
    final transportModeObj = _asStringKeyMap(shipment['transportMode']);
    String? transportMode;
    if (transportModeObj != null) {
      transportMode = _asNullableString(transportModeObj['description']) ??
          _asNullableString(transportModeObj['mode']);
    }

    // Extract shipment type
    final shipmentTypeObj = _asStringKeyMap(shipment['shipmentType']);
    String? shipmentType;
    if (shipmentTypeObj != null) {
      shipmentType = _asNullableString(shipmentTypeObj['type']) ??
          _asNullableString(shipmentTypeObj['description']);
    }

    // Extract status information
    String? statusCode;
    String? statusDescription;
    if (status != null) {
      statusCode = _asNullableString(status['code']);
      statusDescription = _asNullableString(status['description']);
    }

    // Prefer nested addedBy user object, then flat history fields (actionBy)
    final addedBy = _asStringKeyMap(map['addedBy']) ??
        _asStringKeyMap(shipment['addedBy']);
    String? addedByFirstName;
    String? addedByLastName;
    int? addedByBranchId;
    String? addedByBranchName;
    if (addedBy != null) {
      addedByFirstName = _asNullableString(addedBy['firstName']);
      addedByLastName = _asNullableString(addedBy['lastName']);
      final branch = addedBy['branch'];
      if (branch is int) {
        addedByBranchId = branch;
      } else if (branch is num) {
        addedByBranchId = branch.toInt();
      } else {
        final branchMap = _asStringKeyMap(branch);
        if (branchMap != null) {
          addedByBranchId = _asNum(branchMap['id'])?.toInt();
          addedByBranchName = _asNullableString(branchMap['name']);
        }
      }
    }

    // /shipment-tracking history payload uses actionBy / actionByBranchName
    addedByFirstName ??= _asNullableString(map['actionBy']) ??
        _asNullableString(map['createdByName']);
    addedByBranchName ??= _asNullableString(map['actionByBranchName']) ??
        _asNullableString(map['createdByBranchName']);

    // Extract description - prefer status description, then shipment status description
    String description = _asString(map['description']);
    if (description.isEmpty && statusDescription != null) {
      description = statusDescription;
    } else if (description.isEmpty) {
      description =
          _asString(_asStringKeyMap(shipment['shipmentStatus'])?['description']);
    }

    // Extract shelf (nested under shipment when present)
    String? shelfCode;
    String? binCode;
    final shelfObj = _asStringKeyMap(shipment['shelf']);
    if (shelfObj != null) {
      shelfCode = _asNullableString(shelfObj['shelfCode']);
      binCode = _asNullableString(shelfObj['binCode']);
    }

    final totalAmountNum = _asNum(shipment['totalAmount']);
    final qtyNum = _asNum(shipment['qty']);
    final numBoxesNum = _asNum(shipment['numBoxes']);

    return TrackShipmentModel(
      awb: _asString(shipment['awb']),
      senderName: _asString(shipment['senderName']),
      senderMobile: _asString(shipment['senderMobile']),
      receiverName: _asString(shipment['receiverName']),
      receiverMobile: _asString(shipment['receiverMobile']),
      name: receiverBranchName ?? '',
      senderBranchName: senderBranchName,
      receiverBranchName: receiverBranchName,
      netFee: _asString(shipment['netFee']),
      shipmentDescription: _asString(shipment['shipmentDescription']),
      method: _resolvePaymentMode(shipment),
      updatedBy: addedByFirstName ?? '',
      description: description,
      createdAt: _asString(map['createdAt'], _asString(shipment['createdAt'])),
      senderBranchId: senderBranchId,
      receiverBranchId: receiverBranchId,
      barcodeUrl: _asNullableString(shipment['barcodeUrl']),
      transactionReference: _asNullableString(shipment['transactionReference']),
      paymentStatus: _asNullableString(shipment['paymentStatus']),
      paymentStatusDescription:
          _asNullableString(shipment['paymentStatusDescription']),
      deliveryType: deliveryType,
      transportMode: transportMode,
      shipmentType: shipmentType,
      totalAmount: totalAmountNum?.toDouble(),
      qty: qtyNum?.toInt(),
      unit: _asNullableString(shipment['unit']),
      numBoxes: numBoxesNum?.toInt(),
      statusCode: statusCode,
      statusDescription: statusDescription,
      addedByFirstName: addedByFirstName,
      addedByLastName: addedByLastName,
      addedByBranchId: addedByBranchId,
      addedByBranchName: addedByBranchName,
      shelfCode: shelfCode,
      binCode: binCode,
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
        other.senderBranchName == senderBranchName &&
        other.receiverBranchName == receiverBranchName &&
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
        other.addedByLastName == addedByLastName &&
        other.addedByBranchId == addedByBranchId &&
        other.addedByBranchName == addedByBranchName &&
        other.shelfCode == shelfCode &&
        other.binCode == binCode;
  }

  @override
  int get hashCode {
    return awb.hashCode ^
        senderName.hashCode ^
        senderMobile.hashCode ^
        receiverName.hashCode ^
        receiverMobile.hashCode ^
        name.hashCode ^
        senderBranchName.hashCode ^
        receiverBranchName.hashCode ^
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
        addedByLastName.hashCode ^
        addedByBranchId.hashCode ^
        addedByBranchName.hashCode ^
        shelfCode.hashCode ^
        binCode.hashCode;
  }
}
