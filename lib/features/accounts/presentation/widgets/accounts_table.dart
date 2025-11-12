import 'package:courier_app/features/accounts/data/model/account_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccountsTable extends StatelessWidget {
  final List<AccountModel> accounts;

  const AccountsTable({
    super.key,
    required this.accounts,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Account Type',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Branch',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Teller',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Running Balance',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Expense Balance',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Status',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Created At',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
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
                    color: isDarkMode ? Colors.white : Colors.black,
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
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )),
                DataCell(Text(
                  account.tellerName ?? 'N/A',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )),
                DataCell(Text(
                  NumberFormat.currency(symbol: '', decimalDigits: 2)
                      .format(account.runningBalance),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                )),
                DataCell(Text(
                  NumberFormat.currency(symbol: '', decimalDigits: 2)
                      .format(account.expenseBalance),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
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
                    color: isDarkMode ? Colors.white : Colors.black,
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
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'ASSIGNED':
        return Colors.green;
      case 'UNASSIGNED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
