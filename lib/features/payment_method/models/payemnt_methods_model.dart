// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PaymentMethodModel {
  final int id;
  final String? method;
  final String? description;
  final String? createdAt;
  PaymentMethodModel({
    required this.id,
    this.method,
    this.description,
    this.createdAt,
  });

  PaymentMethodModel copyWith({
    int? id,
    String? method,
    String? description,
    String? createdAt,
  }) {
    return PaymentMethodModel(
      id: id ?? this.id,
      method: method ?? this.method,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'method': method,
      'description': description,
      'createdAt': createdAt,
    };
  }

  factory PaymentMethodModel.fromMap(Map<String, dynamic> map) {
    return PaymentMethodModel(
      id: map['id'] as int,
      method: map['method'] != null ? map['method'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentMethodModel.fromJson(String source) =>
      PaymentMethodModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PaymentMethodModel(id: $id, method: $method, description: $description, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant PaymentMethodModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.method == method &&
        other.description == description &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        method.hashCode ^
        description.hashCode ^
        createdAt.hashCode;
  }
}
