// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

class AgentModel {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String branchName;
  final String branchCode;
  final int branchId;
  final String status;
  final String agentCode;
  final String createdAt;
  final double commisionRate;
  AgentModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.branchName,
    required this.branchCode,
    required this.branchId,
    required this.status,
    required this.agentCode,
    required this.createdAt,
    required this.commisionRate,
  });

  AgentModel copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? branchName,
    String? branchCode,
    int? branchId,
    String? status,
    String? agentCode,
    String? createdAt,
    double? commisionRate,
  }) {
    return AgentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      branchName: branchName ?? this.branchName,
      branchCode: branchCode ?? this.branchCode,
      branchId: branchId ?? this.branchId,
      status: status ?? this.status,
      agentCode: agentCode ?? this.agentCode,
      createdAt: createdAt ?? this.createdAt,
      commisionRate: commisionRate ?? this.commisionRate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'branchName': branchName,
      'branchCode': branchCode,
      'branchId': branchId,
      'status': status,
      'agentCode': agentCode,
      'createdAt': createdAt,
      'commisionRate': commisionRate,
    };
  }

  factory AgentModel.fromMap(Map<String, dynamic> map) {
    return AgentModel(
      id: map['id'] as int? ?? 0,
      name: map['name'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      email: map['email'] as String? ?? '',
      branchName: map['branch']['name'] as String? ?? '',
      branchCode: map['branch']['code'] as String? ?? '',
      branchId: map['branch']['id'] as int? ?? 0,
      status: map['status'] as String? ?? '',
      agentCode: map['agentCode'] as String? ?? '',
      createdAt: map['createdAt'] as String? ?? '',
      commisionRate: map['commissionRate'] as double? ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AgentModel.fromJson(String source) =>
      AgentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AgentModel(id: $id, name: $name, phone: $phone, email: $email, branchName: $branchName, branchCode: $branchCode, branchId: $branchId, status: $status, agentCode: $agentCode, createdAt: $createdAt, commisionRate: $commisionRate)';
  }

  @override
  bool operator ==(covariant AgentModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.phone == phone &&
        other.email == email &&
        other.branchName == branchName &&
        other.branchCode == branchCode &&
        other.branchId == branchId &&
        other.status == status &&
        other.agentCode == agentCode &&
        other.createdAt == createdAt &&
        other.commisionRate == commisionRate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        branchName.hashCode ^
        branchCode.hashCode ^
        branchId.hashCode ^
        status.hashCode ^
        agentCode.hashCode ^
        createdAt.hashCode ^
        commisionRate.hashCode;
  }
}
