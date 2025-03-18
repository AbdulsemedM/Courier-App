// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

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
  TrackShipmentModel(
      {required this.awb,
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
      required this.createdAt});

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
    };
  }

  factory TrackShipmentModel.fromMap(Map<String, dynamic> map) {
    return TrackShipmentModel(
      awb: map['shipment']?['awb'] as String? ?? '',
      senderName: map['shipment']?['senderName'] as String? ?? '',
      senderMobile: map['shipment']?['senderMobile'] as String? ?? '',
      receiverName: map['shipment']?['receiverName'] as String? ?? '',
      receiverMobile: map['shipment']?['receiverMobile'] as String? ?? '',
      name: map['shipment']?['receiverBranch']?['name'] as String? ?? '',
      netFee: (map['shipment']?['netFee'] ?? '').toString(),
      shipmentDescription:
          map['shipment']?['shipmentDescription'] as String? ?? '',
      method: map['shipment']?['paymentMethod']?['method'] as String? ?? '',
      updatedBy: map['shipment']?['addedBy']?['firstName'] as String? ?? '',
      description: map['description'] as String? ?? "",
      createdAt: map['createdAt'] as String? ?? "",
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
        other.description == description;
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
        description.hashCode;
  }
}
