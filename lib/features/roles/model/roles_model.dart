// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RolesModel {
  final int id;
  final String role;
  final String description;
  final String createdAt;
  RolesModel({
    required this.id,
    required this.role,
    required this.description,
    required this.createdAt,
  });

  RolesModel copyWith({
    int? id,
    String? role,
    String? description,
    String? createdAt,
  }) {
    return RolesModel(
      id: id ?? this.id,
      role: role ?? this.role,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'role': role,
      'description': description,
      'createdAt': createdAt,
    };
  }

  factory RolesModel.fromMap(Map<String, dynamic> map) {
    return RolesModel(
      id: map['id'] as int,
      role: map['role'] as String,
      description: map['description'] as String,
      createdAt: map['createdAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RolesModel.fromJson(String source) => RolesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RolesModel(id: $id, role: $role, description: $description, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant RolesModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.role == role &&
      other.description == description &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      role.hashCode ^
      description.hashCode ^
      createdAt.hashCode;
  }
}
