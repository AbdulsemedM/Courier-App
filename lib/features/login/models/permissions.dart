// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Permissions {
  final String? roleName;
  final List<String>? permissions;
  Permissions({
    this.roleName,
    this.permissions,
  });

  Permissions copyWith({
    String? roleName,
    List<String>? permissions,
  }) {
    return Permissions(
      roleName: roleName ?? this.roleName,
      permissions: permissions ?? this.permissions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'roleName': roleName,
      'permissions': permissions,
    };
  }

  factory Permissions.fromMap(Map<String, dynamic> map) {
    return Permissions(
      roleName: map['roleName'] != null ? map['roleName'] as String : null,
      permissions: map['permissions'] != null
          ? List<String>.from((map['permissions']['name'] as List<String>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Permissions.fromJson(String source) =>
      Permissions.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Permissions(roleName: $roleName, permissions: $permissions)';

  @override
  bool operator ==(covariant Permissions other) {
    if (identical(this, other)) return true;

    return other.roleName == roleName &&
        listEquals(other.permissions, permissions);
  }

  @override
  int get hashCode => roleName.hashCode ^ permissions.hashCode;
}

