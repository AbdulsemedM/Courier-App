// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

class CustomerModel {
  final int id;
  final String fullname;
  final String phone;
  final String email;
  final String branchName;
  final String branchCode;
  final int branchId;
  final String status;
  final String company;
  final String createdAt;
  CustomerModel({
    required this.id,
    required this.fullname,
    required this.phone,
    required this.email,
    required this.branchName,
    required this.branchCode,
    required this.branchId,
    required this.status,
    required this.company,
    required this.createdAt,
  });

  CustomerModel copyWith({
    int? id,
    String? fullname,
    String? phone,
    String? email,
    String? branchName,
    String? branchCode,
    int? branchId,
    String? status,
    String? company,
    String? createdAt,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      branchName: branchName ?? this.branchName,
      branchCode: branchCode ?? this.branchCode,
      branchId: branchId ?? this.branchId,
      status: status ?? this.status,
      company: company ?? this.company,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullname': fullname,
      'phone': phone,
      'email': email,
      'branchName': branchName,
      'branchCode': branchCode,
      'branchId': branchId,
      'status': status,
      'company': company,
      'createdAt': createdAt,
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'] as int? ?? 0,
      fullname: map['fullname'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      email: map['email'] as String? ?? '',
      branchName: map['branch']['name'] as String? ?? '',
      branchCode: map['branch']['code'] as String? ?? '',
      branchId: map['branch']['id'] as int? ?? 0,
      status: map['status'] as String? ?? '',
      company: map['company'] as String? ?? '',
      createdAt: map['createdAt'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerModel.fromJson(String source) =>
      CustomerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CustomerModel(id: $id, fullname: $fullname, phone: $phone, email: $email, branchName: $branchName, branchCode: $branchCode, branchId: $branchId, status: $status, company: $company, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant CustomerModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.fullname == fullname &&
        other.phone == phone &&
        other.email == email &&
        other.branchName == branchName &&
        other.branchCode == branchCode &&
        other.branchId == branchId &&
        other.status == status &&
        other.company == company &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fullname.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        branchName.hashCode ^
        branchCode.hashCode ^
        branchId.hashCode ^
        status.hashCode ^
        company.hashCode ^
        createdAt.hashCode;
  }
}
