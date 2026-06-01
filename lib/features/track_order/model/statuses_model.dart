class StatusModel {
  final int id;
  final String code;
  final String description;
  final int addedBy;
  final String createdAt;
  final String? updatedAt;
  final String? name;

  StatusModel({
    required this.id,
    required this.code,
    required this.description,
    required this.addedBy,
    required this.createdAt,
    this.updatedAt,
    this.name,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      id: _toInt(json['id']) ?? 0,
      code: json['code']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      addedBy: _toInt(json['addedBy']) ?? 0,
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString(),
      name: json['name']?.toString(),
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'description': description,
      'addedBy': addedBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'StatusModel(id: $id, code: $code, description: $description, name: $name)';
  }

  StatusModel copyWith({
    int? id,
    String? code,
    String? description,
    int? addedBy,
    String? createdAt,
    String? updatedAt,
    String? name,
  }) {
    return StatusModel(
      id: id ?? this.id,
      code: code ?? this.code,
      description: description ?? this.description,
      addedBy: addedBy ?? this.addedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
    );
  }
}
