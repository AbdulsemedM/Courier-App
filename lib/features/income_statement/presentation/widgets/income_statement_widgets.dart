import 'package:courier_app/features/income_statement/data/model/income_statement_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:courier_app/core/theme/app_palette.dart';

class IncomeSummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;
  final IconData icon;
  final String? marginText;
  final Color? marginColor;

  const IncomeSummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
    this.marginText,
    this.marginColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: context.palette.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: context.palette.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                'ETB ${NumberFormat.currency(symbol: '', decimalDigits: 2).format(amount)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
            if (marginText != null) ...[
              const SizedBox(height: 4),
              Text(
                marginText!,
                style: TextStyle(
                  fontSize: 12,
                  color: marginColor ?? (context.palette.textSecondary),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class BreakdownSection extends StatelessWidget {
  final String title;
  final Color titleColor;
  final List<Map<String, dynamic>> items;
  final double total;
  final bool isRevenue;

  const BreakdownSection({
    super.key,
    required this.title,
    required this.titleColor,
    required this.items,
    required this.total,
    this.isRevenue = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: context.palette.border,
                  width: 1,
                ),
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
          ),
          // Items
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No ${isRevenue ? 'revenue' : 'expense'} items recorded.',
                style: TextStyle(
                  color: context.palette.textSecondary,
                ),
              ),
            )
          else
            ...items.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: context.palette.border,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['label'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        color: context.palette.textPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'ETB ${NumberFormat.currency(symbol: '', decimalDigits: 2).format(item['amount'] as double)}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: context.palette.textPrimary,
                          ),
                        ),
                        if (item['hasCopy'] == true) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.copy,
                            size: 16,
                            color: context.palette.textSecondary,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              );
            }),
          // Total
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isRevenue
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total ${isRevenue ? 'Revenue' : 'Expenses'}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: context.palette.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'ETB ${NumberFormat.currency(symbol: '', decimalDigits: 1).format(total)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isRevenue ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.settings,
                      size: 18,
                      color: context.palette.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AccountBalancesTable extends StatelessWidget {
  final List<AccountBalance> accounts;

  const AccountBalancesTable({
    super.key,
    required this.accounts,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;

    if (accounts.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            'No accounts found',
            style: TextStyle(
              color: context.palette.textSecondary,
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columnSpacing: 24,
          columns: [
            DataColumn(
              label: Text(
                'Account #',
                style: TextStyle(
                  color: context.palette.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Type',
                style: TextStyle(
                  color: context.palette.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Branch',
                style: TextStyle(
                  color: context.palette.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Expense Balance',
                style: TextStyle(
                  color: context.palette.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Running Balance',
                style: TextStyle(
                  color: context.palette.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          rows: accounts.map((account) {
            return DataRow(
              cells: [
                DataCell(Text(
                  account.accountNumber,
                  style: TextStyle(
                    color: context.palette.textPrimary,
                  ),
                )),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getAccountTypeColor(account.accountType),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      account.accountType,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                DataCell(Text(
                  account.branchName,
                  style: TextStyle(
                    color: context.palette.textPrimary,
                  ),
                )),
                DataCell(Text(
                  NumberFormat.currency(symbol: '', decimalDigits: 2)
                      .format(account.expenseBalance),
                  style: TextStyle(
                    color: context.palette.textPrimary,
                  ),
                )),
                DataCell(Text(
                  NumberFormat.currency(symbol: '', decimalDigits: 2)
                      .format(account.runningBalance),
                  style: TextStyle(
                    color: context.palette.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                )),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Color _getAccountTypeColor(String accountType) {
    switch (accountType.toUpperCase()) {
      case 'BRANCH':
        return Colors.blue;
      case 'BRANCH_EXPENSE':
        return Colors.orange;
      case 'TELLER':
        return Colors.green;
      case 'HQ':
        return Colors.purple;
      case 'HQ_EXPENSE':
        return Colors.red;
      case 'EXPENSE':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

