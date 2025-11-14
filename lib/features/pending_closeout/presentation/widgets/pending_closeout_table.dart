import 'package:courier_app/features/pending_closeout/data/model/pending_closeout_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PendingCloseoutTable extends StatelessWidget {
  final List<PendingCloseout> pendingCloseouts;

  const PendingCloseoutTable({
    super.key,
    required this.pendingCloseouts,
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
                'Liability ID',
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
            DataColumn(
              label: Text(
                'Days Pending',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          rows: pendingCloseouts.map((closeout) {
            final createdAt = DateTime.tryParse(closeout.createdAt);
            final statusColor = _getStatusColor(closeout.status, isDarkMode);
            final shortfallColor = closeout.shortfallAmount > 0
                ? Colors.red
                : (isDarkMode ? Colors.white70 : Colors.black87);

            return DataRow(
              cells: [
                DataCell(Text(
                  closeout.liabilityId.toString(),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                )),
                DataCell(Text(
                  createdAt != null
                      ? dateFormat.format(createdAt)
                      : closeout.createdAt,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                    fontSize: 12,
                  ),
                )),
                DataCell(Text(
                  closeout.tellerName,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                    fontSize: 12,
                  ),
                )),
                DataCell(Text(
                  '${closeout.branchName} (${closeout.branchCode})',
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
                      closeout.status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                DataCell(Text(
                  currencyFormat.format(closeout.expectedAmount),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                DataCell(Text(
                  currencyFormat.format(closeout.actualAmount),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                DataCell(Text(
                  currencyFormat.format(closeout.shortfallAmount),
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
                      closeout.reason,
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
                  closeout.transactionReference,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                    fontSize: 12,
                  ),
                )),
                DataCell(Text(
                  closeout.recordedByName,
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
                      color: closeout.daysPending > 7
                          ? Colors.red.withOpacity(0.2)
                          : closeout.daysPending > 3
                              ? Colors.orange.withOpacity(0.2)
                              : Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${closeout.daysPending} days',
                      style: TextStyle(
                        color: closeout.daysPending > 7
                            ? Colors.red
                            : closeout.daysPending > 3
                                ? Colors.orange
                                : Colors.green,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
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

