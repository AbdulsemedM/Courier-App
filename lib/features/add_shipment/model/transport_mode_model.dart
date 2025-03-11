import 'payment_method_model.dart';

class TransportModeModel {
  final int? id;
  final String? mode;
  final String? description;
  final UserModel? addedBy;
  final String? createdAt;
  final String? updatedAt;

  TransportModeModel({
    this.id,
    this.mode,
    this.description,
    this.addedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory TransportModeModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return TransportModeModel();

    return TransportModeModel(
      id: json['id'] as int?,
      mode: json['mode'] as String?,
      description: json['description'] as String?,
      addedBy: json['addedBy'] != null
          ? UserModel.fromJson(json['addedBy'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mode': mode,
      'description': description,
      'addedBy': addedBy?.toJson(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  String toString() => mode ?? description ?? '';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TransportModeModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
