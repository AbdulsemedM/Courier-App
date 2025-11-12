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
    // Handle branch as either object or int
    String branchName = 'N/A';
    String branchCode = 'N/A';
    if (map['branch'] is Map) {
      branchName = map['branch']['name'] as String? ?? 'N/A';
      branchCode = map['branch']['code'] as String? ?? 'N/A';
    } else if (map['branch'] is int) {
      branchName = 'Branch ${map['branch']}';
      branchCode = '';
    }

    // Handle addedBy as either object or int
    String addedBy = 'N/A';
    if (map['addedBy'] is Map) {
      addedBy = map['addedBy']['email'] as String? ??
          '${map['addedBy']['firstName'] ?? ''} ${map['addedBy']['lastName'] ?? ''}'
              .trim();
      if (addedBy.isEmpty) {
        addedBy = 'User ${map['addedBy']['id'] ?? 'N/A'}';
      }
    } else if (map['addedBy'] is int) {
      addedBy = 'User ${map['addedBy']}';
    }

    return TellerModel(
      id: map['id'] as int,
      tellerName: map['tellerName'] as String,
      branchName: branchName,
      branchCode: branchCode,
      status: map['status'] as String? ?? 'UNKNOWN',
      addedBy: addedBy,
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
