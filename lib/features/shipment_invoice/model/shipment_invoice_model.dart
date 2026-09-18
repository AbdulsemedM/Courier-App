// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:courier_app/core/utils/branch_name_resolver.dart';
import 'package:courier_app/features/branches/model/branches_model.dart';

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
  final int qty;
  final String unit;
  final int numPcs;
  final String serviceModeName;
  final String paymentModeName;
  final double totalAmount;
  final double vatAmount;
  final double vatRate;
  final int? senderBranchId;
  final int? receiverBranchId;
  final String? shipmentStatusCode;
  final String? shipmentStatusDescription;
  final String? paymentStatus;
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
    this.qty = 1,
    this.unit = 'kg',
    this.numPcs = 0,
    this.serviceModeName = 'COURIER',
    this.paymentModeName = 'N/A',
    this.totalAmount = 0,
    this.vatAmount = 0,
    this.vatRate = 0,
    this.senderBranchId,
    this.receiverBranchId,
    this.shipmentStatusCode,
    this.shipmentStatusDescription,
    this.paymentStatus,
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

  ShipmentInvoiceModel withResolvedBranchNames(
    List<BranchesModel> branches,
  ) {
    final lookup = BranchNameResolver.lookupFromBranches(branches);
    return ShipmentInvoiceModel(
      awb: awb,
      senderName: senderName,
      senderMobile: senderMobile,
      senderbranchName: BranchNameResolver.resolve(
        name: senderbranchName,
        branchId: senderBranchId,
        branchNamesById: lookup,
        branches: branches,
      ),
      receiverName: receiverName,
      receiverMobile: receiverMobile,
      receiverBranchName: BranchNameResolver.resolve(
        name: receiverBranchName,
        branchId: receiverBranchId,
        branchNamesById: lookup,
        branches: branches,
        awb: awb,
      ),
      paymentMethodName: paymentMethodName,
      shipmentDate: shipmentDate,
      invoiceDate: invoiceDate,
      shipmentDescription: shipmentDescription,
      netFee: netFee,
      qty: qty,
      unit: unit,
      numPcs: numPcs,
      serviceModeName: serviceModeName,
      paymentModeName: paymentModeName,
      totalAmount: totalAmount,
      vatAmount: vatAmount,
      vatRate: vatRate,
      senderBranchId: senderBranchId,
      receiverBranchId: receiverBranchId,
      shipmentStatusCode: shipmentStatusCode,
      shipmentStatusDescription: shipmentStatusDescription,
      paymentStatus: paymentStatus,
    );
  }

  Map<String, dynamic> toPrintMap() {
    return <String, dynamic>{
      'senderName': senderName,
      'senderMobile': senderMobile,
      'senderBranch': senderbranchName,
      'senderBranchId': senderBranchId,
      'receiverName': receiverName,
      'receiverMobile': receiverMobile,
      'receiverBranch': receiverBranchName,
      'receiverBranchId': receiverBranchId,
      'shipmentDescription': shipmentDescription,
      'qty': qty,
      'unit': unit,
      'numPcs': numPcs,
      'netFee': netFee,
      'totalAmount': totalAmount > 0 ? totalAmount : netFee,
      'vatAmount': vatAmount,
      'vatRate': vatRate,
      'serviceMode': {'description': serviceModeName},
      'paymentMode': paymentModeName,
      'paymentMethod': {'method': paymentMethodName},
      'createdAt': shipmentDate,
      'updatedAt': invoiceDate,
    };
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

  static String _branchNameFrom(Map<String, dynamic> map, String branchKey) {
    final parsed = BranchNameResolver.parseName(map[branchKey]);
    if (parsed.isNotEmpty) return parsed;

    final altKey = branchKey == 'senderBranch'
        ? 'senderBranchName'
        : 'receiverBranchName';
    final altValue = map[altKey]?.toString().trim() ?? '';
    if (!BranchNameResolver.isMissingName(altValue)) return altValue;

    return '';
  }

  static int? _branchIdFrom(Map<String, dynamic> map, String branchKey) {
    return BranchNameResolver.parseId(map[branchKey]) ??
        BranchNameResolver.parseId(map['${branchKey}Id']);
  }

  static String _paymentMethodNameFrom(dynamic paymentMethod) {
    if (paymentMethod == null) return 'N/A';
    if (paymentMethod is Map) {
      final map = Map<String, dynamic>.from(paymentMethod);
      return map['method']?.toString() ??
          map['code']?.toString() ??
          map['description']?.toString() ??
          'N/A';
    }
    return paymentMethod.toString();
  }

  static String _paymentModeNameFrom(dynamic paymentMode) {
    if (paymentMode == null) return 'N/A';
    if (paymentMode is Map) {
      final map = Map<String, dynamic>.from(paymentMode);
      return map['code']?.toString() ??
          map['method']?.toString() ??
          map['description']?.toString() ??
          'N/A';
    }
    return paymentMode.toString();
  }

  static String? _shipmentStatusCodeFrom(dynamic shipmentStatus) {
    if (shipmentStatus is Map) {
      final map = Map<String, dynamic>.from(shipmentStatus);
      final code = map['code']?.toString().trim();
      return code == null || code.isEmpty ? null : code;
    }
    return null;
  }

  static String? _shipmentStatusDescriptionFrom(dynamic shipmentStatus) {
    if (shipmentStatus is Map) {
      final map = Map<String, dynamic>.from(shipmentStatus);
      final description = map['description']?.toString().trim();
      return description == null || description.isEmpty ? null : description;
    }
    return null;
  }

  static String _serviceModeNameFrom(dynamic serviceMode) {
    if (serviceMode == null) return 'COURIER';
    if (serviceMode is Map) {
      final map = Map<String, dynamic>.from(serviceMode);
      return map['description']?.toString() ??
          map['code']?.toString() ??
          'COURIER';
    }
    return serviceMode.toString();
  }

  factory ShipmentInvoiceModel.fromMap(Map<String, dynamic> map) {
    final netFee = (map['netFee'] as num?)?.toDouble() ?? 0.0;
    return ShipmentInvoiceModel(
      awb: map['awb']?.toString() ?? '',
      senderName: map['senderName']?.toString() ?? '',
      senderMobile: map['senderMobile']?.toString() ?? '',
      senderbranchName: _branchNameFrom(map, 'senderBranch'),
      senderBranchId: _branchIdFrom(map, 'senderBranch'),
      receiverName: map['receiverName']?.toString() ?? '',
      receiverMobile: map['receiverMobile']?.toString() ?? '',
      receiverBranchName: _branchNameFrom(map, 'receiverBranch'),
      receiverBranchId: _branchIdFrom(map, 'receiverBranch'),
      paymentMethodName: _paymentMethodNameFrom(map['paymentMethod']),
      paymentModeName: _paymentModeNameFrom(map['paymentMode']),
      shipmentDate: map['createdAt']?.toString() ?? '',
      invoiceDate: map['updatedAt']?.toString() ?? '',
      shipmentDescription: map['shipmentDescription']?.toString() ?? '',
      netFee: netFee,
      qty: (map['qty'] as num?)?.toInt() ?? 1,
      unit: map['unit']?.toString() ?? 'kg',
      numPcs: (map['numPcs'] as num?)?.toInt() ?? 0,
      serviceModeName: _serviceModeNameFrom(map['serviceMode']),
      totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? netFee,
      vatAmount: (map['vatAmount'] as num?)?.toDouble() ?? 0.0,
      vatRate: (map['vatRate'] as num?)?.toDouble() ??
          (map['vatConfig'] is Map
              ? ((map['vatConfig'] as Map)['vatRate'] as num?)?.toDouble()
              : null) ??
          0.0,
      shipmentStatusCode: _shipmentStatusCodeFrom(map['shipmentStatus']),
      shipmentStatusDescription:
          _shipmentStatusDescriptionFrom(map['shipmentStatus']),
      paymentStatus: map['paymentStatus']?.toString().trim().isNotEmpty == true
          ? map['paymentStatus'].toString().trim()
          : null,
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
