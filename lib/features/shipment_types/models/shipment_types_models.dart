// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ShipmentTypesModels {
  final int id;
  final String type;
  final String description;
  final String createdAt;
  ShipmentTypesModels({
    required this.id,
    required this.type,
    required this.description,
    required this.createdAt,
  });

  ShipmentTypesModels copyWith({
    int? id,
    String? type,
    String? description,
    String? createdAt,
  }) {
    return ShipmentTypesModels(
      id: id ?? this.id,
      type: type ?? this.type,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'description': description,
      'createdAt': createdAt,
    };
  }

  factory ShipmentTypesModels.fromMap(Map<String, dynamic> map) {
    return ShipmentTypesModels(
      id: map['id'] as int,
      type: map['type'] as String,
      description: map['description'] as String,
      createdAt: map['createdAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShipmentTypesModels.fromJson(String source) =>
      ShipmentTypesModels.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ShipmentTypesModels(id: $id, type: $type, description: $description, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant ShipmentTypesModels other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.type == type &&
        other.description == description &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        type.hashCode ^
        description.hashCode ^
        createdAt.hashCode;
  }
}
