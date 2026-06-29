import 'package:courier_app/features/track_order/model/shipmet_status_model.dart';

class BranchShipmentModel {
  final int? id;
  final String? awb;
  final String? senderName;
  final String? senderMobile;
  final int? senderBranch;
  final Branch? senderBranchDetail;
  final String? receiverName;
  final String? receiverMobile;
  final int? receiverBranch;
  final Branch? receiverBranchDetail;
  final double? qty;
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
  final String? reportPaymentMethod;
  final String? reportStatus;
  final String? reportCreatedByName;
  final String? reportBranchName;

  BranchShipmentModel({
    this.id,
    this.awb,
    this.senderName,
    this.senderMobile,
    this.senderBranch,
    this.senderBranchDetail,
    this.receiverName,
    this.receiverMobile,
    this.receiverBranch,
    this.receiverBranchDetail,
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
    this.reportPaymentMethod,
    this.reportStatus,
    this.reportCreatedByName,
    this.reportBranchName,
  });

  factory BranchShipmentModel.fromReportJson(Map<String, dynamic> json) {
    double? toDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString());
    }

    PaymentMethod? parsePaymentMethod() {
      final value = json['paymentMethod'];
      if (value == null) return null;
      if (value is Map<String, dynamic>) {
        return PaymentMethod.fromJson(value);
      }
      if (value is String) {
        return PaymentMethod(method: value);
      }
      return null;
    }

    ShipmentStatus? parseShipmentStatus() {
      final value = json['status'] ?? json['shipmentStatus'];
      if (value == null) return null;
      if (value is Map<String, dynamic>) {
        return ShipmentStatus.fromJson(value);
      }
      if (value is String) {
        return ShipmentStatus(code: value);
      }
      return null;
    }

    final paymentMethodValue = json['paymentMethod'];
    final statusValue = json['status'] ?? json['shipmentStatus'];

    String? firstNonEmpty(List<dynamic> values) {
      for (final value in values) {
        final text = value?.toString().trim();
        if (text != null && text.isNotEmpty) {
          return text;
        }
      }
      return null;
    }

    return BranchShipmentModel(
      id: json['id'],
      awb: json['awb']?.toString(),
      senderName: json['senderName']?.toString(),
      senderMobile: firstNonEmpty([
        json['senderMobile'],
        json['senderPhone'],
        json['senderMobileNumber'],
        json['senderMobileNo'],
      ]),
      receiverName: json['receiverName']?.toString(),
      receiverMobile: firstNonEmpty([
        json['receiverMobile'],
        json['receiverPhone'],
        json['receiverMobileNumber'],
        json['receiverMobileNo'],
      ]),
      qty: toDouble(json['qty'] ?? json['quantity']),
      netFee: toDouble(json['netFee']),
      totalAmount: toDouble(json['totalAmount'] ?? json['codAmount']),
      shipmentDescription: json['shipmentDescription']?.toString(),
      paymentMethod: parsePaymentMethod(),
      shipmentStatus: parseShipmentStatus(),
      createdAt: json['createdAt']?.toString(),
      reportPaymentMethod:
          paymentMethodValue is String ? paymentMethodValue : null,
      reportStatus: statusValue is String ? statusValue : null,
      reportCreatedByName: json['createdByName']?.toString(),
      reportBranchName: json['createdByBranch']?.toString(),
    );
  }

  factory BranchShipmentModel.fromJson(Map<String, dynamic> json) {
    int? _toInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString());
    }

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

    double? _toDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString());
    }

    Branch? parseBranchDetail(dynamic branchData) {
      if (branchData == null) return null;
      if (branchData is Map<String, dynamic>) {
        return Branch.fromJson(branchData);
      }
      if (branchData is num) {
        return Branch(id: branchData.toInt());
      }
      return null;
    }

    PaymentMethod? _parsePaymentMethod(dynamic value) {
      if (value == null) return null;
      if (value is Map<String, dynamic>) {
        return PaymentMethod.fromJson(value);
      }
      if (value is String) {
        return PaymentMethod(method: value);
      }
      return null;
    }

    ShipmentStatus? _parseShipmentStatus(dynamic value) {
      if (value == null) return null;
      if (value is Map<String, dynamic>) {
        return ShipmentStatus.fromJson(value);
      }
      if (value is String) {
        return ShipmentStatus(code: value);
      }
      return null;
    }

    // Handle senderBranch - can be int (ID) or Map (object)
    int? parseSenderBranch() {
      return parseBranchDetail(json['senderBranch'])?.id;
    }

    // Handle receiverBranch - can be int (ID) or Map (object)
    int? parseReceiverBranch() {
      return parseBranchDetail(json['receiverBranch'])?.id;
    }

    return BranchShipmentModel(
      id: json['id'],
      awb: json['awb'],
      senderName: json['senderName'],
      senderMobile: json['senderMobile'],
      senderBranch: parseSenderBranch(),
      senderBranchDetail: parseBranchDetail(json['senderBranch']),
      receiverName: json['receiverName'],
      receiverMobile: json['receiverMobile'],
      receiverBranch: parseReceiverBranch(),
      receiverBranchDetail: parseBranchDetail(json['receiverBranch']),
      qty: _toDouble(json['qty'] ?? json['quantity']),
      unit: json['unit'],
      numPcs: _toInt(json['numPcs']),
      numBoxes: _toInt(json['numBoxes']),
      netFee: (json['netFee'] as num?)?.toDouble(),
      rate: (json['rate'] as num?)?.toDouble(),
      splitInto: _toInt(json['splitInto']),
      shipmentDescription: json['shipmentDescription'],
      serviceMode: json['serviceMode'] != null
          ? ServiceMode.fromJson(json['serviceMode'])
          : null,
      paymentMethod: _parsePaymentMethod(json['paymentMethod']),
      paymentMode: json['paymentMode'] != null
          ? PaymentMode.fromJson(json['paymentMode'])
          : null,
      transportMode: json['transportMode'] != null
          ? TransportMode.fromJson(json['transportMode'])
          : null,
      deliveryType: json['deliveryType'] != null
          ? DeliveryType.fromJson(json['deliveryType'])
          : null,
      shipmentStatus: _parseShipmentStatus(
        json['shipmentStatus'] ?? json['status'],
      ),
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

  String get paymentMethodCode {
    if (reportPaymentMethod != null && reportPaymentMethod!.isNotEmpty) {
      return reportPaymentMethod!.toUpperCase();
    }
    final method = paymentMethod?.method ??
        paymentMode?.code ??
        paymentMode?.description ??
        '';
    return method.toUpperCase();
  }

  String get statusCode =>
      reportStatus ?? shipmentStatus?.code ?? 'N/A';

  double get feeAmount => netFee ?? totalAmount ?? 0;

  String? get branchDisplayName =>
      reportBranchName ??
      senderBranchDetail?.name ??
      receiverBranchDetail?.name;

  String get addedByName {
    if (reportCreatedByName != null && reportCreatedByName!.isNotEmpty) {
      return reportCreatedByName!;
    }
    if (addedBy == null) return '';
    return [
      addedBy!.firstName,
      addedBy!.secondName,
      addedBy!.lastName,
    ].whereType<String>().where((part) => part.trim().isNotEmpty).join(' ');
  }

  String get senderMobileDisplay {
    final mobile = senderMobile?.trim();
    if (mobile == null || mobile.isEmpty) return 'No mobile';
    return mobile;
  }

  String get receiverMobileDisplay {
    final mobile = receiverMobile?.trim();
    if (mobile == null || mobile.isEmpty) return 'No mobile';
    return mobile;
  }

  static String _digitsOnly(String? value) {
    if (value == null) return '';
    return value.replaceAll(RegExp(r'\D'), '');
  }

  bool matchesSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return true;

    final lowerQuery = trimmed.toLowerCase();
    final digitQuery = _digitsOnly(trimmed);

    if ((awb ?? '').toLowerCase().contains(lowerQuery)) {
      return true;
    }

    if ((senderName ?? '').toLowerCase().contains(lowerQuery)) {
      return true;
    }

    if ((receiverName ?? '').toLowerCase().contains(lowerQuery)) {
      return true;
    }

    if (digitQuery.isNotEmpty) {
      final senderDigits = _digitsOnly(senderMobile);
      final receiverDigits = _digitsOnly(receiverMobile);

      if (senderDigits.contains(digitQuery)) {
        return true;
      }
      if (receiverDigits.contains(digitQuery)) {
        return true;
      }
    }

    return false;
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
      country:
          json['country'] != null ? Country.fromJson(json['country']) : null,
      branch: json['branch'], // Keep as dynamic, can be int or object
      vatRate: (json['vatRate'] as num?)?.toDouble(),
      vatName: json['vatName'],
      addedBy: _parseUser(json['addedBy']),
      createdAt: json['createdAt'],
    );
  }
}
