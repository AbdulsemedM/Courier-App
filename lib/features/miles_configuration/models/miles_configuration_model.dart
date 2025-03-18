// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MilesConfigurationModel {
  final int id;
  final String originBranchName;
  final String destinationBranchName;
  final String unit;
  final double milesPerUnit;
  MilesConfigurationModel({
    required this.id,
    required this.originBranchName,
    required this.destinationBranchName,
    required this.unit,
    required this.milesPerUnit,
  });

  MilesConfigurationModel copyWith({
    int? id,
    String? originBranchName,
    String? destinationBranchName,
    String? unit,
    double? milesPerUnit,
  }) {
    return MilesConfigurationModel(
      id: id ?? this.id,
      originBranchName: originBranchName ?? this.originBranchName,
      destinationBranchName:
          destinationBranchName ?? this.destinationBranchName,
      unit: unit ?? this.unit,
      milesPerUnit: milesPerUnit ?? this.milesPerUnit,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'originBranchName': originBranchName,
      'destinationBranchName': destinationBranchName,
      'unit': unit,
      'milesPerUnit': milesPerUnit,
    };
  }

  factory MilesConfigurationModel.fromMap(Map<String, dynamic> map) {
    return MilesConfigurationModel(
      id: map['id'] as int,
      originBranchName: map['originBranch']['name'] as String,
      destinationBranchName: map['destinationBranch']['name'] as String,
      unit: map['unit'] as String,
      milesPerUnit: map['milesPerUnit'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory MilesConfigurationModel.fromJson(String source) =>
      MilesConfigurationModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MilesConfigurationModel(id: $id, originBranchName: $originBranchName, destinationBranchName: $destinationBranchName, unit: $unit, milesPerUnit: $milesPerUnit)';
  }

  @override
  bool operator ==(covariant MilesConfigurationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.originBranchName == originBranchName &&
        other.destinationBranchName == destinationBranchName &&
        other.unit == unit &&
        other.milesPerUnit == milesPerUnit;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        originBranchName.hashCode ^
        destinationBranchName.hashCode ^
        unit.hashCode ^
        milesPerUnit.hashCode;
  }
}
