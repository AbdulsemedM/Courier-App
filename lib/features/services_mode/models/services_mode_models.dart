// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ServicesModeModels {
  final int id;
  final String code;
  final String description;
  final String createdAt;
  ServicesModeModels({
    required this.id,
    required this.code,
    required this.description,
    required this.createdAt,
  });

  ServicesModeModels copyWith({
    int? id,
    String? code,
    String? description,
    String? createdAt,
  }) {
    return ServicesModeModels(
      id: id ?? this.id,
      code: code ?? this.code,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'description': description,
      'createdAt': createdAt,
    };
  }

  factory ServicesModeModels.fromMap(Map<String, dynamic> map) {
    return ServicesModeModels(
      id: map['id'] as int,
      code: map['code'] as String,
      description: map['description'] as String,
      createdAt: map['createdAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ServicesModeModels.fromJson(String source) =>
      ServicesModeModels.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ServicesModeModels(id: $id, code: $code, description: $description, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant ServicesModeModels other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.code == code &&
        other.description == description &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        code.hashCode ^
        description.hashCode ^
        createdAt.hashCode;
  }
}
