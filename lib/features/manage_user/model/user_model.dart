// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final int id;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;
  final String? branchName;
  final String? branchCode;
  final String? role;
  final String? createdAt;
  UserModel({
    required this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.branchName,
    this.branchCode,
    this.role,
    this.createdAt,
  });

  UserModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? branchName,
    String? branchCode,
    String? role,
    String? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      email: email,
      branchName: branchName,
      branchCode: branchCode,
      role: role,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      'branchName': branchName,
      'branchCode': branchCode,
      'role': role,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int? ?? 0,
      firstName: map['firstName'] as String? ?? null,
      lastName: map['lastName'] as String? ?? null,
      phone: map['phone'] as String? ?? null,
      email: map['email'] as String? ?? null,
      branchName: map['branch']?['name'] as String? ?? null,
      branchCode: map['branch']?['code'] as String? ?? null,
      role: map['role']?['role'] as String? ?? null,
      createdAt: map['createdAt'] as String? ?? null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, firstName: $firstName, lastName: $lastName, phone: $phone, email: $email, branchName: $branchName, branchCode: $branchCode, role: $role, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.phone == phone &&
        other.email == email &&
        other.branchName == branchName &&
        other.branchCode == branchCode &&
        other.role == role &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        branchName.hashCode ^
        branchCode.hashCode ^
        role.hashCode ^
        createdAt.hashCode;
  }
}
