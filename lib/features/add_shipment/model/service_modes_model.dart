class ServiceModeModel {
  final int? id;
  final String? code;
  final String? description;
  final String? addedBy;
  final String? createdAt;
  final String? updatedAt;

  ServiceModeModel({
    this.id,
    this.code,
    this.description,
    this.addedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory ServiceModeModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ServiceModeModel();

    return ServiceModeModel(
      id: json['id'] as int?,
      code: json['code'] as String?,
      description: json['description'] as String?,
      addedBy: json['addedBy'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'description': description,
      'addedBy': addedBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  String toString() {
    return description ?? code ?? '';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServiceModeModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
