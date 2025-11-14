import 'package:courier_app/features/teller_liability/data/model/teller_liability_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TellerLiabilityTable extends StatelessWidget {
  final List<TellerLiability> liabilities;

  const TellerLiabilityTable({
    super.key,
    required this.liabilities,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final currencyFormat = NumberFormat.currency(symbol: '', decimalDigits: 2);
    final dateFormat = DateFormat('MMM dd, yyyy HH:mm');

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columnSpacing: 24,
          headingRowColor: MaterialStateProperty.all(
            isDarkMode
                ? Colors.white.withOpacity(0.1)
                : Colors.grey.withOpacity(0.2),
          ),
          columns: [
            DataColumn(
              label: Text(
                'ID',
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
                'Branch ID',
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
                'Expected Amount',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Actual Amount',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Shortfall',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Reason',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Transaction Ref',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Recorded By',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          rows: liabilities.map((liability) {
            final createdAt = DateTime.tryParse(liability.createdAt);
            final statusColor = _getStatusColor(liability.status, isDarkMode);
            final shortfallColor = liability.shortfallAmount > 0
                ? Colors.red
                : (isDarkMode ? Colors.white70 : Colors.black87);

            return DataRow(
              cells: [
                DataCell(Text(
                  liability.id.toString(),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                )),
                DataCell(Text(
                  createdAt != null
                      ? dateFormat.format(createdAt)
                      : liability.createdAt,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                    fontSize: 12,
                  ),
                )),
                DataCell(Text(
                  liability.tellerName,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                    fontSize: 12,
                  ),
                )),
                DataCell(Text(
                  liability.branch.toString(),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                    fontSize: 12,
                  ),
                )),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: statusColor.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      liability.status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                DataCell(Text(
                  currencyFormat.format(liability.expectedAmount),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                DataCell(Text(
                  currencyFormat.format(liability.actualAmount),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                DataCell(Text(
                  currencyFormat.format(liability.shortfallAmount),
                  style: TextStyle(
                    color: shortfallColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                DataCell(
                  SizedBox(
                    width: 150,
                    child: Text(
                      liability.reason,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(Text(
                  liability.transactionReference,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                    fontSize: 12,
                  ),
                )),
                DataCell(Text(
                  liability.recordedBy.toString(),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                    fontSize: 12,
                  ),
                )),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Color _getStatusColor(String status, bool isDarkMode) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Colors.amber;
      case 'APPROVED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      case 'RESOLVED':
        return Colors.blue;
      default:
        return isDarkMode ? Colors.white70 : Colors.grey;
    }
  }
}

