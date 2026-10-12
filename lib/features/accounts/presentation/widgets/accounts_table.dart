import 'package:courier_app/features/accounts/data/model/account_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:courier_app/core/theme/app_palette.dart';

class AccountsTable extends StatelessWidget {
  final List<AccountModel> accounts;

  const AccountsTable({
    super.key,
    required this.accounts,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columnSpacing: 24,
          columns: [
            DataColumn(
              label: Text(
                'Account Number',
                style: TextStyle(
                  color: context.palette.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Account Type',
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
                'Teller',
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
                'Status',
                style: TextStyle(
                  color: context.palette.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Created At',
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
                  account.branchName ?? 'N/A',
                  style: TextStyle(
                    color: context.palette.textPrimary,
                  ),
                )),
                DataCell(Text(
                  account.tellerName ?? 'N/A',
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
                DataCell(Text(
                  NumberFormat.currency(symbol: '', decimalDigits: 2)
                      .format(account.expenseBalance),
                  style: TextStyle(
                    color: context.palette.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                )),
                DataCell(
                  account.tellerStatus != null
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(account.tellerStatus!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            account.tellerStatus!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        )
                      : const Text('N/A'),
                ),
                DataCell(Text(
                  DateFormat('MMM-dd-yyyy')
                      .format(DateTime.parse(account.createdAt)),
                  style: TextStyle(
                    color: context.palette.textPrimary,
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
        return BrandColors.info;
      case 'BRANCH_EXPENSE':
        return BrandColors.orange;
      case 'TELLER':
        return BrandColors.success;
      case 'HQ':
        return BrandColors.purpleMid;
      default:
        return BrandColors.neutral500;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'ASSIGNED':
        return BrandColors.success;
      case 'UNASSIGNED':
        return BrandColors.danger;
      default:
        return BrandColors.neutral500;
    }
  }
}
