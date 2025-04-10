// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TellerModel {
  final int id;
  final String tellerName;
  final String branchName;
  final String branchCode;
  final String status;
  final String addedBy;
  final String createdAt;
  TellerModel({
    required this.id,
    required this.tellerName,
    required this.branchName,
    required this.branchCode,
    required this.status,
    required this.addedBy,
    required this.createdAt,
  });

  TellerModel copyWith({
    int? id,
    String? tellerName,
    String? branchName,
    String? branchCode,
    String? status,
    String? addedBy,
    String? createdAt,
  }) {
    return TellerModel(
      id: id ?? this.id,
      tellerName: tellerName ?? this.tellerName,
      branchName: branchName ?? this.branchName,
      branchCode: branchCode ?? this.branchCode,
      status: status ?? this.status,
      addedBy: addedBy ?? this.addedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'tellerName': tellerName,
      'branchName': branchName,
      'branchCode': branchCode,
      'status': status,
      'addedBy': addedBy,
      'createdAt': createdAt,
    };
  }

  factory TellerModel.fromMap(Map<String, dynamic> map) {
    return TellerModel(
      id: map['id'] as int,
      tellerName: map['tellerName'] as String,
      branchName: map['branch']['name'] as String,
      branchCode: map['branch']['code'] as String,
      status: map['status'] as String,
      addedBy: map['addedBy']['email'] as String,
      createdAt: map['createdAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TellerModel.fromJson(String source) =>
      TellerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TellerModel(id: $id, tellerName: $tellerName, branchName: $branchName, branchCode: $branchCode, status: $status, addedBy: $addedBy, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant TellerModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.tellerName == tellerName &&
        other.branchName == branchName &&
        other.branchCode == branchCode &&
        other.status == status &&
        other.addedBy == addedBy &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        tellerName.hashCode ^
        branchName.hashCode ^
        branchCode.hashCode ^
        status.hashCode ^
        addedBy.hashCode ^
        createdAt.hashCode;
  }
}
