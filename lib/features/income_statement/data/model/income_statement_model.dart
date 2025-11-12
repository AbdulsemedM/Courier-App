// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RevenueItem {
  final String accountName;
  final String category;
  final double amount;
  final String description;

  RevenueItem({
    required this.accountName,
    required this.category,
    required this.amount,
    required this.description,
  });

  factory RevenueItem.fromMap(Map<String, dynamic> map) {
    return RevenueItem(
      accountName: map['accountName'] as String? ?? '',
      category: map['category'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      description: map['description'] as String? ?? '',
    );
  }
}

class ExpenseItem {
  final String accountName;
  final String category;
  final double amount;
  final String description;

  ExpenseItem({
    required this.accountName,
    required this.category,
    required this.amount,
    required this.description,
  });

  factory ExpenseItem.fromMap(Map<String, dynamic> map) {
    return ExpenseItem(
      accountName: map['accountName'] as String? ?? '',
      category: map['category'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      description: map['description'] as String? ?? '',
    );
  }
}

class Revenue {
  final double shipmentFees;
  final double deliveryFees;
  final double extraFees;
  final double otherRevenue;
  final double totalRevenue;
  final List<RevenueItem> revenueItems;

  Revenue({
    required this.shipmentFees,
    required this.deliveryFees,
    required this.extraFees,
    required this.otherRevenue,
    required this.totalRevenue,
    required this.revenueItems,
  });

  factory Revenue.fromMap(Map<String, dynamic> map) {
    return Revenue(
      shipmentFees: (map['shipmentFees'] as num?)?.toDouble() ?? 0.0,
      deliveryFees: (map['deliveryFees'] as num?)?.toDouble() ?? 0.0,
      extraFees: (map['extraFees'] as num?)?.toDouble() ?? 0.0,
      otherRevenue: (map['otherRevenue'] as num?)?.toDouble() ?? 0.0,
      totalRevenue: (map['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      revenueItems: (map['revenueItems'] as List<dynamic>?)
              ?.map((item) => RevenueItem.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Expenses {
  final double operationalExpenses;
  final double personnelExpenses;
  final double marketingExpenses;
  final double depreciation;
  final double otherExpenses;
  final double totalExpenses;
  final List<ExpenseItem> expenseItems;

  Expenses({
    required this.operationalExpenses,
    required this.personnelExpenses,
    required this.marketingExpenses,
    required this.depreciation,
    required this.otherExpenses,
    required this.totalExpenses,
    required this.expenseItems,
  });

  factory Expenses.fromMap(Map<String, dynamic> map) {
    return Expenses(
      operationalExpenses: (map['operationalExpenses'] as num?)?.toDouble() ?? 0.0,
      personnelExpenses: (map['personnelExpenses'] as num?)?.toDouble() ?? 0.0,
      marketingExpenses: (map['marketingExpenses'] as num?)?.toDouble() ?? 0.0,
      depreciation: (map['depreciation'] as num?)?.toDouble() ?? 0.0,
      otherExpenses: (map['otherExpenses'] as num?)?.toDouble() ?? 0.0,
      totalExpenses: (map['totalExpenses'] as num?)?.toDouble() ?? 0.0,
      expenseItems: (map['expenseItems'] as List<dynamic>?)
              ?.map((item) => ExpenseItem.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class AccountBalance {
  final int id;
  final String accountNumber;
  final String accountType;
  final int branchId;
  final String branchName;
  final double runningBalance;
  final double expenseBalance;

  AccountBalance({
    required this.id,
    required this.accountNumber,
    required this.accountType,
    required this.branchId,
    required this.branchName,
    required this.runningBalance,
    required this.expenseBalance,
  });

  factory AccountBalance.fromMap(Map<String, dynamic> map) {
    return AccountBalance(
      id: map['id'] as int? ?? 0,
      accountNumber: map['accountNumber'] as String? ?? '',
      accountType: map['accountType'] as String? ?? '',
      branchId: map['branchId'] as int? ?? 0,
      branchName: map['branchName'] as String? ?? '',
      runningBalance: (map['runningBalance'] as num?)?.toDouble() ?? 0.0,
      expenseBalance: (map['expenseBalance'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class IncomeStatementModel {
  final String reportDate;
  final String fromDate;
  final String toDate;
  final int branchId;
  final Revenue revenue;
  final Expenses expenses;
  final double grossRevenue;
  final double totalExpenses;
  final double netIncome;
  final double grossMargin;
  final double netMargin;
  final List<AccountBalance> accounts;
  final List<Map<String, dynamic>> branches;
  final List<String> accountTypes;

  IncomeStatementModel({
    required this.reportDate,
    required this.fromDate,
    required this.toDate,
    required this.branchId,
    required this.revenue,
    required this.expenses,
    required this.grossRevenue,
    required this.totalExpenses,
    required this.netIncome,
    required this.grossMargin,
    required this.netMargin,
    required this.accounts,
    required this.branches,
    required this.accountTypes,
  });

  factory IncomeStatementModel.fromMap(Map<String, dynamic> map) {
    return IncomeStatementModel(
      reportDate: map['reportDate'] as String? ?? '',
      fromDate: map['fromDate'] as String? ?? '',
      toDate: map['toDate'] as String? ?? '',
      branchId: map['branchId'] as int? ?? 0,
      revenue: Revenue.fromMap(map['revenue'] as Map<String, dynamic>? ?? {}),
      expenses: Expenses.fromMap(map['expenses'] as Map<String, dynamic>? ?? {}),
      grossRevenue: (map['grossRevenue'] as num?)?.toDouble() ?? 0.0,
      totalExpenses: (map['totalExpenses'] as num?)?.toDouble() ?? 0.0,
      netIncome: (map['netIncome'] as num?)?.toDouble() ?? 0.0,
      grossMargin: (map['grossMargin'] as num?)?.toDouble() ?? 0.0,
      netMargin: (map['netMargin'] as num?)?.toDouble() ?? 0.0,
      accounts: (map['accounts'] as List<dynamic>?)
              ?.map((account) => AccountBalance.fromMap(account as Map<String, dynamic>))
              .toList() ??
          [],
      branches: (map['branches'] as List<dynamic>?)
              ?.map((branch) => branch as Map<String, dynamic>)
              .toList() ??
          [],
      accountTypes: (map['accountTypes'] as List<dynamic>?)
              ?.map((type) => type as String)
              .toList() ??
          [],
    );
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'reportDate': reportDate,
      'fromDate': fromDate,
      'toDate': toDate,
      'branchId': branchId,
      'revenue': {
        'shipmentFees': revenue.shipmentFees,
        'deliveryFees': revenue.deliveryFees,
        'extraFees': revenue.extraFees,
        'otherRevenue': revenue.otherRevenue,
        'totalRevenue': revenue.totalRevenue,
        'revenueItems': revenue.revenueItems.map((item) => {
          'accountName': item.accountName,
          'category': item.category,
          'amount': item.amount,
          'description': item.description,
        }).toList(),
      },
      'expenses': {
        'operationalExpenses': expenses.operationalExpenses,
        'personnelExpenses': expenses.personnelExpenses,
        'marketingExpenses': expenses.marketingExpenses,
        'depreciation': expenses.depreciation,
        'otherExpenses': expenses.otherExpenses,
        'totalExpenses': expenses.totalExpenses,
        'expenseItems': expenses.expenseItems.map((item) => {
          'accountName': item.accountName,
          'category': item.category,
          'amount': item.amount,
          'description': item.description,
        }).toList(),
      },
      'grossRevenue': grossRevenue,
      'totalExpenses': totalExpenses,
      'netIncome': netIncome,
      'grossMargin': grossMargin,
      'netMargin': netMargin,
      'accounts': accounts.map((account) => {
        'id': account.id,
        'accountNumber': account.accountNumber,
        'accountType': account.accountType,
        'branchId': account.branchId,
        'branchName': account.branchName,
        'runningBalance': account.runningBalance,
        'expenseBalance': account.expenseBalance,
      }).toList(),
      'branches': branches,
      'accountTypes': accountTypes,
    };
  }

  factory IncomeStatementModel.fromJson(String source) =>
      IncomeStatementModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

