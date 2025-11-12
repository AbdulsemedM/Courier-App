// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BranchInfo {
  final int id;
  final String name;
  final String code;
  final Currency? currency;
  final Country? country;
  final String? phone;
  final bool? isAgent;
  final double? hudhudPercent;
  final String? createdAt;

  BranchInfo({
    required this.id,
    required this.name,
    required this.code,
    this.currency,
    this.country,
    this.phone,
    this.isAgent,
    this.hudhudPercent,
    this.createdAt,
  });

  factory BranchInfo.fromMap(Map<String, dynamic> map) {
    return BranchInfo(
      id: map['id'] as int,
      name: map['name'] as String,
      code: map['code'] as String,
      currency: map['currency'] != null
          ? Currency.fromMap(map['currency'] as Map<String, dynamic>)
          : null,
      country: map['country'] != null
          ? Country.fromMap(map['country'] as Map<String, dynamic>)
          : null,
      phone: map['phone'] as String?,
      isAgent: map['isAgent'] as bool?,
      hudhudPercent: (map['hudhudPercent'] as num?)?.toDouble(),
      createdAt: map['createdAt'] as String?,
    );
  }
}

class Currency {
  final int id;
  final String code;
  final String description;
  final String createdAt;

  Currency({
    required this.id,
    required this.code,
    required this.description,
    required this.createdAt,
  });

  factory Currency.fromMap(Map<String, dynamic> map) {
    return Currency(
      id: map['id'] as int,
      code: map['code'] as String,
      description: map['description'] as String,
      createdAt: map['createdAt'] as String,
    );
  }
}

class Country {
  final int id;
  final String name;
  final String isoCode;
  final String countryCode;
  final String createdAt;

  Country({
    required this.id,
    required this.name,
    required this.isoCode,
    required this.countryCode,
    required this.createdAt,
  });

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      id: map['id'] as int,
      name: map['name'] as String,
      isoCode: map['isoCode'] as String,
      countryCode: map['countryCode'] as String,
      createdAt: map['createdAt'] as String,
    );
  }
}

class TellerByBranchModel {
  final int id;
  final String tellerName;
  final String accountNumber;
  final double balance;
  final double limit;
  final String status;
  final String createdAt;
  final dynamic branch; // Can be int or BranchInfo object

  TellerByBranchModel({
    required this.id,
    required this.tellerName,
    required this.accountNumber,
    required this.balance,
    required this.limit,
    required this.status,
    required this.createdAt,
    required this.branch,
  });

  factory TellerByBranchModel.fromMap(Map<String, dynamic> map) {
    return TellerByBranchModel(
      id: map['id'] as int,
      tellerName: map['tellerName'] as String,
      accountNumber: map['accountNumber'] as String,
      balance: (map['balance'] as num?)?.toDouble() ?? 0.0,
      limit: (map['limit'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] as String,
      createdAt: map['createdAt'] as String,
      branch: map['branch'],
    );
  }

  String getBranchName() {
    if (branch is Map) {
      return (branch as Map)['name'] as String? ?? 'N/A';
    }
    return 'N/A';
  }

  String getBranchCode() {
    if (branch is Map) {
      return (branch as Map)['code'] as String? ?? 'N/A';
    }
    return 'N/A';
  }

  int getBranchId() {
    if (branch is Map) {
      return (branch as Map)['id'] as int? ?? 0;
    }
    return branch is int ? branch as int : 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tellerName': tellerName,
      'accountNumber': accountNumber,
      'balance': balance,
      'limit': limit,
      'status': status,
      'createdAt': createdAt,
      'branch': branch,
    };
  }

  String toJson() => json.encode(toMap());

  factory TellerByBranchModel.fromJson(String source) =>
      TellerByBranchModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class TellerAccountStatus {
  final int tellerId;
  final String tellerName;
  final String tellerStatus;
  final String statusDescription;
  final bool isOpen;
  final String tellerCreatedAt;
  final String? tellerUpdatedAt;
  final String accountNumber;
  final double runningBalance;
  final double expenseBalance;
  final double accountLimit;
  final String balanceFormatted;
  final int branchId;
  final String branchName;
  final String branchCode;
  final int? assignedUserId;
  final String? assignedUserFullName;
  final String? assignedUserEmail;
  final String? assignmentCreatedAt;

  TellerAccountStatus({
    required this.tellerId,
    required this.tellerName,
    required this.tellerStatus,
    required this.statusDescription,
    required this.isOpen,
    required this.tellerCreatedAt,
    this.tellerUpdatedAt,
    required this.accountNumber,
    required this.runningBalance,
    required this.expenseBalance,
    required this.accountLimit,
    required this.balanceFormatted,
    required this.branchId,
    required this.branchName,
    required this.branchCode,
    this.assignedUserId,
    this.assignedUserFullName,
    this.assignedUserEmail,
    this.assignmentCreatedAt,
  });

  factory TellerAccountStatus.fromMap(Map<String, dynamic> map) {
    return TellerAccountStatus(
      tellerId: map['tellerId'] as int,
      tellerName: map['tellerName'] as String,
      tellerStatus: map['tellerStatus'] as String,
      statusDescription: map['statusDescription'] as String,
      isOpen: map['isOpen'] as bool,
      tellerCreatedAt: map['tellerCreatedAt'] as String,
      tellerUpdatedAt: map['tellerUpdatedAt'] as String?,
      accountNumber: map['accountNumber'] as String,
      runningBalance: (map['runningBalance'] as num?)?.toDouble() ?? 0.0,
      expenseBalance: (map['expenseBalance'] as num?)?.toDouble() ?? 0.0,
      accountLimit: (map['accountLimit'] as num?)?.toDouble() ?? 0.0,
      balanceFormatted: map['balanceFormatted'] as String,
      branchId: map['branchId'] as int,
      branchName: map['branchName'] as String,
      branchCode: map['branchCode'] as String,
      assignedUserId: map['assignedUserId'] as int?,
      assignedUserFullName: map['assignedUserFullName'] as String?,
      assignedUserEmail: map['assignedUserEmail'] as String?,
      assignmentCreatedAt: map['assignmentCreatedAt'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tellerId': tellerId,
      'tellerName': tellerName,
      'tellerStatus': tellerStatus,
      'statusDescription': statusDescription,
      'isOpen': isOpen,
      'tellerCreatedAt': tellerCreatedAt,
      'tellerUpdatedAt': tellerUpdatedAt,
      'accountNumber': accountNumber,
      'runningBalance': runningBalance,
      'expenseBalance': expenseBalance,
      'accountLimit': accountLimit,
      'balanceFormatted': balanceFormatted,
      'branchId': branchId,
      'branchName': branchName,
      'branchCode': branchCode,
      'assignedUserId': assignedUserId,
      'assignedUserFullName': assignedUserFullName,
      'assignedUserEmail': assignedUserEmail,
      'assignmentCreatedAt': assignmentCreatedAt,
    };
  }

  String toJson() => json.encode(toMap());

  factory TellerAccountStatus.fromJson(String source) =>
      TellerAccountStatus.fromMap(json.decode(source) as Map<String, dynamic>);
}

// Combined model for display
class TellerByBranchWithStatus {
  final TellerByBranchModel teller;
  final TellerAccountStatus? accountStatus;

  TellerByBranchWithStatus({
    required this.teller,
    this.accountStatus,
  });
}

