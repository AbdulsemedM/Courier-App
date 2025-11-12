// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TellerAccountModel {
  final int id;
  final String accountNumber;
  final String accountType;
  final double runningBalance;
  final double expenseBalance;
  final int branchId;
  final String branchName;
  final String branchCode;
  final int tellerId;
  final String tellerName;
  final String tellerStatus;
  final String entityType;
  final String? addedByName;
  final String? addedByEmail;
  final String createdAt;
  final String? updatedAt;

  TellerAccountModel({
    required this.id,
    required this.accountNumber,
    required this.accountType,
    required this.runningBalance,
    required this.expenseBalance,
    required this.branchId,
    required this.branchName,
    required this.branchCode,
    required this.tellerId,
    required this.tellerName,
    required this.tellerStatus,
    required this.entityType,
    this.addedByName,
    this.addedByEmail,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'accountNumber': accountNumber,
      'accountType': accountType,
      'runningBalance': runningBalance,
      'expenseBalance': expenseBalance,
      'branchId': branchId,
      'branchName': branchName,
      'branchCode': branchCode,
      'tellerId': tellerId,
      'tellerName': tellerName,
      'tellerStatus': tellerStatus,
      'entityType': entityType,
      'addedByName': addedByName,
      'addedByEmail': addedByEmail,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory TellerAccountModel.fromMap(Map<String, dynamic> map) {
    return TellerAccountModel(
      id: map['id'] as int,
      accountNumber: map['accountNumber'] as String,
      accountType: map['accountType'] as String,
      runningBalance: (map['runningBalance'] as num?)?.toDouble() ?? 0.0,
      expenseBalance: (map['expenseBalance'] as num?)?.toDouble() ?? 0.0,
      branchId: map['branchId'] as int,
      branchName: map['branchName'] as String,
      branchCode: map['branchCode'] as String,
      tellerId: map['tellerId'] as int,
      tellerName: map['tellerName'] as String,
      tellerStatus: map['tellerStatus'] as String,
      entityType: map['entityType'] as String,
      addedByName: map['addedByName'] as String?,
      addedByEmail: map['addedByEmail'] as String?,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory TellerAccountModel.fromJson(String source) =>
      TellerAccountModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

