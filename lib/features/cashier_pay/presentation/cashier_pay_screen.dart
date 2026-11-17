import 'package:courier_app/core/theme/app_palette.dart';
import 'package:courier_app/core/widgets/status_chip.dart';
import 'package:courier_app/features/cashier_pay/data/cashier_pay_models.dart';
import 'package:courier_app/features/cashier_pay/data/cashier_pay_repository.dart';
import 'package:courier_app/features/cashier_pay/presentation/cashier_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Branch cashier: wallet balance, pay expenses through QPay, request top-ups
/// from HQ finance and view the wallet statement.
class CashierPayScreen extends StatefulWidget {
  final CashierPayRepository? repository;

  const CashierPayScreen({super.key, this.repository});

  @override
  State<CashierPayScreen> createState() => _CashierPayScreenState();
}

class _CashierPayScreenState extends State<CashierPayScreen> {
  late final CashierPayRepository _repo =
      widget.repository ?? CashierPayRepository();

  final _money = cashierMoney;
  final _apiDate = cashierApiDate;
  final _dateTime = cashierDateTime;

  // Profile / reference data
  CashierProfile? _profile;
  String? _profileError;
  List<PayoutBank> _banks = [];
  List<CashierExpenseType> _expenseTypes = [];

  // Payment form
  PayoutBank? _bank;
  CashierExpenseType? _expenseType;
  final _accountCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _payeeCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  String _accountName = '';
  String _lookupToken = '';
  double? _fee;
  bool _checking = false;
  bool _sending = false;
  CashierTransaction? _lastPayout;

  // Top-up request
  final _topupAmountCtrl = TextEditingController();
  final _topupReasonCtrl = TextEditingController();
  bool _requestingTopup = false;
  List<CashierTransaction> _topupRequests = [];

  // Statement
  DateTime _fromDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _toDate = DateTime.now();
  CashierStatement? _statement;
  bool _loadingStatement = false;

  Cashier? get _cashier => _profile?.cashier;

  @override
  void initState() {
    super.initState();
    for (final c in [_amountCtrl, _payeeCtrl, _descriptionCtrl]) {
      c.addListener(_rebuild);
    }
    _accountCtrl.addListener(_onAccountChanged);
    _topupAmountCtrl.addListener(_rebuild);
    _topupReasonCtrl.addListener(_rebuild);
    _loadAll();
  }

  @override
  void dispose() {
    for (final c in [
      _accountCtrl,
      _amountCtrl,
      _payeeCtrl,
      _descriptionCtrl,
      _topupAmountCtrl,
      _topupReasonCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  String _lastAccount = '';
  void _onAccountChanged() {
    // Changing the account invalidates the previous QPay check.
    if (_accountCtrl.text != _lastAccount) {
      _lastAccount = _accountCtrl.text;
      _clearLookup();
    }
    _rebuild();
  }

  void _clearLookup() {
    _accountName = '';
    _lookupToken = '';
    _fee = null;
  }

  String _err(Object e) => cashierError(e);

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

  // ---------------------------------------------------------------- loading

  Future<void> _loadAll() async {
    await _loadProfile();
    _repo.fetchBanks().then((b) {
      if (mounted) setState(() => _banks = b);
    }).catchError((_) {});
    _repo.fetchExpenseTypes().then((t) {
      if (mounted) setState(() => _expenseTypes = t);
    }).catchError((_) {});
    if (_cashier != null) {
      await Future.wait([_loadStatement(), _loadTopupRequests()]);
    }
  }

  Future<void> _loadProfile() async {
    try {
      final p = await _repo.fetchMe();
      if (!mounted) return;
      setState(() {
        _profile = p;
        _profileError = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _profile = const CashierProfile(
            isCashier: false, isHq: false, payoutEnabled: false);
        _profileError = _err(e);
      });
    }
  }

  Future<void> _loadStatement() async {
    final cashier = _cashier;
    if (cashier == null) return;
    setState(() => _loadingStatement = true);
    try {
      final s = await _repo.fetchStatement(
        cashierId: cashier.id,
        fromDate: _apiDate.format(_fromDate),
        toDate: _apiDate.format(_toDate),
      );
      if (mounted) setState(() => _statement = s);
    } catch (e) {
      _snack(_err(e), color: BrandColors.danger);
    } finally {
      if (mounted) setState(() => _loadingStatement = false);
    }
  }

  Future<void> _loadTopupRequests() async {
    try {
      final r = await _repo.fetchMyTopupRequests();
      if (mounted) setState(() => _topupRequests = r);
    } catch (_) {
      if (mounted) setState(() => _topupRequests = []);
    }
  }

  Future<void> _refresh() async {
    await _loadProfile();
    await Future.wait([_loadStatement(), _loadTopupRequests()]);
  }

  // ---------------------------------------------------------------- actions

  Future<void> _checkAccount() async {
    final bank = _bank;
    final account = _accountCtrl.text.trim();
    if (bank == null || account.isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() => _checking = true);
    try {
      final r = await _repo.lookupAccount(bank: bank, accountNumber: account);
      if (!mounted) return;
      setState(() {
        _accountName = r.accountName ?? _accountName;
        _lookupToken = r.lookupToken ?? '';
        _fee = r.fee;
      });
      if (r.accountName != null) {
        _snack('Account holder: ${r.accountName}', color: BrandColors.success);
      } else {
        _snack('QPay did not return a name for this account.');
      }
    } catch (e) {
      _snack(_err(e), color: BrandColors.danger);
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  double get _amount => double.tryParse(_amountCtrl.text.trim()) ?? 0;
  bool get _overBalance => _amount > (_cashier?.balance ?? 0);
  bool get _overLimit {
    final left = _cashier?.leftToday;
    return left != null && _amount > left;
  }

  bool get _canReview =>
      (_profile?.payoutEnabled ?? false) &&
      _bank != null &&
      _accountCtrl.text.trim().isNotEmpty &&
      _lookupToken.isNotEmpty &&
      _amount > 0 &&
      _expenseType != null &&
      _payeeCtrl.text.trim().isNotEmpty &&
      _descriptionCtrl.text.trim().isNotEmpty &&
      !_overBalance &&
      !_overLimit &&
      !_sending;

  Future<void> _reviewAndSend() async {
    FocusScope.of(context).unfocus();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => _ConfirmPayoutDialog(
        amount: _money.format(_amount),
        accountName: _accountName,
        bankName: _bank!.name,
        accountNumber: _accountCtrl.text.trim(),
        fee: _fee,
        expenseType: _expenseType!.description.isNotEmpty
            ? _expenseType!.description
            : _expenseType!.code,
        payee: _payeeCtrl.text.trim(),
        description: _descriptionCtrl.text.trim(),
        money: _money,
      ),
    );
    if (confirmed == true) await _send();
  }

  Future<void> _send() async {
    setState(() => _sending = true);
    try {
      final result = await _repo.sendPayout(PayoutRequest(
        bank: _bank!,
        accountNumber: _accountCtrl.text.trim(),
        accountName: _accountName,
        amount: _amountCtrl.text.trim(),
        description: _descriptionCtrl.text.trim(),
        lookupToken: _lookupToken,
        expenseTypeId: _expenseType!.id,
        payee: _payeeCtrl.text.trim(),
      ));
      if (!mounted) return;
      setState(() => _lastPayout = result);
      if (result.isSuccess) {
        _snack('Payment sent and recorded in expenses',
            color: BrandColors.success);
        _resetForm();
      } else if (result.isFailed) {
        _snack('QPay rejected the payment. Your balance was not charged.',
            color: BrandColors.danger);
      } else {
        _snack('QPay has not confirmed yet. HQ finance will check it.',
            color: BrandColors.warning);
      }
    } catch (e) {
      _snack(_err(e), color: BrandColors.danger);
    } finally {
      if (mounted) setState(() => _sending = false);
      await _refresh();
    }
  }

  void _resetForm() {
    _lastAccount = '';
    _accountCtrl.clear();
    _amountCtrl.clear();
    _payeeCtrl.clear();
    _descriptionCtrl.clear();
    _bank = null;
    _expenseType = null;
    _clearLookup();
  }

  Future<void> _sendTopupRequest() async {
    FocusScope.of(context).unfocus();
    setState(() => _requestingTopup = true);
    try {
      await _repo.requestTopup(
        amount: _topupAmountCtrl.text.trim(),
        reason: _topupReasonCtrl.text.trim(),
      );
      _snack('Request sent to HQ finance', color: BrandColors.success);
      _topupAmountCtrl.clear();
      _topupReasonCtrl.clear();
      await _loadTopupRequests();
    } catch (e) {
      _snack(_err(e), color: BrandColors.danger);
    } finally {
      if (mounted) setState(() => _requestingTopup = false);
    }
  }

  Future<void> _pickBank() async {
    final picked = await showModalBottomSheet<PayoutBank>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.palette.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _BankPickerSheet(banks: _banks, selected: _bank),
    );
    if (picked != null && picked.code != _bank?.code) {
      setState(() {
        _bank = picked;
        _clearLookup();
      });
    }
  }

  // ---------------------------------------------------------------- UI

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: palette.appBarBackground,
        foregroundColor: palette.textPrimary,
        title: Text(
          'Cashier · Pay expense',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: palette.textPrimary,
          ),
        ),
        actions: [
          if (_cashier != null)
            IconButton(
              tooltip: 'Refresh',
              icon: const Icon(Icons.refresh),
              onPressed: _refresh,
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
    final cashier = profile.cashier;
    if (!profile.isCashier || cashier == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: CashierBanner(
            tone: StatusTone.info,
            text: _profileError ??
                'You are not set up as a branch cashier. Ask HQ finance to '
                    'create a cashier for your branch.',
          ),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          _buildWalletCard(cashier),
          const SizedBox(height: 16),
          _buildPayCard(profile, cashier),
          const SizedBox(height: 16),
          _buildTopupCard(),
          const SizedBox(height: 16),
          _buildStatementCard(),
        ],
      ),
    );
  }

  Widget _buildWalletCard(Cashier cashier) {
    final palette = context.palette;
    final left = cashier.leftToday;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [BrandColors.orangeLight, palette.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WALLET BALANCE · ${cashier.branchName.toUpperCase()}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(children: [
              TextSpan(
                text: _money.format(cashier.balance),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const TextSpan(
                text: '  ETB',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ]),
          ),
          const SizedBox(height: 8),
          Text(
            left == null
                ? 'No daily limit'
                : 'Daily limit ${_money.format(cashier.dailyLimit)} · '
                    'paid today ${_money.format(cashier.paidToday)} · '
                    'left ${_money.format(left)}',
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildPayCard(CashierProfile profile, Cashier cashier) {
    final palette = context.palette;
    final verified = _lookupToken.isNotEmpty;
    String? amountError;
    if (_overBalance) {
      amountError = 'More than your balance - request a top-up below';
    } else if (_overLimit) {
      amountError = "Over today's limit - contact HQ finance";
    }

    return CashierSectionCard(
      title: 'Send payment through QPay',
      children: [
        if (!profile.payoutEnabled)
          const CashierBanner(
            tone: StatusTone.info,
            text: 'QPay payouts are not switched on yet. You can see your '
                'balance and statement; sending will be available soon.',
          ),
        if (cashier.balance <= 0)
          const CashierBanner(
            tone: StatusTone.warning,
            text: 'Your balance is 0. Use "Request top-up from HQ finance" '
                'below.',
          ),
        CashierPickerField(
          label: 'Bank / wallet',
          value: _bank?.name,
          onTap: _banks.isEmpty ? null : _pickBank,
          loading: _banks.isEmpty,
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: _accountCtrl,
                keyboardType: TextInputType.number,
                decoration: _dec('Account / phone number'),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 52,
              child: OutlinedButton(
                onPressed: _bank == null ||
                        _accountCtrl.text.trim().isEmpty ||
                        _checking
                    ? null
                    : _checkAccount,
                child: _checking
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Check'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        InputDecorator(
          decoration: _dec('Recipient name (from Check)').copyWith(
            helperText: verified
                ? 'Verified by QPay'
                : 'Press Check to verify the account before sending',
            helperStyle: TextStyle(
              color: verified ? BrandColors.success : palette.textSecondary,
            ),
            suffixIcon: verified
                ? const Icon(Icons.verified, color: BrandColors.success)
                : null,
          ),
          child: Text(
            _accountName.isEmpty ? '—' : _accountName,
            style: TextStyle(color: palette.textPrimary),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _amountCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: _dec('Amount (ETB)').copyWith(errorText: amountError),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<CashierExpenseType>(
          // Keyed so the field resets when the form is cleared after sending.
          key: ValueKey(_expenseType?.id),
          initialValue: _expenseType,
          isExpanded: true,
          decoration: _dec('Expense type'),
          items: _expenseTypes
              .map((t) => DropdownMenuItem(
                    value: t,
                    child: Text(t.label, overflow: TextOverflow.ellipsis),
                  ))
              .toList(),
          onChanged: (t) => setState(() => _expenseType = t),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _payeeCtrl,
          decoration: _dec('Recipient (who is this payment for?)').copyWith(
            hintText: 'e.g. EEU electricity, landlord, supplier',
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _descriptionCtrl,
          minLines: 2,
          maxLines: 4,
          decoration: _dec('Description'),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton(
            onPressed: _canReview ? _reviewAndSend : null,
            child: _sending
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Review & send'),
          ),
        ),
        if (_lastPayout != null) ...[
          const SizedBox(height: 12),
          _buildPayoutResult(_lastPayout!),
        ],
      ],
    );
  }

  Widget _buildPayoutResult(CashierTransaction p) {
    if (p.isSuccess) {
      return CashierBanner(
        tone: StatusTone.success,
        text: 'Sent ${_money.format(p.amount)} to '
            '${p.accountName ?? p.accountNumber ?? ''}. '
            'Recorded as expense #${p.expenseId ?? '-'}.',
      );
    }
    if (p.isFailed) {
      return CashierBanner(
        tone: StatusTone.danger,
        text: 'Not sent: ${p.failureReason ?? 'rejected by QPay'}. '
            'Your balance was returned.',
      );
    }
    return CashierBanner(
      tone: StatusTone.warning,
      text: 'QPay has not confirmed this payment '
          '(ref ${p.partnerReference ?? p.reference ?? '-'}). '
          'Do not send again - HQ finance will resolve it.',
    );
  }

  Widget _buildTopupCard() {
    final palette = context.palette;
    final pending = _topupRequests
        .any((t) => t.status.toUpperCase() == 'PENDING_CONFIRM');
    final canSend = (double.tryParse(_topupAmountCtrl.text.trim()) ?? 0) > 0 &&
        _topupReasonCtrl.text.trim().isNotEmpty &&
        !_requestingTopup;

    return CashierSectionCard(
      title: 'Request top-up from HQ finance',
      children: [
        if (pending)
          const CashierBanner(
            tone: StatusTone.info,
            text: 'Your request is waiting for HQ finance. You will see the '
                'result below.',
          )
        else ...[
          TextField(
            controller: _topupAmountCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: _dec('Amount (ETB)'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _topupReasonCtrl,
            decoration: _dec('Reason (what is it for?)'),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: FilledButton.tonal(
              onPressed: canSend ? _sendTopupRequest : null,
              child: _requestingTopup
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Send request'),
            ),
          ),
        ],
        if (_topupRequests.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'My top-up requests',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          ..._topupRequests.map(_buildTopupRow),
        ],
      ],
    );
  }

  Widget _buildTopupRow(CashierTransaction t) {
    final palette = context.palette;
    final status = t.status.toUpperCase();
    final StatusChip chip;
    switch (status) {
      case 'PENDING_CONFIRM':
        chip = const StatusChip(
            label: 'Waiting HQ finance', tone: StatusTone.warning, compact: true);
        break;
      case 'CONFIRMED':
        chip = StatusChip(
            label: 'Approved ${_money.format(t.amount)}',
            tone: StatusTone.success,
            compact: true);
        break;
      case 'REJECTED':
        chip = const StatusChip(
            label: 'Rejected', tone: StatusTone.danger, compact: true);
        break;
      default:
        chip = StatusChip.auto(t.status, compact: true);
    }
    final changed = status == 'CONFIRMED' &&
        t.requestedAmount != null &&
        t.requestedAmount != t.amount;
    final secondary = TextStyle(fontSize: 12, color: palette.textSecondary);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.surfaceMuted,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text.rich(TextSpan(
                  style: TextStyle(color: palette.textPrimary),
                  children: [
                    const TextSpan(text: 'Asked '),
                    TextSpan(
                      text: _money.format(t.requestedAmount ?? t.amount),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
              ),
              chip,
            ],
          ),
          const SizedBox(height: 4),
          Text(
            [
              if (t.createdAt != null) _dateTime.format(t.createdAt!),
              if (t.confirmedBy != null && status != 'PENDING_CONFIRM')
                'by ${t.confirmedBy}',
              if (changed) '(HQ changed the amount)',
            ].join(' · '),
            style: secondary,
          ),
          if (status == 'REJECTED' && t.failureReason != null)
            Text(t.failureReason!,
                style: const TextStyle(fontSize: 12, color: BrandColors.danger)),
          if (t.description != null) Text(t.description!, style: secondary),
        ],
      ),
    );
  }

  Widget _buildStatementCard() {
    final s = _statement;
    return CashierSectionCard(
      title: 'My statement',
      children: [
        CashierDateRange(
          from: _fromDate,
          to: _toDate,
          onFrom: (d) {
            setState(() => _fromDate = d);
            _loadStatement();
          },
          onTo: (d) {
            setState(() => _toDate = d);
            _loadStatement();
          },
        ),
        const SizedBox(height: 12),
        if (s != null)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatusChip(
                  label: 'Top-ups ${_money.format(s.topups)}',
                  tone: StatusTone.success),
              StatusChip(
                  label: 'Paid ${_money.format(s.paid)}',
                  tone: StatusTone.danger),
              if (s.unresolved > 0)
                StatusChip(
                    label: 'Unresolved ${_money.format(s.unresolved)}',
                    tone: StatusTone.warning),
              StatusChip(
                  label: 'Remaining ${_money.format(s.balance)}',
                  tone: StatusTone.brand),
            ],
          ),
        const SizedBox(height: 12),
        if (_loadingStatement)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (s == null || s.entries.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                'No transactions in this period',
                style: TextStyle(color: context.palette.textSecondary),
              ),
            ),
          )
        else
          ...s.entries.map((e) => CashierTransactionTile(entry: e)),
      ],
    );
  }

  InputDecoration _dec(String label) => cashierInputDecoration(context, label);
}

// ------------------------------------------------------------------ widgets

class _BankPickerSheet extends StatefulWidget {
  final List<PayoutBank> banks;
  final PayoutBank? selected;

  const _BankPickerSheet({required this.banks, this.selected});

  @override
  State<_BankPickerSheet> createState() => _BankPickerSheetState();
}

class _BankPickerSheetState extends State<_BankPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final q = _query.toLowerCase();
    final filtered = widget.banks
        .where((b) =>
            q.isEmpty ||
            b.name.toLowerCase().contains(q) ||
            b.code.toLowerCase().contains(q))
        .toList();

    final rows = <Widget>[];
    String? lastType;
    for (final b in filtered) {
      if (b.type != lastType) {
        lastType = b.type;
        rows.add(Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            b.type.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w600,
              color: palette.accent,
            ),
          ),
        ));
      }
      final selected = b.code == widget.selected?.code;
      rows.add(ListTile(
        dense: true,
        title: Text(b.name, style: TextStyle(color: palette.textPrimary)),
        trailing: selected
            ? Icon(Icons.check, color: palette.accent)
            : null,
        onTap: () => Navigator.pop(context, b),
      ));
    }

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
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
              autofocus: false,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search bank or wallet',
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
            child: filtered.isEmpty
                ? Center(
                    child: Text('No match',
                        style: TextStyle(color: palette.textSecondary)),
                  )
                : ListView(controller: controller, children: rows),
          ),
        ],
      ),
    );
  }
}

class _ConfirmPayoutDialog extends StatelessWidget {
  final String amount;
  final String accountName;
  final String bankName;
  final String accountNumber;
  final double? fee;
  final String expenseType;
  final String payee;
  final String description;
  final NumberFormat money;

  const _ConfirmPayoutDialog({
    required this.amount,
    required this.accountName,
    required this.bankName,
    required this.accountNumber,
    required this.fee,
    required this.expenseType,
    required this.payee,
    required this.description,
    required this.money,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final secondary = TextStyle(color: palette.textSecondary);
    return AlertDialog(
      title: Text('Send $amount ETB?'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(TextSpan(children: [
              const TextSpan(text: 'To '),
              TextSpan(
                text: accountName.isEmpty ? '(name not checked)' : accountName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ])),
            Text('$bankName · $accountNumber'),
            if (fee != null && fee! > 0) ...[
              const SizedBox(height: 8),
              Text(
                'QPay fee ${money.format(fee)} ETB is paid by HQ, not from '
                'your wallet.',
                style: secondary,
              ),
            ],
            const SizedBox(height: 8),
            Text.rich(TextSpan(children: [
              TextSpan(
                text: expenseType,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: ' · $payee'),
            ])),
            Text(description, style: secondary),
            const SizedBox(height: 16),
            const CashierBanner(
              tone: StatusTone.warning,
              text: 'Money sent through QPay cannot be pulled back. Check the '
                  'account number.',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Back'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Send now'),
        ),
      ],
    );
  }
}
