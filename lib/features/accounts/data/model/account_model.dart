// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AccountModel {
  final int id;
  final String accountNumber;
  final String accountType;
  final double runningBalance;
  final double expenseBalance;
  final int? branchId;
  final String? branchName;
  final String? branchCode;
  final int? tellerId;
  final String? tellerName;
  final String? tellerStatus;
  final String addedByName;
  final String addedByEmail;
  final String createdAt;
  final String? updatedAt;

  AccountModel({
    required this.id,
    required this.accountNumber,
    required this.accountType,
    required this.runningBalance,
    required this.expenseBalance,
    this.branchId,
    this.branchName,
    this.branchCode,
    this.tellerId,
    this.tellerName,
    this.tellerStatus,
    required this.addedByName,
    required this.addedByEmail,
    required this.createdAt,
    this.updatedAt,
  });

  AccountModel copyWith({
    int? id,
    String? accountNumber,
    String? accountType,
    double? runningBalance,
    double? expenseBalance,
    int? branchId,
    String? branchName,
    String? branchCode,
    int? tellerId,
    String? tellerName,
    String? tellerStatus,
    String? addedByName,
    String? addedByEmail,
    String? createdAt,
    String? updatedAt,
  }) {
    return AccountModel(
      id: id ?? this.id,
      accountNumber: accountNumber ?? this.accountNumber,
      accountType: accountType ?? this.accountType,
      runningBalance: runningBalance ?? this.runningBalance,
      expenseBalance: expenseBalance ?? this.expenseBalance,
      branchId: branchId ?? this.branchId,
      branchName: branchName ?? this.branchName,
      branchCode: branchCode ?? this.branchCode,
      tellerId: tellerId ?? this.tellerId,
      tellerName: tellerName ?? this.tellerName,
      tellerStatus: tellerStatus ?? this.tellerStatus,
      addedByName: addedByName ?? this.addedByName,
      addedByEmail: addedByEmail ?? this.addedByEmail,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

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
      'addedByName': addedByName,
      'addedByEmail': addedByEmail,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
      id: map['id'] as int,
      accountNumber: map['accountNumber'] as String,
      accountType: map['accountType'] as String,
      runningBalance: (map['runningBalance'] as num?)?.toDouble() ?? 0.0,
      expenseBalance: (map['expenseBalance'] as num?)?.toDouble() ?? 0.0,
      branchId: map['branchId'] as int?,
      branchName: map['branchName'] as String?,
      branchCode: map['branchCode'] as String?,
      tellerId: map['tellerId'] as int?,
      tellerName: map['tellerName'] as String?,
      tellerStatus: map['tellerStatus'] as String?,
      addedByName: map['addedByName'] as String? ?? '',
      addedByEmail: map['addedByEmail'] as String? ?? '',
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory AccountModel.fromJson(String source) =>
      AccountModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AccountModel(id: $id, accountNumber: $accountNumber, accountType: $accountType, runningBalance: $runningBalance, expenseBalance: $expenseBalance)';
  }

  @override
  bool operator ==(covariant AccountModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.accountNumber == accountNumber &&
        other.accountType == accountType &&
        other.runningBalance == runningBalance &&
        other.expenseBalance == expenseBalance;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        accountNumber.hashCode ^
        accountType.hashCode ^
        runningBalance.hashCode ^
        expenseBalance.hashCode;
  }
}
