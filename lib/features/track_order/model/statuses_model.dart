class StatusModel {
  final int id;
  final String code;
  final String description;
  final int addedBy;
  final String createdAt;
  final String? updatedAt;

  StatusModel({
    required this.id,
    required this.code,
    required this.description,
    required this.addedBy,
    required this.createdAt,
    this.updatedAt,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      description: json['description'] ?? '',
      addedBy: json['addedBy'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'],
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
    return 'StatusModel(id: $id, code: $code, description: $description, addedBy: $addedBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  StatusModel copyWith({
    int? id,
    String? code,
    String? description,
    int? addedBy,
    String? createdAt,
    String? updatedAt,
  }) {
    return StatusModel(
      id: id ?? this.id,
      code: code ?? this.code,
      description: description ?? this.description,
      addedBy: addedBy ?? this.addedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
