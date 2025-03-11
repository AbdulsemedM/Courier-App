import 'payment_method_model.dart';

class DeliveryTypeModel {
  final int? id;
  final String? type;
  final String? description;
  final UserModel? addedBy;
  final String? createdAt;
  final String? updatedAt;

  DeliveryTypeModel({
    this.id,
    this.type,
    this.description,
    this.addedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory DeliveryTypeModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return DeliveryTypeModel();

    return DeliveryTypeModel(
      id: json['id'] as int?,
      type: json['type'] as String?,
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
      'type': type,
      'description': description,
      'addedBy': addedBy?.toJson(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  String toString() => type ?? description ?? '';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DeliveryTypeModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  bool get isBranchToBranch =>
      type?.toUpperCase() == 'BRANCH TO BRANCH' ||
      description?.toUpperCase().contains('BRANCH TO BRANCH') == true;

  bool get isDoorToDoor =>
      type?.toUpperCase() == 'DOOR TO DOOR' ||
      description?.toUpperCase().contains('DOOR TO DOOR') == true;
}
