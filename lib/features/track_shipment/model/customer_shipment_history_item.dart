class CustomerShipmentHistoryItem {
  final String awb;
  final String? awbDate;
  final String? senderName;
  final String? senderPhone;
  final String? receiverName;
  final String? receiverPhone;
  final String? origin;
  final String? destination;
  final double? kg;
  final String? unit;
  final String? currentStatus;
  final String? statusDescription;
  final String? description;
  final String? shipmentDescription;
  final String? mark;

  const CustomerShipmentHistoryItem({
    required this.awb,
    this.awbDate,
    this.senderName,
    this.senderPhone,
    this.receiverName,
    this.receiverPhone,
    this.origin,
    this.destination,
    this.kg,
    this.unit,
    this.currentStatus,
    this.statusDescription,
    this.description,
    this.shipmentDescription,
    this.mark,
  });

  factory CustomerShipmentHistoryItem.fromMap(Map<String, dynamic> map) {
    return CustomerShipmentHistoryItem(
      awb: map['awb']?.toString().trim() ?? '',
      awbDate: _string(map['awbDate']),
      senderName: _string(map['senderName']),
      senderPhone: _string(map['senderPhone']),
      receiverName: _string(map['receiverName']),
      receiverPhone: _string(map['receiverPhone']),
      origin: _string(map['origin']),
      destination: _string(map['destination']),
      kg: _double(map['kg']),
      unit: _string(map['unit']),
      currentStatus: _string(map['currentStatus']),
      statusDescription: _string(map['statusDescription']),
      description: _string(map['description']),
      shipmentDescription: _string(map['shipmentDescription']),
      mark: _string(map['mark']),
    );
  }

  String get statusLabel {
    final label = statusDescription?.trim();
    if (label != null && label.isNotEmpty) return label;
    return currentStatus?.trim() ?? '';
  }
}

String? _string(dynamic value) {
  final text = value?.toString().trim();
  if (text == null || text.isEmpty) return null;
  return text;
}

double? _double(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}
