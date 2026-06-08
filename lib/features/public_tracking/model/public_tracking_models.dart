class PublicShipmentSummary {
  final String awb;
  final String? statusLabel;
  final String? statusCode;
  final String? origin;
  final String? destination;
  final String? createdAt;
  final String? shipmentType;

  const PublicShipmentSummary({
    required this.awb,
    this.statusLabel,
    this.statusCode,
    this.origin,
    this.destination,
    this.createdAt,
    this.shipmentType,
  });

  factory PublicShipmentSummary.fromMap(Map<String, dynamic> map) {
    final shipment = _extractShipment(map);
    final status = _extractStatus(map, shipment);

    return PublicShipmentSummary(
      awb: shipment['awb']?.toString() ?? map['awb']?.toString() ?? '',
      statusLabel: status['description']?.toString(),
      statusCode: status['code']?.toString(),
      origin: _branchName(shipment, isSender: true),
      destination: _branchName(shipment, isSender: false),
      createdAt: shipment['createdAt']?.toString() ?? map['createdAt']?.toString(),
      shipmentType: _nestedDescription(shipment['shipmentType']),
    );
  }
}

class PublicTrackingTimelineItem {
  final String awb;
  final String description;
  final String? statusLabel;
  final String? statusCode;
  final String? createdAt;
  final String? origin;
  final String? destination;
  final String? shipmentType;
  final String? deliveryType;
  final String? transportMode;

  const PublicTrackingTimelineItem({
    required this.awb,
    required this.description,
    this.statusLabel,
    this.statusCode,
    this.createdAt,
    this.origin,
    this.destination,
    this.shipmentType,
    this.deliveryType,
    this.transportMode,
  });

  factory PublicTrackingTimelineItem.fromMap(Map<String, dynamic> map) {
    final shipment = _extractShipment(map);
    final status = _extractStatus(map, shipment);

    var description = map['description']?.toString() ?? '';
    if (description.isEmpty) {
      description = status['description']?.toString() ?? 'Status update';
    }

    return PublicTrackingTimelineItem(
      awb: shipment['awb']?.toString() ?? map['awb']?.toString() ?? '',
      description: description,
      statusLabel: status['description']?.toString(),
      statusCode: status['code']?.toString(),
      createdAt: map['createdAt']?.toString() ?? shipment['createdAt']?.toString(),
      origin: _branchName(shipment, isSender: true),
      destination: _branchName(shipment, isSender: false),
      shipmentType: _nestedDescription(shipment['shipmentType']),
      deliveryType: _nestedDescription(shipment['deliveryType']),
      transportMode: _nestedDescription(shipment['transportMode']),
    );
  }
}

enum PublicTrackingResultType { single, multiple }

class PublicTrackingResult {
  final PublicTrackingResultType type;
  final List<PublicTrackingTimelineItem> events;
  final List<PublicShipmentSummary> summaries;

  const PublicTrackingResult._({
    required this.type,
    this.events = const [],
    this.summaries = const [],
  });

  factory PublicTrackingResult.single(List<PublicTrackingTimelineItem> events) {
    return PublicTrackingResult._(
      type: PublicTrackingResultType.single,
      events: events,
    );
  }

  factory PublicTrackingResult.multiple(List<PublicShipmentSummary> summaries) {
    return PublicTrackingResult._(
      type: PublicTrackingResultType.multiple,
      summaries: summaries,
    );
  }

  PublicTrackingTimelineItem? get primaryEvent =>
      events.isNotEmpty ? events.first : null;
}

Map<String, dynamic> _extractShipment(Map<String, dynamic> map) {
  final shipmentData = map['shipment'];
  if (shipmentData is Map<String, dynamic>) {
    return shipmentData;
  }
  return map;
}

Map<String, dynamic> _extractStatus(
  Map<String, dynamic> map,
  Map<String, dynamic> shipment,
) {
  final status = map['status'];
  if (status is Map<String, dynamic>) return status;

  final shipmentStatus = shipment['shipmentStatus'];
  if (shipmentStatus is Map<String, dynamic>) return shipmentStatus;

  return {};
}

String? _branchName(Map<String, dynamic> shipment, {required bool isSender}) {
  final key = isSender ? 'senderBranch' : 'receiverBranch';
  final branch = shipment[key];
  if (branch is Map<String, dynamic>) {
    return branch['name']?.toString();
  }

  if (isSender) {
    return shipment['originBranchName']?.toString() ??
        (shipment['originBranch'] is Map<String, dynamic>
            ? (shipment['originBranch'] as Map)['name']?.toString()
            : null);
  }

  return shipment['destinationBranchName']?.toString() ??
      shipment['destination']?.toString() ??
      (shipment['destinationBranch'] is Map<String, dynamic>
          ? (shipment['destinationBranch'] as Map)['name']?.toString()
          : null);
}

String? _nestedDescription(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value['description']?.toString() ??
        value['type']?.toString() ??
        value['mode']?.toString();
  }
  return value?.toString();
}

String buildFullPhone(String countryCode, String local) {
  final dial = countryCode.replaceAll(RegExp(r'[^\d]'), '');
  final digits = local.replaceAll(RegExp(r'[^\d]'), '');
  return '$dial$digits';
}
