import 'package:courier_app/core/theme/app_palette.dart';
import 'package:courier_app/core/widgets/status_chip.dart';
import 'package:courier_app/features/branches/data/data_provider/branches_data_provider.dart';
import 'package:courier_app/features/branches/data/repository/branches_repository.dart';
import 'package:courier_app/features/branches/model/branches_model.dart';
import 'package:courier_app/features/cashier_pay/data/cashier_pay_models.dart';
import 'package:courier_app/features/cashier_pay/data/cashier_pay_repository.dart';
import 'package:courier_app/features/cashier_pay/presentation/cashier_widgets.dart';
import 'package:flutter/material.dart';

/// HQ finance: create/replace branch cashiers, set limits, top up wallets,
/// approve/reject top-up requests, resolve unclear QPay payouts and view the
/// cashier report (web: /dashboard/expense/cashiers).
class BranchCashiersScreen extends StatefulWidget {
  final CashierPayRepository? repository;

  const BranchCashiersScreen({super.key, this.repository});

  @override
  State<BranchCashiersScreen> createState() => _BranchCashiersScreenState();
}

class _ReportFilter {
  int? branchId;
  String type = '';
  String status = '';
  int? expenseTypeId;
  DateTime from = DateTime.now().subtract(const Duration(days: 7));
  DateTime to = DateTime.now();
}

class _BranchCashiersScreenState extends State<BranchCashiersScreen> {
  late final CashierPayRepository _repo =
      widget.repository ?? CashierPayRepository();

  static const _statuses = [
    'PENDING_CONFIRM',
    'CONFIRMED',
    'REJECTED',
    'SUCCESS',
    'FAILED',
    'UNKNOWN',
    'PROCESSING',
  ];

  CashierProfile? _profile;
  bool _loading = false;
  String? _error;

  List<BranchesModel> _branches = [];
  List<CashierExpenseType> _expenseTypes = [];
  List<Cashier> _cashiers = [];
  List<CashierTransaction> _pendingTopups = [];
  final Map<int, TextEditingController> _approveAmounts = {};
  int? _busyId;

  // Create / change cashier
  BranchesModel? _formBranch;
  List<BranchUser> _branchUsers = [];
  bool _loadingUsers = false;
  BranchUser? _formUser;
  final _limitCtrl = TextEditingController();
  bool _saving = false;

  // Report
  final _filter = _ReportFilter();
  CashierReport? _report;
  bool _loadingReport = false;

  // QPay-paid expenses
  List<CashierExpenseLink> _expenseLinks = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _limitCtrl.dispose();
    for (final c in _approveAmounts.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _snack(String msg, {Color? color}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: color,
        duration: const Duration(seconds: 4),
      ));
  }

  Future<void> _init() async {
    try {
      final p = await _repo.fetchMe();
      if (!mounted) return;
      setState(() => _profile = p);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _profile = const CashierProfile(
            isCashier: false, isHq: false, payoutEnabled: false);
        _error = cashierError(e);
      });
      return;
    }
    if (!(_profile?.isHq ?? false)) return;

    BranchesRepository(branchesDataProvider: BranchesDataProvider())
        .fetchBranches()
        .then((b) {
      if (mounted) setState(() => _branches = b);
    }).catchError((_) {});
    _repo.fetchExpenseTypes().then((t) {
      if (mounted) setState(() => _expenseTypes = t);
    }).catchError((_) {});
    _loadExpenseLinks();
    await Future.wait([_loadCashiersAndPending(), _loadReport()]);
  }

  Future<void> _loadCashiersAndPending() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        _repo.fetchCashiers(),
        _repo.fetchPendingTopups(
          fromDate: cashierApiDate
              .format(DateTime.now().subtract(const Duration(days: 90))),
          toDate: cashierApiDate.format(DateTime.now()),
        ),
      ]);
      if (!mounted) return;
      final pending = results[1] as List<CashierTransaction>;
      for (final c in _approveAmounts.values) {
        c.dispose();
      }
      _approveAmounts
        ..clear()
        ..addEntries(pending.map((t) => MapEntry(
              t.id,
              TextEditingController(text: _plain(t.amount))
                ..addListener(() => setState(() {})),
            )));
      setState(() {
        _cashiers = results[0] as List<Cashier>;
        _pendingTopups = pending;
      });
    } catch (e) {
      if (mounted) setState(() => _error = cashierError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadReport() async {
    setState(() => _loadingReport = true);
    try {
      final r = await _repo.fetchReport(
        branchId: _filter.branchId,
        type: _filter.type,
        status: _filter.status,
        expenseTypeId: _filter.expenseTypeId,
        fromDate: cashierApiDate.format(_filter.from),
        toDate: cashierApiDate.format(_filter.to),
      );
      if (mounted) setState(() => _report = r);
    } catch (e) {
      _snack(cashierError(e), color: BrandColors.danger);
    } finally {
      if (mounted) setState(() => _loadingReport = false);
    }
  }

  Future<void> _loadExpenseLinks() async {
    try {
      final l = await _repo.fetchExpenseLinks();
      if (mounted) setState(() => _expenseLinks = l);
    } catch (_) {}
  }

  Future<void> _refreshAll() async {
    await Future.wait([
      _loadCashiersAndPending(),
      _loadReport(),
      _loadExpenseLinks(),
    ]);
  }

  /// Runs an HQ action on [id], shows [success] and reloads.
  Future<bool> _run(int id, Future<void> Function() action, String success) async {
    setState(() => _busyId = id);
    try {
      await action();
      _snack(success, color: BrandColors.success);
      await _refreshAll();
      return true;
    } catch (e) {
      _snack(cashierError(e), color: BrandColors.danger);
      return false;
    } finally {
      if (mounted) setState(() => _busyId = null);
    }
  }

  String _plain(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString();

  // --------------------------------------------------------- create cashier

  Cashier? get _existingForBranch => _formBranch == null
      ? null
      : _cashiers.where((c) => c.branchId == _formBranch!.id).firstOrNull;

  Future<void> _selectFormBranch() async {
    final b = (await _pickFrom<BranchesModel>(
      title: 'Branch',
      items: _branches,
      label: (b) => b.name,
    ))
        ?.value;
    if (b == null || b.id == _formBranch?.id) return;
    setState(() {
      _formBranch = b;
      _formUser = null;
      _branchUsers = [];
      _loadingUsers = true;
    });
    try {
      final users = await _repo.fetchBranchUsers(b.id);
      if (mounted) setState(() => _branchUsers = users);
    } catch (e) {
      _snack(cashierError(e), color: BrandColors.danger);
    } finally {
      if (mounted) setState(() => _loadingUsers = false);
    }
  }

  Future<void> _selectFormUser() async {
    final u = (await _pickFrom<BranchUser>(
      title: 'User',
      items: _branchUsers,
      label: (u) => u.label,
    ))
        ?.value;
    if (u != null) setState(() => _formUser = u);
  }

  Future<void> _saveCashier() async {
    final branch = _formBranch;
    final user = _formUser;
    if (branch == null || user == null) return;
    setState(() => _saving = true);
    try {
      await _repo.saveCashier(
        branchId: branch.id,
        userId: user.id,
        dailyLimit: double.tryParse(_limitCtrl.text.trim()),
      );
      _snack('Cashier saved', color: BrandColors.success);
      setState(() {
        _formBranch = null;
        _formUser = null;
        _branchUsers = [];
        _limitCtrl.clear();
      });
      await _loadCashiersAndPending();
    } catch (e) {
      _snack(cashierError(e), color: BrandColors.danger);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // ---------------------------------------------------------------- dialogs

  Future<void> _openTopupDialog(Cashier cashier) async {
    final created = await showDialog<CashierTransaction>(
      context: context,
      builder: (_) => _TopupDialog(cashier: cashier, repo: _repo),
    );
    if (created != null) {
      _snack('Top-up created. Approve it under "Top-up requests" to credit '
          'the cashier.', color: BrandColors.success);
      await _loadCashiersAndPending();
    }
  }

  Future<void> _openLimitDialog(Cashier cashier) async {
    final ctrl = TextEditingController(
        text: cashier.dailyLimit != null && cashier.dailyLimit! > 0
            ? _plain(cashier.dailyLimit!)
            : '');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Daily limit · ${cashier.userName ?? ''}'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: cashierInputDecoration(ctx, 'Daily limit (ETB)')
              .copyWith(helperText: 'Empty or 0 = no limit'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Close')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Save')),
        ],
      ),
    );
    final value = double.tryParse(ctrl.text.trim()) ?? 0;
    ctrl.dispose();
    if (ok == true) {
      await _run(cashier.id, () => _repo.updateDailyLimit(cashier.id, value),
          'Daily limit updated');
    }
  }

  Future<void> _confirmRemove(Cashier cashier) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove cashier?'),
        content: Text(
            '${cashier.userName ?? 'This cashier'} (${cashier.branchName}) '
            'will no longer be able to pay expenses.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Back')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: BrandColors.danger),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await _run(cashier.id, () => _repo.deactivateCashier(cashier.id),
          'Cashier removed');
    }
  }

  Future<void> _openRejectDialog(CashierTransaction t) async {
    final ctrl = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text(
              'Reject request of ${cashierMoney.format(t.requestedAmount ?? t.amount)} ETB?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${t.cashierName ?? ''} · ${t.branchName ?? ''}'),
              const SizedBox(height: 12),
              TextField(
                controller: ctrl,
                autofocus: true,
                minLines: 2,
                maxLines: 4,
                onChanged: (_) => setLocal(() {}),
                decoration: cashierInputDecoration(
                    ctx, 'Reason (the cashier will see this)'),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Close')),
            FilledButton(
              style:
                  FilledButton.styleFrom(backgroundColor: BrandColors.danger),
              onPressed: ctrl.text.trim().isEmpty
                  ? null
                  : () => Navigator.pop(ctx, ctrl.text.trim()),
              child: const Text('Reject'),
            ),
          ],
        ),
      ),
    );
    ctrl.dispose();
    if (reason != null) {
      await _run(t.id, () => _repo.rejectTopup(t.id, reason), 'Request rejected');
    }
  }

  Future<void> _approve(CashierTransaction t) async {
    final amount =
        double.tryParse(_approveAmounts[t.id]?.text.trim() ?? '') ?? 0;
    if (amount <= 0) return;
    await _run(
      t.id,
      () => _repo.confirmTopup(t.id,
          amount: amount != t.amount ? amount : null),
      'Approved ${cashierMoney.format(amount)} ETB',
    );
  }

  Future<void> _openResolveDialog(CashierTransaction p) async {
    final done = await showDialog<String>(
      context: context,
      builder: (_) => _ResolvePayoutDialog(payout: p, repo: _repo),
    );
    if (done != null) {
      _snack(done, color: BrandColors.success);
      await _refreshAll();
    }
  }

  void _openStatement(Cashier cashier) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _CashierStatementScreen(cashier: cashier, repo: _repo),
      ),
    );
  }

  /// Returns null when dismissed, otherwise the picked item (which may itself
  /// be null for "All" entries).
  Future<_Picked<T>?> _pickFrom<T>({
    required String title,
    required List<T> items,
    required String Function(T) label,
  }) {
    return showModalBottomSheet<_Picked<T>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.palette.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _SearchPickerSheet<T>(
        title: title,
        items: items,
        label: label,
      ),
    );
  }

  // --------------------------------------------------------------------- UI

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isHq = _profile?.isHq ?? false;
    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: palette.appBarBackground,
        foregroundColor: palette.textPrimary,
        title: Text(
          'Branch Cashiers',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: palette.textPrimary),
        ),
        actions: [
          if (isHq)
            IconButton(
              tooltip: 'Refresh',
              icon: const Icon(Icons.refresh),
              onPressed: _loading ? null : _refreshAll,
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final profile = _profile;
    if (profile == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!profile.isHq) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: CashierBanner(
            tone: StatusTone.warning,
            text: _error ?? 'Only HQ finance can manage cashiers.',
          ),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _refreshAll,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          if (!profile.payoutEnabled)
            const CashierBanner(
              tone: StatusTone.info,
              text: 'QPay payouts are switched off for now. Cashiers and '
                  'top-ups work; cashiers can pay expenses once QPay '
                  'outgoing transfers are enabled.',
            ),
          if (_error != null)
            CashierBanner(tone: StatusTone.danger, text: _error!),
          _buildCreateCard(),
          if (_pendingTopups.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildPendingCard(),
          ],
          const SizedBox(height: 16),
          _buildCashiersCard(),
          const SizedBox(height: 16),
          _buildReportCard(),
          if (_expenseLinks.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildExpenseLinksCard(),
          ],
        ],
      ),
    );
  }

  Widget _buildCreateCard() {
    final existing = _existingForBranch;
    return CashierSectionCard(
      title: 'Create / change cashier',
      subtitle:
          'One active cashier per branch. Pick the branch, then one of its users.',
      children: [
        CashierPickerField(
          label: 'Branch',
          value: _formBranch?.name,
          loading: _branches.isEmpty,
          onTap: _branches.isEmpty ? null : _selectFormBranch,
        ),
        const SizedBox(height: 12),
        CashierPickerField(
          label: 'User',
          value: _formUser?.label,
          loading: _loadingUsers,
          onTap: _formBranch == null || _branchUsers.isEmpty
              ? null
              : _selectFormUser,
        ),
        if (_formBranch != null && !_loadingUsers && _branchUsers.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text('No active users in this branch',
                style: TextStyle(
                    fontSize: 12, color: context.palette.textSecondary)),
          ),
        const SizedBox(height: 12),
        TextField(
          controller: _limitCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: cashierInputDecoration(context, 'Daily limit (ETB)')
              .copyWith(helperText: 'Empty = no limit'),
        ),
        const SizedBox(height: 12),
        if (existing != null)
          CashierBanner(
            tone: StatusTone.warning,
            text: '${existing.branchName} already has cashier '
                '${existing.userName ?? ''} (balance '
                '${cashierMoney.format(existing.balance)}). Replacing is only '
                'allowed when that balance is 0.',
          ),
        SizedBox(
          height: 46,
          child: FilledButton(
            onPressed: _formBranch == null || _formUser == null || _saving
                ? null
                : _saveCashier,
            child: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : Text(existing != null ? 'Replace cashier' : 'Create cashier'),
          ),
        ),
      ],
    );
  }

  Widget _buildPendingCard() {
    final palette = context.palette;
    return CashierSectionCard(
      title: 'Top-up requests & waiting confirmation (${_pendingTopups.length})',
      subtitle: 'Approving moves the amount from the HQ account to the branch '
          'and credits the cashier. You can change the amount before '
          'approving.',
      children: _pendingTopups.map((t) {
        final ctrl = _approveAmounts[t.id]!;
        final valid = (double.tryParse(ctrl.text.trim()) ?? 0) > 0;
        final busy = _busyId == t.id;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: palette.surfaceMuted,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.branchName ?? '-',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: palette.textPrimary)),
                        Text(
                          [
                            if (t.cashierName != null) t.cashierName!,
                            if (t.createdAt != null)
                              cashierDateTime.format(t.createdAt!),
                          ].join(' · '),
                          style: TextStyle(
                              fontSize: 12, color: palette.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  t.isRequest
                      ? const StatusChip(
                          label: 'Cashier request',
                          tone: StatusTone.warning,
                          compact: true)
                      : StatusChip(
                          label: 'HQ · ${t.createdBy ?? ''}',
                          tone: StatusTone.neutral,
                          compact: true),
                ],
              ),
              if (t.isRequest) ...[
                const SizedBox(height: 6),
                Text(
                    'Requested ${cashierMoney.format(t.requestedAmount ?? t.amount)} ETB',
                    style: TextStyle(color: palette.textPrimary)),
              ],
              if (t.description != null)
                Text(t.description!,
                    style: TextStyle(
                        fontSize: 12, color: palette.textSecondary)),
              const SizedBox(height: 10),
              TextField(
                controller: ctrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: cashierInputDecoration(
                        context, 'Amount to approve (ETB)')
                    .copyWith(errorText: valid ? null : 'Enter an amount'),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (t.isRequest)
                    TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: BrandColors.danger),
                      onPressed: busy ? null : () => _openRejectDialog(t),
                      child: const Text('Reject'),
                    )
                  else
                    TextButton(
                      onPressed: busy
                          ? null
                          : () => _run(t.id, () => _repo.cancelTopup(t.id),
                              'Top-up cancelled'),
                      child: const Text('Cancel'),
                    ),
                  const SizedBox(width: 8),
                  FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: BrandColors.success),
                    onPressed: busy || !valid ? null : () => _approve(t),
                    child: busy
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Text('Approve'),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCashiersCard() {
    final palette = context.palette;
    return CashierSectionCard(
      title: 'Active cashiers',
      children: [
        if (_loading && _cashiers.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_cashiers.isEmpty)
          Text('No cashiers yet.',
              style: TextStyle(color: palette.textSecondary))
        else
          ..._cashiers.map((c) {
            final busy = _busyId == c.id;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: palette.surfaceMuted,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c.branchName,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: palette.textPrimary)),
                            Text(
                              [
                                if (c.userName != null) c.userName!,
                                if (c.phone != null) c.phone!,
                              ].join(' · '),
                              style: TextStyle(
                                  fontSize: 12, color: palette.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        cashierMoney.format(c.balance),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: palette.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Daily limit ${c.dailyLimit != null && c.dailyLimit! > 0 ? cashierMoney.format(c.dailyLimit) : 'none'}'
                    ' · paid today ${cashierMoney.format(c.paidToday)}',
                    style:
                        TextStyle(fontSize: 12, color: palette.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    alignment: WrapAlignment.end,
                    children: [
                      FilledButton.tonal(
                        onPressed: busy ? null : () => _openTopupDialog(c),
                        child: const Text('Top up'),
                      ),
                      TextButton(
                        onPressed: busy ? null : () => _openLimitDialog(c),
                        child: const Text('Limit'),
                      ),
                      TextButton(
                        onPressed: () => _openStatement(c),
                        child: const Text('Statement'),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: BrandColors.danger),
                        // Server only allows removing an empty wallet.
                        onPressed: busy || c.balance > 0
                            ? null
                            : () => _confirmRemove(c),
                        child: const Text('Remove'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _buildReportCard() {
    final r = _report;
    final palette = context.palette;
    final branchName = _filter.branchId == null
        ? 'All branches'
        : _branches
                .where((b) => b.id == _filter.branchId)
                .map((b) => b.name)
                .firstOrNull ??
            'Branch ${_filter.branchId}';
    final typeName = _expenseTypes
            .where((t) => t.id == _filter.expenseTypeId)
            .map((t) => t.description.isNotEmpty ? t.description : t.code)
            .firstOrNull ??
        'All types';

    return CashierSectionCard(
      title: 'Cashier report',
      children: [
        CashierPickerField(
          label: 'Branch',
          value: branchName,
          onTap: () async {
            final picked = await _pickFrom<BranchesModel?>(
              title: 'Branch',
              items: [null, ..._branches],
              label: (b) => b?.name ?? 'All branches',
            );
            if (!mounted || picked == null) return;
            setState(() => _filter.branchId = picked.value?.id);
          },
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                key: ValueKey('type-${_filter.type}'),
                initialValue: _filter.type,
                isExpanded: true,
                decoration: cashierInputDecoration(context, 'Type'),
                items: const [
                  DropdownMenuItem(value: '', child: Text('All')),
                  DropdownMenuItem(value: 'TOPUP', child: Text('Top-ups')),
                  DropdownMenuItem(value: 'PAYOUT', child: Text('Payouts')),
                ],
                onChanged: (v) => setState(() => _filter.type = v ?? ''),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<String>(
                key: ValueKey('status-${_filter.status}'),
                initialValue: _filter.status,
                isExpanded: true,
                decoration: cashierInputDecoration(context, 'Status'),
                items: [
                  const DropdownMenuItem(value: '', child: Text('All')),
                  ..._statuses.map((s) => DropdownMenuItem(
                      value: s,
                      child: Text(s, overflow: TextOverflow.ellipsis))),
                ],
                onChanged: (v) => setState(() => _filter.status = v ?? ''),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        CashierPickerField(
          label: 'Expense type',
          value: typeName,
          onTap: () async {
            final picked = await _pickFrom<CashierExpenseType?>(
              title: 'Expense type',
              items: [null, ..._expenseTypes],
              label: (t) => t?.label ?? 'All types',
            );
            if (!mounted || picked == null) return;
            setState(() => _filter.expenseTypeId = picked.value?.id);
          },
        ),
        const SizedBox(height: 12),
        CashierDateRange(
          from: _filter.from,
          to: _filter.to,
          onFrom: (d) => setState(() => _filter.from = d),
          onTo: (d) => setState(() => _filter.to = d),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: _loadingReport ? null : _loadReport,
          child: const Text('Apply'),
        ),
        const SizedBox(height: 12),
        if (r != null) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatusChip(
                  label: 'Top-ups ${cashierMoney.format(r.topups)}',
                  tone: StatusTone.success),
              StatusChip(
                  label:
                      'Waiting confirmation ${cashierMoney.format(r.pendingTopups)}',
                  tone: StatusTone.warning),
              StatusChip(
                  label: 'Paid out ${cashierMoney.format(r.paid)}',
                  tone: StatusTone.danger),
              StatusChip(
                  label: 'Unresolved ${cashierMoney.format(r.unresolved)}',
                  tone: StatusTone.warning),
              StatusChip(
                  label:
                      'Wallet balances now ${cashierMoney.format(r.walletBalances)}',
                  tone: StatusTone.brand),
            ],
          ),
          if (r.byExpenseType.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text('Paid by expense type:',
                style: TextStyle(fontSize: 12, color: palette.textSecondary)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: r.byExpenseType
                  .map((t) => StatusChip(
                      label:
                          '${t.expenseType} ${cashierMoney.format(t.amount)}',
                      tone: StatusTone.neutral,
                      compact: true))
                  .toList(),
            ),
          ],
          const SizedBox(height: 12),
        ],
        if (_loadingReport)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (r == null || r.entries.isEmpty)
          Text('No transactions for these filters',
              textAlign: TextAlign.center,
              style: TextStyle(color: palette.textSecondary))
        else
          ...r.entries.map((e) => CashierTransactionTile(
                entry: e,
                showCashier: true,
                action: e.needsResolve
                    ? OutlinedButton(
                        onPressed: () => _openResolveDialog(e),
                        child: const Text('Resolve'),
                      )
                    : null,
              )),
      ],
    );
  }

  Widget _buildExpenseLinksCard() {
    final palette = context.palette;
    return CashierSectionCard(
      title: 'Expenses paid via QPay (${_expenseLinks.length})',
      subtitle: 'Expenses recorded automatically from cashier payouts.',
      children: _expenseLinks.map((l) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: palette.surfaceMuted,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Expense #${l.expenseId}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: palette.textPrimary)),
                    Text(
                      [
                        if (l.paidAt != null) cashierDateTime.format(l.paidAt!),
                        if (l.branchName != null) l.branchName!,
                        if (l.cashierName != null) l.cashierName!,
                      ].join(' · '),
                      style: TextStyle(
                          fontSize: 12, color: palette.textSecondary),
                    ),
                    Text(
                      [
                        l.accountName ?? l.accountNumber ?? '',
                        if (l.bankName != null) l.bankName!,
                        if (l.payee != null) l.payee!,
                      ].where((e) => e.isNotEmpty).join(' · '),
                      style: TextStyle(
                          fontSize: 12, color: palette.textSecondary),
                    ),
                  ],
                ),
              ),
              const StatusChip(
                  label: 'QPay', tone: StatusTone.info, compact: true),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ----------------------------------------------------------------- dialogs

class _TopupDialog extends StatefulWidget {
  final Cashier cashier;
  final CashierPayRepository repo;

  const _TopupDialog({required this.cashier, required this.repo});

  @override
  State<_TopupDialog> createState() => _TopupDialogState();
}

class _TopupDialogState extends State<_TopupDialog> {
  final _amount = TextEditingController();
  final _note = TextEditingController();
  CashierFunding? _funding;
  bool _fundingError = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _amount.addListener(() => setState(() {}));
    widget.repo.fetchFunding().then((f) {
      if (mounted) setState(() => _funding = f);
    }).catchError((_) {
      if (mounted) setState(() => _fundingError = true);
    });
  }

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    setState(() => _saving = true);
    try {
      final t = await widget.repo.createTopup(
        cashierId: widget.cashier.id,
        amount: _amount.text.trim(),
        description: _note.text.trim(),
      );
      if (mounted) Navigator.pop(context, t);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(cashierError(e)),
        backgroundColor: BrandColors.danger,
      ));
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.cashier;
    final amount = double.tryParse(_amount.text.trim()) ?? 0;
    final f = _funding;
    final exceeds = f != null && f.wouldExceedQpay(amount);
    return AlertDialog(
      title: Text('Top up ${c.userName ?? ''} (${c.branchName})'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Current balance: ${cashierMoney.format(c.balance)}'),
            const SizedBox(height: 12),
            if (f == null && !_fundingError)
              const LinearProgressIndicator()
            else if (f != null)
              CashierBanner(
                tone: exceeds ? StatusTone.warning : StatusTone.info,
                text: [
                  'QPay wallet (real money): '
                      '${f.qpayBalance == null ? '-' : cashierMoney.format(f.qpayBalance)}',
                  'HQ ledger balance (branch digital settlements): '
                      '${cashierMoney.format(f.hqLedgerBalance)}',
                  'Already in cashier wallets: '
                      '${cashierMoney.format(f.cashierWallets)}'
                      '${f.unresolvedPayouts > 0 ? ' · unresolved payouts ${cashierMoney.format(f.unresolvedPayouts)}' : ''}',
                  if (exceeds)
                    'Cashier wallets would exceed the QPay balance - payouts '
                        'may fail.',
                ].join('\n'),
              ),
            const SizedBox(height: 4),
            TextField(
              controller: _amount,
              autofocus: true,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: cashierInputDecoration(context, 'Amount (ETB)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _note,
              minLines: 2,
              maxLines: 3,
              decoration: cashierInputDecoration(context, 'Note'),
            ),
            const SizedBox(height: 12),
            const CashierBanner(
              tone: StatusTone.info,
              text: 'After creating, approve the top-up under "Top-up '
                  'requests & waiting confirmation". Only then is the '
                  'cashier credited.',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('Close'),
        ),
        FilledButton(
          onPressed: amount > 0 && !_saving ? _create : null,
          child: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
              : const Text('Create top-up'),
        ),
      ],
    );
  }
}

class _ResolvePayoutDialog extends StatefulWidget {
  final CashierTransaction payout;
  final CashierPayRepository repo;

  const _ResolvePayoutDialog({required this.payout, required this.repo});

  @override
  State<_ResolvePayoutDialog> createState() => _ResolvePayoutDialogState();
}

class _ResolvePayoutDialogState extends State<_ResolvePayoutDialog> {
  final _ref = TextEditingController();
  bool _checking = false;
  PayoutStatusResult? _status;
  String? _statusError;
  bool _saving = false;

  @override
  void dispose() {
    _ref.dispose();
    super.dispose();
  }

  Future<void> _check() async {
    setState(() {
      _checking = true;
      _statusError = null;
    });
    try {
      final s = await widget.repo.checkPayoutStatus(widget.payout.id);
      if (!mounted) return;
      setState(() => _status = s);
      if (s.qpayReference != null && _ref.text.isEmpty) {
        _ref.text = s.qpayReference!;
      }
    } catch (e) {
      if (mounted) setState(() => _statusError = cashierError(e));
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  Future<void> _resolve(bool sent) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(sent ? 'Mark as sent?' : 'Refund the cashier?'),
        content: Text(sent
            ? 'The payout will be recorded as an expense.'
            : 'The amount goes back to the cashier wallet. Only do this if '
                'QPay did not send the money.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Back')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Confirm')),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _saving = true);
    try {
      await widget.repo.resolvePayout(widget.payout.id,
          sent: sent, qpayReference: _ref.text.trim());
      if (mounted) {
        Navigator.pop(
            context,
            sent
                ? 'Marked as sent and recorded in expenses'
                : 'Marked as not sent; amount returned to cashier');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(cashierError(e)),
        backgroundColor: BrandColors.danger,
      ));
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.payout;
    return AlertDialog(
      title: Text('Resolve payout of ${cashierMoney.format(p.amount)}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CashierBanner(
              tone: StatusTone.warning,
              text: 'QPay did not give a clear answer. Check the QPay '
                  'portal/statement for reference '
                  '${p.partnerReference ?? p.reference ?? '-'} before deciding.',
            ),
            Text(
              '${p.cashierName ?? ''} → ${p.accountName ?? ''} · '
              '${p.bankName ?? p.bankCode ?? ''} ${p.accountNumber ?? ''}',
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _checking ? null : _check,
              child: _checking
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Check status with QPay'),
            ),
            const SizedBox(height: 8),
            if (_statusError != null)
              CashierBanner(tone: StatusTone.danger, text: _statusError!)
            else if (_status != null)
              CashierBanner(
                tone: StatusTone.info,
                text: 'QPay status: ${_status!.qpayStatus ?? 'not returned'}'
                    '${_status!.qpayReference != null ? ' · ref ${_status!.qpayReference}' : ''}',
              ),
            TextField(
              controller: _ref,
              decoration:
                  cashierInputDecoration(context, 'QPay reference (if sent)'),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('Close'),
        ),
        Wrap(
          spacing: 4,
          children: [
            TextButton(
              style:
                  TextButton.styleFrom(foregroundColor: BrandColors.danger),
              onPressed: _saving ? null : () => _resolve(false),
              child: const Text('Not sent - refund'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: BrandColors.success),
              onPressed: _saving ? null : () => _resolve(true),
              child: const Text('Money was sent'),
            ),
          ],
        ),
      ],
    );
  }
}

class _CashierStatementScreen extends StatefulWidget {
  final Cashier cashier;
  final CashierPayRepository repo;

  const _CashierStatementScreen({required this.cashier, required this.repo});

  @override
  State<_CashierStatementScreen> createState() =>
      _CashierStatementScreenState();
}

class _CashierStatementScreenState extends State<_CashierStatementScreen> {
  DateTime _from = DateTime.now().subtract(const Duration(days: 30));
  DateTime _to = DateTime.now();
  CashierStatement? _statement;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final s = await widget.repo.fetchStatement(
        cashierId: widget.cashier.id,
        fromDate: cashierApiDate.format(_from),
        toDate: cashierApiDate.format(_to),
      );
      if (mounted) setState(() => _statement = s);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(cashierError(e)),
        backgroundColor: BrandColors.danger,
      ));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final c = widget.cashier;
    final s = _statement;
    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: palette.appBarBackground,
        foregroundColor: palette.textPrimary,
        title: Text('Statement · ${c.userName ?? ''} (${c.branchName})',
            style: TextStyle(color: palette.textPrimary, fontSize: 17)),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CashierDateRange(
              from: _from,
              to: _to,
              onFrom: (d) {
                setState(() => _from = d);
                _load();
              },
              onTo: (d) {
                setState(() => _to = d);
                _load();
              },
            ),
            const SizedBox(height: 12),
            if (s != null)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  StatusChip(
                      label: 'Top-ups ${cashierMoney.format(s.topups)}',
                      tone: StatusTone.success),
                  StatusChip(
                      label: 'Paid ${cashierMoney.format(s.paid)}',
                      tone: StatusTone.danger),
                  if (s.unresolved > 0)
                    StatusChip(
                        label:
                            'Unresolved ${cashierMoney.format(s.unresolved)}',
                        tone: StatusTone.warning),
                  StatusChip(
                      label: 'Remaining ${cashierMoney.format(s.balance)}',
                      tone: StatusTone.brand),
                ],
              ),
            const SizedBox(height: 12),
            if (_loading)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (s == null || s.entries.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Text('No transactions in this period',
                      style: TextStyle(color: palette.textSecondary)),
                ),
              )
            else
              ...s.entries.map((e) => CashierTransactionTile(entry: e)),
          ],
        ),
      ),
    );
  }
}

class _Picked<T> {
  final T value;
  const _Picked(this.value);
}

class _SearchPickerSheet<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final String Function(T) label;

  const _SearchPickerSheet({
    super.key,
    required this.title,
    required this.items,
    required this.label,
  });

  @override
  State<_SearchPickerSheet<T>> createState() => _SearchPickerSheetState<T>();
}

class _SearchPickerSheetState<T> extends State<_SearchPickerSheet<T>> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final q = _q.toLowerCase();
    final items = widget.items
        .where((i) => q.isEmpty || widget.label(i).toLowerCase().contains(q))
        .toList();
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, controller) => Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: palette.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) => setState(() => _q = v),
              decoration: InputDecoration(
                hintText: 'Search ${widget.title.toLowerCase()}',
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                filled: true,
                fillColor: palette.surfaceMuted,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: controller,
              itemCount: items.length,
              itemBuilder: (_, i) => ListTile(
                dense: true,
                title: Text(widget.label(items[i]),
                    style: TextStyle(color: palette.textPrimary)),
                onTap: () => Navigator.pop(context, _Picked(items[i])),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
