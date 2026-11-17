import 'package:courier_app/core/theme/app_palette.dart';
import 'package:courier_app/core/widgets/status_chip.dart';
import 'package:courier_app/features/cashier_pay/data/cashier_pay_models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final cashierMoney = NumberFormat('#,##0.00');
final cashierApiDate = DateFormat('yyyy-MM-dd');
final cashierDisplayDate = DateFormat('MMM d, yyyy');
final cashierDateTime = DateFormat('MMM d, HH:mm');

String cashierError(Object e) {
  final s = e.toString();
  return s.startsWith('Exception: ') ? s.substring(11) : s;
}

InputDecoration cashierInputDecoration(BuildContext context, String label) {
  final palette = context.palette;
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: palette.border),
  );
  return InputDecoration(
    labelText: label,
    isDense: true,
    filled: true,
    fillColor: palette.surfaceMuted,
    border: border,
    enabledBorder: border,
  );
}

class CashierSectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? action;
  final List<Widget> children;

  const CashierSectionCard({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: palette.textPrimary,
                  ),
                ),
              ),
              if (action != null) action!,
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: TextStyle(fontSize: 12, color: palette.textSecondary),
            ),
          ],
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

class CashierBanner extends StatelessWidget {
  final StatusTone tone;
  final String text;

  const CashierBanner({super.key, required this.tone, required this.text});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    late final Color fg;
    late final Color bg;
    late final IconData icon;
    switch (tone) {
      case StatusTone.success:
        fg = palette.success;
        bg = palette.successSoft;
        icon = Icons.check_circle_outline;
        break;
      case StatusTone.warning:
        fg = palette.warning;
        bg = palette.warningSoft;
        icon = Icons.warning_amber_rounded;
        break;
      case StatusTone.danger:
        fg = palette.danger;
        bg = palette.dangerSoft;
        icon = Icons.error_outline;
        break;
      default:
        fg = palette.info;
        bg = palette.infoSoft;
        icon = Icons.info_outline;
    }
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: fg, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: TextStyle(color: fg, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

class CashierPickerField extends StatelessWidget {
  final String label;
  final String? value;
  final VoidCallback? onTap;
  final IconData icon;
  final bool loading;

  const CashierPickerField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.icon = Icons.arrow_drop_down,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: cashierInputDecoration(context, label).copyWith(
          suffixIcon: loading
              ? const Padding(
                  padding: EdgeInsets.all(14),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : Icon(icon, color: palette.textSecondary),
        ),
        isEmpty: value == null,
        child: value == null
            ? null
            : Text(value!, style: TextStyle(color: palette.textPrimary)),
      ),
    );
  }
}

/// Date range row used by statements and reports.
class CashierDateRange extends StatelessWidget {
  final DateTime from;
  final DateTime to;
  final ValueChanged<DateTime> onFrom;
  final ValueChanged<DateTime> onTo;

  const CashierDateRange({
    super.key,
    required this.from,
    required this.to,
    required this.onFrom,
    required this.onTo,
  });

  Future<void> _pick(BuildContext context, bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? from : to,
      firstDate: isFrom ? DateTime(2020) : from,
      lastDate: isFrom ? to : DateTime.now(),
    );
    if (picked != null) (isFrom ? onFrom : onTo)(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CashierPickerField(
            label: 'From',
            value: cashierDisplayDate.format(from),
            icon: Icons.calendar_today,
            onTap: () => _pick(context, true),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CashierPickerField(
            label: 'To',
            value: cashierDisplayDate.format(to),
            icon: Icons.calendar_today,
            onTap: () => _pick(context, false),
          ),
        ),
      ],
    );
  }
}

/// One wallet transaction (payout or top-up) in a statement or report.
class CashierTransactionTile extends StatelessWidget {
  final CashierTransaction entry;
  final bool showCashier;
  final Widget? action;

  const CashierTransactionTile({
    super.key,
    required this.entry,
    this.showCashier = false,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final e = entry;
    final payout = e.isPayout;
    final title = payout
        ? (e.accountName ?? e.accountNumber ?? 'Payout')
        : (e.description ?? 'Top-up');
    final subtitle = [
      if (e.createdAt != null) cashierDateTime.format(e.createdAt!),
      if (showCashier && e.branchName != null) e.branchName!,
      if (showCashier && e.cashierName != null) e.cashierName!,
      if (payout && (e.bankName ?? e.bankCode) != null)
        (e.bankName ?? e.bankCode)!,
      if (payout && e.expenseType != null) e.expenseType!,
      if (payout && e.payee != null) e.payee!,
      if (e.reference != null) e.reference!,
    ].join(' · ');
    final secondary = TextStyle(fontSize: 12, color: palette.textSecondary);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
              Icon(
                payout ? Icons.north_east_rounded : Icons.south_west_rounded,
                color: payout ? BrandColors.danger : BrandColors.success,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(subtitle, style: secondary),
                    if (payout && e.description != null)
                      Text(e.description!, style: secondary),
                    if (e.failureReason != null)
                      Text(
                        e.failureReason!,
                        style: const TextStyle(
                            fontSize: 12, color: BrandColors.danger),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${payout ? '-' : '+'}${cashierMoney.format(e.amount)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: payout ? BrandColors.danger : BrandColors.success,
                    ),
                  ),
                  if (e.balanceAfter != null)
                    Text(
                      'Bal ${cashierMoney.format(e.balanceAfter)}',
                      style: TextStyle(
                          fontSize: 11, color: palette.textSecondary),
                    ),
                  const SizedBox(height: 4),
                  StatusChip.auto(e.status, compact: true),
                ],
              ),
            ],
          ),
          if (action != null) ...[
            const SizedBox(height: 8),
            Align(alignment: Alignment.centerRight, child: action!),
          ],
        ],
      ),
    );
  }
}
