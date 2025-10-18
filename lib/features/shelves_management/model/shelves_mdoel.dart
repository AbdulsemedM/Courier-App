// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ShelvesModel {
  final int? id;
  final String? shelfCode;
  final String? binCode;
  final int? branchId;
  final String? branchName;
  final String? description;
  ShelvesModel({
    this.id,
    this.shelfCode,
    this.binCode,
    this.branchId,
    this.branchName,
    this.description,
  });

  ShelvesModel copyWith({
    int? id,
    String? shelfCode,
    String? binCode,
    int? branchId,
    String? branchName,
    String? description,
  }) {
    return ShelvesModel(
      id: id ?? this.id,
      shelfCode: shelfCode ?? this.shelfCode,
      binCode: binCode ?? this.binCode,
      branchId: branchId ?? this.branchId,
      branchName: branchName ?? this.branchName,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'shelfCode': shelfCode,
      'binCode': binCode,
      'branchId': branchId,
      'branchName': branchName,
      'description': description,
    };
  }

  factory ShelvesModel.fromMap(Map<String, dynamic> map) {
    return ShelvesModel(
      id: map['id'] != null ? map['id'] as int : null,
      shelfCode: map['shelfCode'] != null ? map['shelfCode'] as String : null,
      binCode: map['binCode'] != null ? map['binCode'] as String : null,
      branchId: map['branch']['id'] != null ? map['branch']['id'] as int : null,
      branchName: map['branch']['name'] != null
          ? map['branch']['name'] as String
          : null,
      description:
          map['description'] != null ? map['description'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShelvesModel.fromJson(String source) =>
      ShelvesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ShelvesModel(id: $id, shelfCode: $shelfCode, binCode: $binCode, branchId: $branchId, branchName: $branchName, description: $description)';
  }

  @override
  bool operator ==(covariant ShelvesModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.shelfCode == shelfCode &&
        other.binCode == binCode &&
        other.branchId == branchId &&
        other.branchName == branchName &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        shelfCode.hashCode ^
        binCode.hashCode ^
        branchId.hashCode ^
        branchName.hashCode ^
        description.hashCode;
  }
}
