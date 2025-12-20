// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PermissionModel {
  final int id;
  final String name;
  final String? description;
  final String? createdAt;
  final String? updatedAt;

  PermissionModel({
    required this.id,
    required this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  PermissionModel copyWith({
    int? id,
    String? name,
    String? description,
    String? createdAt,
    String? updatedAt,
  }) {
    return PermissionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory PermissionModel.fromMap(Map<String, dynamic> map) {
    return PermissionModel(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String?,
      createdAt: map['createdAt'] as String?,
      updatedAt: map['updatedAt'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory PermissionModel.fromJson(String source) =>
      PermissionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PermissionModel(id: $id, name: $name, description: $description, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant PermissionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.description == description &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}

class RolePermissionsModel {
  final String roleName;
  final List<PermissionModel> permissions;

  RolePermissionsModel({
    required this.roleName,
    required this.permissions,
  });

  factory RolePermissionsModel.fromMap(Map<String, dynamic> map) {
    return RolePermissionsModel(
      roleName: map['roleName'] as String,
      permissions: (map['permissions'] as List)
          .map((p) => PermissionModel.fromMap(p as Map<String, dynamic>))
          .toList(),
    );
  }
}

