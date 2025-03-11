import 'package:courier_app/features/add_shipment/model/branch_model.dart';

import 'service_modes_model.dart';

class PaymentMethodModel {
  final int? id;
  final String? method;
  final String? description;
  final UserModel? addedBy;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;

  PaymentMethodModel({
    this.id,
    this.method,
    this.description,
    this.addedBy,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return PaymentMethodModel();

    return PaymentMethodModel(
      id: json['id'] as int?,
      method: json['method'] as String?,
      description: json['description'] as String?,
      addedBy: json['addedBy'] != null
          ? UserModel.fromJson(json['addedBy'] as Map<String, dynamic>)
          : null,
      deletedAt: json['deletedAt'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'method': method,
      'description': description,
      'addedBy': addedBy?.toJson(),
      'deletedAt': deletedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  String toString() => method ?? description ?? '';
}

class UserModel {
  final int? id;
  final String? firstName;
  final String? secondName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? password;
  final bool? isPasswordChanged;
  final BranchModel? branch;
  final int? status;
  final ServiceModeModel? serviceMode;
  final String? createdBy;
  final String? createdAt;
  final String? updatedAt;
  final RoleModel? role;

  UserModel({
    this.id,
    this.firstName,
    this.secondName,
    this.lastName,
    this.email,
    this.phone,
    this.password,
    this.isPasswordChanged,
    this.branch,
    this.status,
    this.serviceMode,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return UserModel();

    return UserModel(
      id: json['id'] as int?,
      firstName: json['firstName'] as String?,
      secondName: json['secondName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      password: json['password'] as String?,
      isPasswordChanged: json['isPasswordChanged'] as bool?,
      branch: json['branch'] != null
          ? BranchModel.fromJson(json['branch'] as Map<String, dynamic>)
          : null,
      status: json['status'] as int?,
      serviceMode: json['serviceMode'] != null
          ? ServiceModeModel.fromJson(
              json['serviceMode'] as Map<String, dynamic>)
          : null,
      createdBy: json['createdBy'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      role: json['role'] != null
          ? RoleModel.fromJson(json['role'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'secondName': secondName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'password': password,
      'isPasswordChanged': isPasswordChanged,
      'branch': branch?.toJson(),
      'status': status,
      'serviceMode': serviceMode?.toJson(),
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'role': role?.toJson(),
    };
  }

  String get fullName => [firstName, secondName, lastName]
      .where((name) => name != null && name.isNotEmpty)
      .join(' ');
}

class RoleModel {
  final int? id;
  final String? role;
  final String? description;
  final String? addedBy;
  final String? createdAt;
  final String? updatedAt;

  RoleModel({
    this.id,
    this.role,
    this.description,
    this.addedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory RoleModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return RoleModel();

    return RoleModel(
      id: json['id'] as int?,
      role: json['role'] as String?,
      description: json['description'] as String?,
      addedBy: json['addedBy'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'description': description,
      'addedBy': addedBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  String toString() => role ?? '';
}
