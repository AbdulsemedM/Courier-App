class MessengerModel {
  final int id;
  final String name;
  final String phone;
  final String? licenseNumber;
  final String? vehicleType;
  final String? vehicleNumber;
  final String status;
  final int branchId;
  final String branchName;
  final int? assignedUserId;

  const MessengerModel({
    required this.id,
    required this.name,
    required this.phone,
    this.licenseNumber,
    this.vehicleType,
    this.vehicleNumber,
    required this.status,
    required this.branchId,
    required this.branchName,
    this.assignedUserId,
  });

  factory MessengerModel.fromJson(Map<String, dynamic> json) {
    return MessengerModel(
      id: _toInt(json['id']) ?? 0,
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      licenseNumber: json['licenseNumber']?.toString(),
      vehicleType: json['vehicleType']?.toString(),
      vehicleNumber: json['vehicleNumber']?.toString(),
      status: json['status']?.toString() ?? 'ACTIVE',
      branchId: _toInt(json['branchId']) ?? 0,
      branchName: json['branchName']?.toString() ?? '',
      assignedUserId: _toInt(json['assignedUserId']),
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  String get displayLabel {
    if (phone.isNotEmpty) return '$name ($phone)';
    return name;
  }
}
