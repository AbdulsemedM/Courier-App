import 'package:courier_app/app/utils/dialog_utils.dart';
import 'package:courier_app/core/theme/app_palette.dart';
import 'package:courier_app/features/manifest/data/model/manifest_model.dart';
import 'package:courier_app/features/track_order/presentation/widgets/track_order_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManifestTable extends StatelessWidget {
  final List<ManifestModel> manifests;

  const ManifestTable({super.key, required this.manifests});

  String _formatDateTime(String raw) {
    try {
      final parsed = DateTime.parse(raw);
      return DateFormat('d MMM yyyy, HH:mm').format(parsed);
    } catch (_) {
      return raw;
    }
  }

  String _formatValue(double value) {
    return NumberFormat('#,##0').format(value);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;
    final palette = context.palette;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columnSpacing: 24,
          headingRowColor: WidgetStateProperty.all(
            isDarkMode
                ? Colors.white.withOpacity(0.1)
                : Colors.grey.withOpacity(0.15),
          ),
          columns: [
            _column('Manifest ID', palette),
            _column('Date & Time', palette),
            _column('Route', palette),
            _column('Status Change', palette),
            _column('Totals', palette),
            _column('Created By', palette),
            _column('Action', palette),
          ],
          rows: manifests.map((manifest) {
            return DataRow(
              cells: [
                DataCell(
                  Text(
                    manifest.manifestId,
                    style: TextStyle(
                      color: palette.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    _formatDateTime(manifest.displayDateTime),
                    style: TextStyle(color: palette.textPrimary),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 180,
                    child: Text(
                      manifest.routeLabel,
                      style: TextStyle(color: palette.textPrimary),
                    ),
                  ),
                ),
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TrackOrderWidgets.buildStatusChip(
                            manifest.fromStatus.code,
                            isDarkMode,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(
                              Icons.arrow_forward,
                              size: 14,
                              color: palette.textSecondary,
                            ),
                          ),
                          TrackOrderWidgets.buildStatusChip(
                            manifest.toStatus.code,
                            isDarkMode,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${manifest.fromStatus.name} → ${manifest.toStatus.name}',
                        style: TextStyle(
                          fontSize: 11,
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${manifest.totalShipments} shipments',
                        style: TextStyle(color: palette.textPrimary),
                      ),
                      Text(
                        'Weight: ${manifest.totalWeight.toStringAsFixed(0)} kg',
                        style: TextStyle(
                          fontSize: 12,
                          color: palette.textSecondary,
                        ),
                      ),
                      Text(
                        'Value: ${_formatValue(manifest.totalValue)} ETB',
                        style: TextStyle(
                          fontSize: 12,
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        manifest.creatorLabel,
                        style: TextStyle(color: palette.textPrimary),
                      ),
                      Text(
                        manifest.createdBy.email,
                        style: TextStyle(
                          fontSize: 12,
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                DataCell(
                  IconButton(
                    icon: Icon(Icons.edit_outlined, color: palette.accent),
                    tooltip: 'Edit manifest',
                    onPressed: () {
                      displaySnack(
                        context,
                        'Edit manifest — coming soon',
                        Colors.orange,
                      );
                    },
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  DataColumn _column(String label, AppPalette palette) {
    return DataColumn(
      label: Text(
        label,
        style: TextStyle(
          color: palette.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
