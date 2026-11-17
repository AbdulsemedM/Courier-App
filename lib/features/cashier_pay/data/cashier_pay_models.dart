double _toDouble(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0;
}

double? _toDoubleOrNull(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString());
}

int? _toIntOrNull(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString());
}

String? _str(dynamic v) {
  if (v == null) return null;
  final s = v.toString();
  return s.isEmpty ? null : s;
}

/// Branch cashier wallet (`cashier` object in `GET /cashiers/me`).
class Cashier {
  final int id;
  final int? branchId;
  final String branchName;
  final int? userId;
  final String? userName;
  final String? phone;
  final double balance;
  final double? dailyLimit;
  final double paidToday;
  final bool active;

  const Cashier({
    required this.id,
    this.branchId,
    required this.branchName,
    this.userId,
    this.userName,
    this.phone,
    required this.balance,
    this.dailyLimit,
    required this.paidToday,
    required this.active,
  });

  /// Remaining amount allowed today, or null when there is no daily limit.
  double? get leftToday {
    final limit = dailyLimit;
    if (limit == null || limit <= 0) return null;
    final left = limit - paidToday;
    return left < 0 ? 0 : left;
  }

  factory Cashier.fromJson(Map<String, dynamic> json) => Cashier(
        id: _toIntOrNull(json['id']) ?? 0,
        branchId: _toIntOrNull(json['branchId']),
        branchName: _str(json['branchName']) ?? '',
        userId: _toIntOrNull(json['userId']),
        userName: _str(json['userName']),
        phone: _str(json['phone']),
        balance: _toDouble(json['balance']),
        dailyLimit: _toDoubleOrNull(json['dailyLimit']),
        paidToday: _toDouble(json['paidToday']),
        active: json['active'] != false,
      );
}

/// `GET /cashiers/me` payload.
class CashierProfile {
  final bool isCashier;
  final bool isHq;
  final bool payoutEnabled;
  final Cashier? cashier;

  const CashierProfile({
    required this.isCashier,
    required this.isHq,
    required this.payoutEnabled,
    this.cashier,
  });

  factory CashierProfile.fromJson(Map<String, dynamic> json) {
    final c = json['cashier'];
    return CashierProfile(
      isCashier: json['isCashier'] == true,
      isHq: json['isHq'] == true,
      payoutEnabled: json['payoutEnabled'] == true,
      cashier: c is Map ? Cashier.fromJson(Map<String, dynamic>.from(c)) : null,
    );
  }
}

/// Bank / wallet that QPay can send to (`GET /cashiers/banks`).
class PayoutBank {
  final String name;
  final String code;
  final String? altCode;
  final String type;

  const PayoutBank({
    required this.name,
    required this.code,
    this.altCode,
    required this.type,
  });

  factory PayoutBank.fromJson(Map<String, dynamic> json) => PayoutBank(
        name: _str(json['name']) ?? _str(json['code']) ?? '',
        code: _str(json['code']) ?? '',
        altCode: _str(json['altCode']),
        type: _str(json['type']) ?? 'Banks & wallets',
      );
}

/// Expense type (`GET /expense-types`).
class CashierExpenseType {
  final int id;
  final String code;
  final String description;

  const CashierExpenseType({
    required this.id,
    required this.code,
    required this.description,
  });

  String get label {
    final desc = description.isNotEmpty ? description : code;
    return code.isNotEmpty && code != desc ? '$desc ($code)' : desc;
  }

  factory CashierExpenseType.fromJson(Map<String, dynamic> json) =>
      CashierExpenseType(
        id: _toIntOrNull(json['id']) ?? 0,
        code: _str(json['code']) ?? '',
        description: _str(json['description']) ?? '',
      );
}

/// `POST /cashiers/payouts/lookup` result.
class AccountLookupResult {
  final String? accountName;
  final String? lookupToken;
  final double? fee;

  const AccountLookupResult({this.accountName, this.lookupToken, this.fee});

  factory AccountLookupResult.fromJson(Map<String, dynamic> json) =>
      AccountLookupResult(
        accountName: _str(json['accountName']),
        lookupToken: _str(json['lookupToken']),
        fee: _toDoubleOrNull(json['fee']),
      );
}

/// A cashier wallet transaction: a payout, a top-up or a top-up request.
///
/// Returned by `POST /cashiers/payouts`, `GET /cashiers/topup-requests/mine`
/// and as `entries` of `GET /cashiers/{id}/statement`.
class CashierTransaction {
  final int id;
  final String type; // PAYOUT | TOPUP | ...
  final String status; // SUCCESS | FAILED | PENDING | PENDING_CONFIRM | CONFIRMED | REJECTED ...
  final double amount;
  final double? requestedAmount;
  final double? balanceAfter;
  final String? description;
  final String? cashierName;
  final String? branchName;
  final bool isRequest;
  final String? bankCode;
  final String? bankName;
  final String? accountNumber;
  final String? accountName;
  final String? reference;
  final String? partnerReference;
  final int? expenseId;
  final String? payee;
  final String? expenseType;
  final String? failureReason;
  final String? createdBy;
  final String? confirmedBy;
  final DateTime? createdAt;

  const CashierTransaction({
    required this.id,
    required this.type,
    required this.status,
    required this.amount,
    this.requestedAmount,
    this.balanceAfter,
    this.description,
    this.cashierName,
    this.branchName,
    this.isRequest = false,
    this.bankCode,
    this.bankName,
    this.accountNumber,
    this.accountName,
    this.reference,
    this.partnerReference,
    this.expenseId,
    this.payee,
    this.expenseType,
    this.failureReason,
    this.createdBy,
    this.confirmedBy,
    this.createdAt,
  });

  bool get isPayout => type.toUpperCase() == 'PAYOUT';
  bool get isSuccess => status.toUpperCase() == 'SUCCESS';
  bool get isFailed => status.toUpperCase() == 'FAILED';

  /// Payout QPay gave no clear answer for; HQ must resolve it.
  bool get needsResolve {
    final st = status.toUpperCase();
    return isPayout && (st == 'UNKNOWN' || st == 'PROCESSING');
  }

  factory CashierTransaction.fromJson(Map<String, dynamic> json) =>
      CashierTransaction(
        id: _toIntOrNull(json['id']) ?? 0,
        type: _str(json['type']) ?? '',
        status: _str(json['status']) ?? '',
        amount: _toDouble(json['amount']),
        requestedAmount: _toDoubleOrNull(json['requestedAmount']),
        balanceAfter: _toDoubleOrNull(json['balanceAfter']),
        description: _str(json['description']),
        cashierName: _str(json['cashierName']),
        branchName: _str(json['branchName']),
        isRequest: json['isRequest'] == true,
        bankCode: _str(json['bankCode']),
        bankName: _str(json['bankName']),
        accountNumber: _str(json['accountNumber']),
        accountName: _str(json['accountName']),
        reference: _str(json['reference']),
        partnerReference: _str(json['partnerReference']),
        expenseId: _toIntOrNull(json['expenseId']),
        payee: _str(json['payee']),
        expenseType: _str(json['expenseType']),
        failureReason: _str(json['failureReason']),
        createdBy: _str(json['createdBy']),
        confirmedBy: _str(json['confirmedBy']),
        createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      );
}

/// `GET /cashiers/{id}/statement` payload.
class CashierStatement {
  final double topups;
  final double paid;
  final double unresolved;
  final double balance;
  final List<CashierTransaction> entries;

  const CashierStatement({
    required this.topups,
    required this.paid,
    required this.unresolved,
    required this.balance,
    required this.entries,
  });

  factory CashierStatement.fromJson(Map<String, dynamic> json) {
    final raw = json['entries'];
    return CashierStatement(
      topups: _toDouble(json['topups']),
      paid: _toDouble(json['paid']),
      unresolved: _toDouble(json['unresolved']),
      balance: _toDouble(json['balance']),
      entries: raw is List
          ? raw
              .whereType<Map>()
              .map((e) =>
                  CashierTransaction.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
    );
  }
}

/// Body for `POST /cashiers/payouts`.
class PayoutRequest {
  final PayoutBank bank;
  final String accountNumber;
  final String accountName;
  final String amount;
  final String description;
  final String lookupToken;
  final int expenseTypeId;
  final String payee;

  const PayoutRequest({
    required this.bank,
    required this.accountNumber,
    required this.accountName,
    required this.amount,
    required this.description,
    required this.lookupToken,
    required this.expenseTypeId,
    required this.payee,
  });

  Map<String, dynamic> toJson() => {
        'bankCode': bank.code,
        'bankName': bank.name,
        'accountNumber': accountNumber,
        'accountName': accountName,
        'amount': amount,
        'description': description,
        'lookupToken': lookupToken,
        'expenseTypeId': expenseTypeId,
        'payee': payee,
      };
}

// --------------------------------------------------------------- HQ finance

/// Active user of a branch who can be made cashier
/// (`GET /cashiers/branch-users/{branchId}`).
class BranchUser {
  final int id;
  final String name;
  final String? phone;
  final String? role;

  const BranchUser({required this.id, required this.name, this.phone, this.role});

  String get label =>
      [name, if (phone != null) phone!, if (role != null) role!].join(' · ');

  factory BranchUser.fromJson(Map<String, dynamic> json) => BranchUser(
        id: _toIntOrNull(json['id']) ?? 0,
        name: _str(json['name']) ??
            [json['firstName'], json['lastName']]
                .where((e) => e != null && e.toString().isNotEmpty)
                .join(' '),
        phone: _str(json['phone']),
        role: _str(json['role']) ?? _str(json['roleName']),
      );
}

/// Money available to fund cashier wallets (`GET /cashiers/funding`).
class CashierFunding {
  final double? qpayBalance;
  final double hqLedgerBalance;
  final double cashierWallets;
  final double unresolvedPayouts;

  const CashierFunding({
    this.qpayBalance,
    required this.hqLedgerBalance,
    required this.cashierWallets,
    required this.unresolvedPayouts,
  });

  /// True when crediting [extra] would put more in wallets than QPay holds.
  bool wouldExceedQpay(double extra) {
    final q = qpayBalance;
    if (q == null) return false;
    return cashierWallets + unresolvedPayouts + extra > q;
  }

  factory CashierFunding.fromJson(Map<String, dynamic> json) => CashierFunding(
        qpayBalance: _toDoubleOrNull(json['qpayBalance']),
        hqLedgerBalance: _toDouble(json['hqLedgerBalance']),
        cashierWallets: _toDouble(json['cashierWallets']),
        unresolvedPayouts: _toDouble(json['unresolvedPayouts']),
      );
}

class ExpenseTypeTotal {
  final String expenseType;
  final double amount;

  const ExpenseTypeTotal(this.expenseType, this.amount);
}

/// `GET /cashiers/report` payload (all cashiers, filterable).
class CashierReport {
  final double topups;
  final double pendingTopups;
  final double paid;
  final double unresolved;
  final double walletBalances;
  final List<ExpenseTypeTotal> byExpenseType;
  final List<CashierTransaction> entries;

  const CashierReport({
    required this.topups,
    required this.pendingTopups,
    required this.paid,
    required this.unresolved,
    required this.walletBalances,
    required this.byExpenseType,
    required this.entries,
  });

  factory CashierReport.fromJson(Map<String, dynamic> json) {
    final byType = json['byExpenseType'];
    final entries = json['entries'];
    return CashierReport(
      topups: _toDouble(json['topups']),
      pendingTopups: _toDouble(json['pendingTopups']),
      paid: _toDouble(json['paid']),
      unresolved: _toDouble(json['unresolved']),
      walletBalances: _toDouble(json['walletBalances']),
      byExpenseType: byType is List
          ? byType
              .whereType<Map>()
              .map((e) => ExpenseTypeTotal(
                    e['expenseType']?.toString() ?? '-',
                    _toDouble(e['amount']),
                  ))
              .toList()
          : const [],
      entries: entries is List
          ? entries
              .whereType<Map>()
              .map((e) =>
                  CashierTransaction.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
    );
  }
}

/// `POST /cashiers/payouts/{id}/status` result.
class PayoutStatusResult {
  final String? qpayStatus;
  final String? qpayReference;

  const PayoutStatusResult({this.qpayStatus, this.qpayReference});

  factory PayoutStatusResult.fromJson(Map<String, dynamic> json) =>
      PayoutStatusResult(
        qpayStatus: _str(json['qpayStatus']),
        qpayReference: _str(json['qpayReference']),
      );
}

/// Expense created by a cashier QPay payout (`GET /cashiers/expense-links`).
class CashierExpenseLink {
  final int expenseId;
  final int? entryId;
  final String? cashierName;
  final String? branchName;
  final String? bankName;
  final String? accountNumber;
  final String? accountName;
  final String? payee;
  final String? reference;
  final DateTime? paidAt;

  const CashierExpenseLink({
    required this.expenseId,
    this.entryId,
    this.cashierName,
    this.branchName,
    this.bankName,
    this.accountNumber,
    this.accountName,
    this.payee,
    this.reference,
    this.paidAt,
  });

  factory CashierExpenseLink.fromJson(Map<String, dynamic> json) =>
      CashierExpenseLink(
        expenseId: _toIntOrNull(json['expenseId']) ?? 0,
        entryId: _toIntOrNull(json['entryId']),
        cashierName: _str(json['cashierName']),
        branchName: _str(json['branchName']),
        bankName: _str(json['bankName']),
        accountNumber: _str(json['accountNumber']),
        accountName: _str(json['accountName']),
        payee: _str(json['payee']),
        reference: _str(json['reference']) ?? _str(json['partnerReference']),
        paidAt: DateTime.tryParse(json['paidAt']?.toString() ?? ''),
      );
}
