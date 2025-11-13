import 'package:courier_app/features/track_order/model/shipmet_status_model.dart';

class AdminShipmentModel {
  final int? id;
  final String? awb;
  final String? senderName;
  final String? senderMobile;
  final int? senderBranch;
  final String? receiverName;
  final String? receiverMobile;
  final int? receiverBranch;
  final int? qty;
  final String? unit;
  final int? numPcs;
  final int? numBoxes;
  final double? netFee;
  final double? rate;
  final int? splitInto;
  final String? shipmentDescription;
  final ServiceMode? serviceMode;
  final PaymentMethod? paymentMethod;
  final PaymentMode? paymentMode;
  final TransportMode? transportMode;
  final DeliveryType? deliveryType;
  final ShipmentStatus? shipmentStatus;
  final User? addedBy;
  final ShipmentType? shipmentType;
  final String? createdAt;
  final String? barcodeUrl;
  final String? updatedAt;
  final double? vatRate;
  final double? vatAmount;
  final double? totalAmount;
  final VatConfig? vatConfig;
  final String? paymentStatus;
  final String? paymentStatusDescription;
  final String? transactionReference;
  final String? paymentReference;
  final String? payerAccount;
  final bool? softDelete;

  AdminShipmentModel({
    this.id,
    this.awb,
    this.senderName,
    this.senderMobile,
    this.senderBranch,
    this.receiverName,
    this.receiverMobile,
    this.receiverBranch,
    this.qty,
    this.unit,
    this.numPcs,
    this.numBoxes,
    this.netFee,
    this.rate,
    this.splitInto,
    this.shipmentDescription,
    this.serviceMode,
    this.paymentMethod,
    this.paymentMode,
    this.transportMode,
    this.deliveryType,
    this.shipmentStatus,
    this.addedBy,
    this.shipmentType,
    this.createdAt,
    this.barcodeUrl,
    this.updatedAt,
    this.vatRate,
    this.vatAmount,
    this.totalAmount,
    this.vatConfig,
    this.paymentStatus,
    this.paymentStatusDescription,
    this.transactionReference,
    this.paymentReference,
    this.payerAccount,
    this.softDelete,
  });

  factory AdminShipmentModel.fromJson(Map<String, dynamic> json) {
    // Helper to safely parse User - can be int (ID) or Map (object)
    User? _parseUser(dynamic userData) {
      if (userData == null) return null;
      if (userData is Map<String, dynamic>) {
        return User.fromJson(userData);
      }
      // If it's an int, create a minimal User with just the ID
      if (userData is int) {
        return User(id: userData);
      }
      return null;
    }

    // Handle senderBranch - can be int (ID) or Map (object)
    int? parseSenderBranch() {
      if (json['senderBranch'] == null) return null;
      if (json['senderBranch'] is int) {
        return json['senderBranch'] as int;
      }
      if (json['senderBranch'] is Map<String, dynamic>) {
        return json['senderBranch']['id'] as int?;
      }
      return null;
    }

    // Handle receiverBranch - can be int (ID) or Map (object)
    int? parseReceiverBranch() {
      if (json['receiverBranch'] == null) return null;
      if (json['receiverBranch'] is int) {
        return json['receiverBranch'] as int;
      }
      if (json['receiverBranch'] is Map<String, dynamic>) {
        return json['receiverBranch']['id'] as int?;
      }
      return null;
    }

    return AdminShipmentModel(
      id: json['id'],
      awb: json['awb'],
      senderName: json['senderName'],
      senderMobile: json['senderMobile'],
      senderBranch: parseSenderBranch(),
      receiverName: json['receiverName'],
      receiverMobile: json['receiverMobile'],
      receiverBranch: parseReceiverBranch(),
      qty: json['qty'],
      unit: json['unit'],
      numPcs: json['numPcs'],
      numBoxes: json['numBoxes'],
      netFee: (json['netFee'] as num?)?.toDouble(),
      rate: (json['rate'] as num?)?.toDouble(),
      splitInto: json['splitInto'],
      shipmentDescription: json['shipmentDescription'],
      serviceMode: json['serviceMode'] != null
          ? ServiceMode.fromJson(json['serviceMode'])
          : null,
      paymentMethod: json['paymentMethod'] != null
          ? PaymentMethod.fromJson(json['paymentMethod'])
          : null,
      paymentMode: json['paymentMode'] != null
          ? PaymentMode.fromJson(json['paymentMode'])
          : null,
      transportMode: json['transportMode'] != null
          ? TransportMode.fromJson(json['transportMode'])
          : null,
      deliveryType: json['deliveryType'] != null
          ? DeliveryType.fromJson(json['deliveryType'])
          : null,
      shipmentStatus: json['shipmentStatus'] != null
          ? ShipmentStatus.fromJson(json['shipmentStatus'])
          : null,
      addedBy: _parseUser(json['addedBy']),
      shipmentType: json['shipmentType'] != null
          ? ShipmentType.fromJson(json['shipmentType'])
          : null,
      createdAt: json['createdAt'],
      barcodeUrl: json['barcodeUrl'],
      updatedAt: json['updatedAt'],
      vatRate: (json['vatRate'] as num?)?.toDouble(),
      vatAmount: (json['vatAmount'] as num?)?.toDouble(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      vatConfig: json['vatConfig'] != null
          ? VatConfig.fromJson(json['vatConfig'])
          : null,
      paymentStatus: json['paymentStatus'],
      paymentStatusDescription: json['paymentStatusDescription'],
      transactionReference: json['transactionReference'],
      paymentReference: json['paymentReference'],
      payerAccount: json['payerAccount'],
      softDelete: json['softDelete'],
    );
  }
}

class PaymentMode {
  final int? id;
  final String? code;
  final String? description;
  final String? createdAt;
  final String? updatedAt;

  PaymentMode({
    this.id,
    this.code,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentMode.fromJson(Map<String, dynamic> json) {
    return PaymentMode(
      id: json['id'],
      code: json['code'],
      description: json['description'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class VatConfig {
  final int? id;
  final Country? country;
  final dynamic branch; // Can be int or Branch object
  final double? vatRate;
  final String? vatName;
  final User? addedBy;
  final String? createdAt;

  VatConfig({
    this.id,
    this.country,
    this.branch,
    this.vatRate,
    this.vatName,
    this.addedBy,
    this.createdAt,
  });

  factory VatConfig.fromJson(Map<String, dynamic> json) {
    // Helper to safely parse User - can be int (ID) or Map (object)
    User? _parseUser(dynamic userData) {
      if (userData == null) return null;
      if (userData is Map<String, dynamic>) {
        return User.fromJson(userData);
      }
      // If it's an int, create a minimal User with just the ID
      if (userData is int) {
        return User(id: userData);
      }
      return null;
    }

    return VatConfig(
      id: json['id'],
      country: json['country'] != null
          ? Country.fromJson(json['country'])
          : null,
      branch: json['branch'], // Keep as dynamic, can be int or object
      vatRate: (json['vatRate'] as num?)?.toDouble(),
      vatName: json['vatName'],
      addedBy: _parseUser(json['addedBy']),
      createdAt: json['createdAt'],
    );
  }
}

