import 'package:courier_app/features/teller_by_branch/data/model/teller_by_branch_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TellerByBranchTable extends StatelessWidget {
  final List<TellerByBranchWithStatus> tellers;
  final Function(int tellerId, bool isOpen)? onStatusToggle;

  const TellerByBranchTable({
    super.key,
    required this.tellers,
    this.onStatusToggle,
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
                'Teller Name',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Account #',
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
                'Status',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Account Status',
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
                'Account Limit',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Is Open',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Assigned User',
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
            if (onStatusToggle != null)
              DataColumn(
                label: Text(
                  'Action',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
          rows: tellers.map((tellerWithStatus) {
            final teller = tellerWithStatus.teller;
            final status = tellerWithStatus.accountStatus;
            
            return DataRow(
              cells: [
                DataCell(Text(
                  teller.tellerName,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )),
                DataCell(Text(
                  teller.accountNumber,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )),
                DataCell(Text(
                  '${teller.getBranchName()} (${teller.getBranchCode()})',
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
                      color: _getStatusColor(teller.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      teller.status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  status != null
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getTellerStatusColor(status.tellerStatus),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            status.tellerStatus,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        )
                      : Text(
                          'N/A',
                          style: TextStyle(
                            color: isDarkMode ? Colors.grey : Colors.grey[600],
                          ),
                        ),
                ),
                DataCell(Text(
                  status != null
                      ? NumberFormat.currency(symbol: 'ETB ', decimalDigits: 2)
                          .format(status.runningBalance)
                      : NumberFormat.currency(symbol: 'ETB ', decimalDigits: 2)
                          .format(teller.balance),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                )),
                DataCell(Text(
                  status != null
                      ? NumberFormat.currency(symbol: 'ETB ', decimalDigits: 2)
                          .format(status.expenseBalance)
                      : 'ETB 0.00',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )),
                DataCell(Text(
                  status != null
                      ? NumberFormat.currency(symbol: 'ETB ', decimalDigits: 2)
                          .format(status.accountLimit)
                      : NumberFormat.currency(symbol: 'ETB ', decimalDigits: 2)
                          .format(teller.limit),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )),
                DataCell(
                  status != null
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: status.isOpen ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            status.isOpen ? 'Open' : 'Closed',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        )
                      : Text(
                          'N/A',
                          style: TextStyle(
                            color: isDarkMode ? Colors.grey : Colors.grey[600],
                          ),
                        ),
                ),
                DataCell(Text(
                  status?.assignedUserFullName ?? status?.assignedUserEmail ?? 'N/A',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )),
                DataCell(Text(
                  DateFormat('MMM-dd-yyyy')
                      .format(DateTime.parse(teller.createdAt)),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )),
                if (onStatusToggle != null)
                  DataCell(
                    status != null
                        ? Switch(
                            value: status.isOpen,
                            onChanged: (value) {
                              if (onStatusToggle != null) {
                                onStatusToggle!(teller.id, value);
                              }
                            },
                            activeColor: const Color(0xFF9C27B0),
                            inactiveThumbColor: Colors.grey,
                            inactiveTrackColor: Colors.grey[300],
                          )
                        : const SizedBox.shrink(),
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
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

  Color _getTellerStatusColor(String status) {
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

