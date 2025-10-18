// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Permission {
  final int? id;
  final String? name;
  final String? description;

  Permission({
    this.id,
    this.name,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory Permission.fromMap(Map<String, dynamic> map) {
    return Permission(
      id: map['id'] as int?,
      name: map['name'] as String?,
      description: map['description'] as String?,
    );
  } 

  String toJson() => json.encode(toMap());

  factory Permission.fromJson(String source) =>
      Permission.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Permission(id: $id, name: $name, description: $description)';

  @override
  bool operator ==(covariant Permission other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ description.hashCode;
}

class Permissions {
  final int? roleId;
  final String? roleName;
  final String? roleDescription;
  final List<Permission>? permissions;

  Permissions({
    this.roleId,
    this.roleName,
    this.roleDescription,
    this.permissions,
  });

  Permissions copyWith({
    int? roleId,
    String? roleName,
    String? roleDescription,
    List<Permission>? permissions,
  }) {
    return Permissions(
      roleId: roleId ?? this.roleId,
      roleName: roleName ?? this.roleName,
      roleDescription: roleDescription ?? this.roleDescription,
      permissions: permissions ?? this.permissions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'roleId': roleId,
      'roleName': roleName,
      'roleDescription': roleDescription,
      'permissions': permissions?.map((x) => x.toMap()).toList(),
    };
  }

  factory Permissions.fromMap(Map<String, dynamic> map) {
    return Permissions(
      roleId: map['roleId'] as int?,
      roleName: map['roleName'] as String?,
      roleDescription: map['roleDescription'] as String?,
      permissions: map['permissions'] != null
          ? List<Permission>.from(
              (map['permissions'] as List).map((x) => Permission.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Permissions.fromJson(String source) =>
      Permissions.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Permissions(roleId: $roleId, roleName: $roleName, roleDescription: $roleDescription, permissions: $permissions)';
  }

  @override
  bool operator ==(covariant Permissions other) {
    if (identical(this, other)) return true;

    return other.roleId == roleId &&
        other.roleName == roleName &&
        other.roleDescription == roleDescription &&
        listEquals(other.permissions, permissions);
  }

  @override
  int get hashCode {
    return roleId.hashCode ^
        roleName.hashCode ^
        roleDescription.hashCode ^
        permissions.hashCode;
  }
}
