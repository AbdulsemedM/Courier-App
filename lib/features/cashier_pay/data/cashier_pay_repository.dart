import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/core/utils/api_json_decoder.dart';
import 'package:courier_app/features/cashier_pay/data/cashier_pay_models.dart';
import 'package:courier_app/providers/api_provider.dart';
import 'package:courier_app/providers/provider_setup.dart';

/// Branch cashier wallet + QPay payouts (web: /dashboard/expense/cashier-pay).
///
/// Endpoints (base `https://api.hudhudexpress.com/api/v1`):
///  - GET  /cashiers/me                       wallet, isCashier, payoutEnabled
///  - GET  /cashiers/banks                    banks & wallets QPay supports
///  - GET  /expense-types                     expense type picker
///  - POST /cashiers/payouts/lookup           verify account → name + lookupToken
///  - POST /cashiers/payouts                  send money (records an expense)
///  - GET  /cashiers/{id}/statement           statement for date range
///  - GET  /cashiers/topup-requests/mine      my top-up requests
///  - POST /cashiers/topup-requests           ask HQ finance for a top-up
///  - GET  /cashiers/expense-links            expenses created by payouts
///
/// HQ finance only (server answers 403 "Only HQ finance can manage cashiers"
/// for everyone else; `GET /cashiers/me` → `isHq` tells who is HQ):
///  - GET  /cashiers                          active cashiers
///  - GET  /cashiers/branch-users/{branchId}  users that can become cashier
///  - POST /cashiers                          create/replace {branchId,userId,dailyLimit}
///  - PUT  /cashiers/{id}                     {dailyLimit} or {active:false}
///  - GET  /cashiers/funding                  QPay / HQ ledger balances
///  - POST /cashiers/{id}/topups              create top-up {amount,description}
///  - POST /cashiers/topups/{id}/confirm      approve (optional {amount})
///  - POST /cashiers/topups/{id}/reject       {reason} (cashier requests)
///  - POST /cashiers/topups/{id}/cancel       cancel an HQ-created top-up
///  - POST /cashiers/payouts/{id}/status      ask QPay about an unclear payout
///  - POST /cashiers/payouts/{id}/resolve     {sent,qpayReference}
///  - GET  /cashiers/report                   filtered report over all cashiers
class CashierPayRepository {
  static const _base = '/api/v1';

  /// Expense types reserved for the system; hidden from the picker (as on web).
  static const _hiddenExpenseCodes = {'CASHIER_PAYOUT', 'QPAY_PAYOUT_FEE'};

  final ApiProvider _api;

  /// QPay calls (lookup and payout) can take a long time. A short client
  /// timeout on a payout could make a cashier retry a payment that already
  /// went through, so these use a long timeout.
  final ApiProvider _slowApi;

  CashierPayRepository({ApiProvider? api, ApiProvider? slowApi})
      : _api = api ?? ProviderSetup.getApiProvider(ApiConstants.baseUrl),
        _slowApi = slowApi ??
            ProviderSetup.getApiProvider(
              ApiConstants.baseUrl,
              timeout: const Duration(seconds: 120),
            );

  dynamic _data(String body) => decodeApiMap(body)['data'];

  List<Map<String, dynamic>> _list(dynamic data) => data is List
      ? data.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
      : const [];

  Map<String, dynamic> _map(dynamic data) =>
      data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{};

  Future<CashierProfile> fetchMe() async {
    final res = await _api.getRequest('$_base/cashiers/me');
    return CashierProfile.fromJson(_map(_data(res.body)));
  }

  Future<List<PayoutBank>> fetchBanks() async {
    final res = await _api.getRequest('$_base/cashiers/banks');
    final banks = _list(_data(res.body)).map(PayoutBank.fromJson).toList()
      ..sort((a, b) {
        final t = a.type.compareTo(b.type);
        return t != 0 ? t : a.name.compareTo(b.name);
      });
    return banks;
  }

  Future<List<CashierExpenseType>> fetchExpenseTypes() async {
    final res = await _api.getRequest('$_base/expense-types');
    return _list(_data(res.body))
        .map(CashierExpenseType.fromJson)
        .where((t) => !_hiddenExpenseCodes.contains(t.code.toUpperCase()))
        .toList();
  }

  Future<AccountLookupResult> lookupAccount({
    required PayoutBank bank,
    required String accountNumber,
  }) async {
    final res = await _slowApi.postRequest('$_base/cashiers/payouts/lookup', {
      'bankCode': bank.code,
      if (bank.altCode != null) 'altCode': bank.altCode,
      'accountNumber': accountNumber,
    });
    return AccountLookupResult.fromJson(_map(_data(res.body)));
  }

  Future<CashierTransaction> sendPayout(PayoutRequest request) async {
    final res =
        await _slowApi.postRequest('$_base/cashiers/payouts', request.toJson());
    return CashierTransaction.fromJson(_map(_data(res.body)));
  }

  Future<CashierStatement> fetchStatement({
    required int cashierId,
    required String fromDate,
    required String toDate,
  }) async {
    final res = await _api.getRequest(
      '$_base/cashiers/$cashierId/statement',
      params: {'fromDate': fromDate, 'toDate': toDate},
    );
    return CashierStatement.fromJson(_map(_data(res.body)));
  }

  Future<List<CashierTransaction>> fetchMyTopupRequests() async {
    final res = await _api.getRequest('$_base/cashiers/topup-requests/mine');
    return _list(_data(res.body)).map(CashierTransaction.fromJson).toList();
  }

  Future<void> requestTopup({
    required String amount,
    required String reason,
  }) async {
    await _api.postRequest('$_base/cashiers/topup-requests', {
      'amount': amount,
      'reason': reason,
    });
  }

  Future<List<CashierExpenseLink>> fetchExpenseLinks() async {
    final res = await _api.getRequest('$_base/cashiers/expense-links');
    return _list(_data(res.body)).map(CashierExpenseLink.fromJson).toList();
  }

  // ------------------------------------------------------------- HQ finance

  Future<List<Cashier>> fetchCashiers() async {
    final res = await _api.getRequest('$_base/cashiers');
    return _list(_data(res.body)).map(Cashier.fromJson).toList();
  }

  Future<List<BranchUser>> fetchBranchUsers(int branchId) async {
    final res = await _api.getRequest('$_base/cashiers/branch-users/$branchId');
    return _list(_data(res.body)).map(BranchUser.fromJson).toList();
  }

  /// Creates the branch cashier, or replaces the current one (server only
  /// allows replacing when the current cashier's balance is 0).
  Future<void> saveCashier({
    required int branchId,
    required int userId,
    double? dailyLimit,
  }) async {
    await _api.postRequest('$_base/cashiers', {
      'branchId': branchId,
      'userId': userId,
      'dailyLimit': dailyLimit,
    });
  }

  /// `dailyLimit` 0 means no limit.
  Future<void> updateDailyLimit(int cashierId, double dailyLimit) async {
    await _api.putRequest('$_base/cashiers/$cashierId', {
      'dailyLimit': dailyLimit,
    });
  }

  /// Removes (deactivates) a cashier. Server requires balance 0.
  Future<void> deactivateCashier(int cashierId) async {
    await _api.putRequest('$_base/cashiers/$cashierId', {'active': false});
  }

  Future<CashierFunding> fetchFunding() async {
    final res = await _api.getRequest('$_base/cashiers/funding');
    return CashierFunding.fromJson(_map(_data(res.body)));
  }

  /// Creates a top-up waiting for confirmation; the cashier is credited only
  /// after [confirmTopup].
  Future<CashierTransaction> createTopup({
    required int cashierId,
    required String amount,
    String description = '',
  }) async {
    final res = await _api.postRequest('$_base/cashiers/$cashierId/topups', {
      'amount': amount,
      'description': description,
    });
    return CashierTransaction.fromJson(_map(_data(res.body)));
  }

  /// Approves a top-up. Pass [amount] only when HQ changed it.
  Future<void> confirmTopup(int topupId, {double? amount}) async {
    await _api.postRequest(
      '$_base/cashiers/topups/$topupId/confirm',
      amount != null ? {'amount': amount} : {},
    );
  }

  Future<void> rejectTopup(int topupId, String reason) async {
    await _api.postRequest(
        '$_base/cashiers/topups/$topupId/reject', {'reason': reason});
  }

  Future<void> cancelTopup(int topupId) async {
    await _api.postRequest('$_base/cashiers/topups/$topupId/cancel', {});
  }

  Future<PayoutStatusResult> checkPayoutStatus(int payoutId) async {
    final res =
        await _slowApi.postRequest('$_base/cashiers/payouts/$payoutId/status', {});
    return PayoutStatusResult.fromJson(_map(_data(res.body)));
  }

  /// [sent] true records the expense; false refunds the cashier.
  Future<void> resolvePayout(
    int payoutId, {
    required bool sent,
    String qpayReference = '',
  }) async {
    await _api.postRequest('$_base/cashiers/payouts/$payoutId/resolve', {
      'sent': sent,
      'qpayReference': qpayReference,
    });
  }

  /// All filters optional; empty values are not sent.
  Future<CashierReport> fetchReport({
    int? branchId,
    String? type,
    String? status,
    int? expenseTypeId,
    required String fromDate,
    required String toDate,
  }) async {
    final params = <String, dynamic>{
      if (branchId != null) 'branchId': branchId,
      if (type != null && type.isNotEmpty) 'type': type,
      if (status != null && status.isNotEmpty) 'status': status,
      if (expenseTypeId != null) 'expenseTypeId': expenseTypeId,
      'fromDate': fromDate,
      'toDate': toDate,
    };
    final res = await _api.getRequest('$_base/cashiers/report', params: params);
    return CashierReport.fromJson(_map(_data(res.body)));
  }

  /// Top-ups waiting for HQ (cashier requests + HQ-created), last 90 days.
  Future<List<CashierTransaction>> fetchPendingTopups({
    required String fromDate,
    required String toDate,
  }) async {
    final r = await fetchReport(
      type: 'TOPUP',
      status: 'PENDING_CONFIRM',
      fromDate: fromDate,
      toDate: toDate,
    );
    return r.entries;
  }
}
