// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BalanceSheetItem {
  final String accountName;
  final String category;
  final double amount;
  final String description;

  BalanceSheetItem({
    required this.accountName,
    required this.category,
    required this.amount,
    required this.description,
  });

  factory BalanceSheetItem.fromMap(Map<String, dynamic> map) {
    return BalanceSheetItem(
      accountName: map['accountName'] as String? ?? '',
      category: map['category'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      description: map['description'] as String? ?? '',
    );
  }
}

class Assets {
  final double cashAndBank;
  final double accountsReceivable;
  final double inventory;
  final double prepaidExpenses;
  final double currentAssets;
  final double fixedAssets;
  final double totalAssets;
  final List<BalanceSheetItem> assetItems;

  Assets({
    required this.cashAndBank,
    required this.accountsReceivable,
    required this.inventory,
    required this.prepaidExpenses,
    required this.currentAssets,
    required this.fixedAssets,
    required this.totalAssets,
    required this.assetItems,
  });

  factory Assets.fromMap(Map<String, dynamic> map) {
    return Assets(
      cashAndBank: (map['cashAndBank'] as num?)?.toDouble() ?? 0.0,
      accountsReceivable: (map['accountsReceivable'] as num?)?.toDouble() ?? 0.0,
      inventory: (map['inventory'] as num?)?.toDouble() ?? 0.0,
      prepaidExpenses: (map['prepaidExpenses'] as num?)?.toDouble() ?? 0.0,
      currentAssets: (map['currentAssets'] as num?)?.toDouble() ?? 0.0,
      fixedAssets: (map['fixedAssets'] as num?)?.toDouble() ?? 0.0,
      totalAssets: (map['totalAssets'] as num?)?.toDouble() ?? 0.0,
      assetItems: (map['assetItems'] as List<dynamic>?)
              ?.map((item) => BalanceSheetItem.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Liabilities {
  final double accountsPayable;
  final double accruedExpenses;
  final double shortTermDebt;
  final double currentLiabilities;
  final double longTermDebt;
  final double totalLiabilities;
  final List<BalanceSheetItem> liabilityItems;

  Liabilities({
    required this.accountsPayable,
    required this.accruedExpenses,
    required this.shortTermDebt,
    required this.currentLiabilities,
    required this.longTermDebt,
    required this.totalLiabilities,
    required this.liabilityItems,
  });

  factory Liabilities.fromMap(Map<String, dynamic> map) {
    return Liabilities(
      accountsPayable: (map['accountsPayable'] as num?)?.toDouble() ?? 0.0,
      accruedExpenses: (map['accruedExpenses'] as num?)?.toDouble() ?? 0.0,
      shortTermDebt: (map['shortTermDebt'] as num?)?.toDouble() ?? 0.0,
      currentLiabilities: (map['currentLiabilities'] as num?)?.toDouble() ?? 0.0,
      longTermDebt: (map['longTermDebt'] as num?)?.toDouble() ?? 0.0,
      totalLiabilities: (map['totalLiabilities'] as num?)?.toDouble() ?? 0.0,
      liabilityItems: (map['liabilityItems'] as List<dynamic>?)
              ?.map((item) => BalanceSheetItem.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Equity {
  final double capital;
  final double retainedEarnings;
  final double currentYearProfit;
  final double totalEquity;
  final List<BalanceSheetItem> equityItems;

  Equity({
    required this.capital,
    required this.retainedEarnings,
    required this.currentYearProfit,
    required this.totalEquity,
    required this.equityItems,
  });

  factory Equity.fromMap(Map<String, dynamic> map) {
    return Equity(
      capital: (map['capital'] as num?)?.toDouble() ?? 0.0,
      retainedEarnings: (map['retainedEarnings'] as num?)?.toDouble() ?? 0.0,
      currentYearProfit: (map['currentYearProfit'] as num?)?.toDouble() ?? 0.0,
      totalEquity: (map['totalEquity'] as num?)?.toDouble() ?? 0.0,
      equityItems: (map['equityItems'] as List<dynamic>?)
              ?.map((item) => BalanceSheetItem.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class BalanceSheetModel {
  final String reportDate;
  final String fromDate;
  final String toDate;
  final int branchId;
  final Assets assets;
  final Liabilities liabilities;
  final Equity equity;
  final double totalAssets;
  final double totalLiabilities;
  final double totalEquity;
  final double balancingAmount;

  BalanceSheetModel({
    required this.reportDate,
    required this.fromDate,
    required this.toDate,
    required this.branchId,
    required this.assets,
    required this.liabilities,
    required this.equity,
    required this.totalAssets,
    required this.totalLiabilities,
    required this.totalEquity,
    required this.balancingAmount,
  });

  factory BalanceSheetModel.fromMap(Map<String, dynamic> map) {
    return BalanceSheetModel(
      reportDate: map['reportDate'] as String? ?? '',
      fromDate: map['fromDate'] as String? ?? '',
      toDate: map['toDate'] as String? ?? '',
      branchId: map['branchId'] as int? ?? 0,
      assets: Assets.fromMap(map['assets'] as Map<String, dynamic>? ?? {}),
      liabilities: Liabilities.fromMap(map['liabilities'] as Map<String, dynamic>? ?? {}),
      equity: Equity.fromMap(map['equity'] as Map<String, dynamic>? ?? {}),
      totalAssets: (map['totalAssets'] as num?)?.toDouble() ?? 0.0,
      totalLiabilities: (map['totalLiabilities'] as num?)?.toDouble() ?? 0.0,
      totalEquity: (map['totalEquity'] as num?)?.toDouble() ?? 0.0,
      balancingAmount: (map['balancingAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'reportDate': reportDate,
      'fromDate': fromDate,
      'toDate': toDate,
      'branchId': branchId,
      'assets': {
        'cashAndBank': assets.cashAndBank,
        'accountsReceivable': assets.accountsReceivable,
        'inventory': assets.inventory,
        'prepaidExpenses': assets.prepaidExpenses,
        'currentAssets': assets.currentAssets,
        'fixedAssets': assets.fixedAssets,
        'totalAssets': assets.totalAssets,
        'assetItems': assets.assetItems.map((item) => {
          'accountName': item.accountName,
          'category': item.category,
          'amount': item.amount,
          'description': item.description,
        }).toList(),
      },
      'liabilities': {
        'accountsPayable': liabilities.accountsPayable,
        'accruedExpenses': liabilities.accruedExpenses,
        'shortTermDebt': liabilities.shortTermDebt,
        'currentLiabilities': liabilities.currentLiabilities,
        'longTermDebt': liabilities.longTermDebt,
        'totalLiabilities': liabilities.totalLiabilities,
        'liabilityItems': liabilities.liabilityItems.map((item) => {
          'accountName': item.accountName,
          'category': item.category,
          'amount': item.amount,
          'description': item.description,
        }).toList(),
      },
      'equity': {
        'capital': equity.capital,
        'retainedEarnings': equity.retainedEarnings,
        'currentYearProfit': equity.currentYearProfit,
        'totalEquity': equity.totalEquity,
        'equityItems': equity.equityItems.map((item) => {
          'accountName': item.accountName,
          'category': item.category,
          'amount': item.amount,
          'description': item.description,
        }).toList(),
      },
      'totalAssets': totalAssets,
      'totalLiabilities': totalLiabilities,
      'totalEquity': totalEquity,
      'balancingAmount': balancingAmount,
    };
  }

  factory BalanceSheetModel.fromJson(String source) =>
      BalanceSheetModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

