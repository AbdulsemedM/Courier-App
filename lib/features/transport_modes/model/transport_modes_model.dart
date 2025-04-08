// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TransportModesModel {
  final int id;
  final String mode;
  final String description;
  final String? createdAt;
  TransportModesModel({
    required this.id,
    required this.mode,
    required this.description,
    this.createdAt,
  });

  TransportModesModel copyWith({
    int? id,
    String? mode,
    String? description,
    String? createdAt,
  }) {
    return TransportModesModel(
      id: id ?? this.id,
      mode: mode ?? this.mode,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'mode': mode,
      'description': description,
      'createdAt': createdAt,
    };
  }

  factory TransportModesModel.fromMap(Map<String, dynamic> map) {
    return TransportModesModel(
      id: map['id'] as int? ?? 0,
      mode: map['mode'] as String? ?? '',
      description: map['description'] as String? ?? '',
      createdAt: map['createdAt']?.toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory TransportModesModel.fromJson(String source) =>
      TransportModesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TransportModesModel(id: $id, mode: $mode, description: $description, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant TransportModesModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.mode == mode &&
        other.description == description &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        mode.hashCode ^
        description.hashCode ^
        createdAt.hashCode;
  }
}
