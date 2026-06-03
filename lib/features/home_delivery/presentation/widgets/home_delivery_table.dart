import 'package:courier_app/core/theme/app_palette.dart';
import 'package:courier_app/core/utils/shipment_status_helper.dart';
import 'package:courier_app/features/home_delivery/data/model/home_delivery_model.dart';
import 'package:flutter/material.dart';

class HomeDeliveryTable extends StatelessWidget {
  final List<HomeDeliveryModel> deliveries;
  final void Function(HomeDeliveryModel delivery)? onAssign;
  final void Function(HomeDeliveryModel delivery)? onPay;

  const HomeDeliveryTable({
    super.key,
    required this.deliveries,
    this.onAssign,
    this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;
    final palette = AppPalette.forMode(isDarkMode);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(palette.surfaceMuted),
            columns: [
              _header('AWB', palette),
              _header('Status', palette),
              _header('Receiver', palette),
              _header('Phone', palette),
              _header('Messenger', palette),
              _header('ETA', palette),
              _header('Payment', palette),
              _header('Action', palette),
            ],
            rows: deliveries.map((delivery) {
              final statusCode = delivery.status ?? '';
              final showPay = ShipmentStatusHelper.shouldShowPayAction(
                shipmentStatusCode: statusCode,
                paymentStatus: delivery.paymentStatus,
              );
              final showAssign = delivery.canAssign && onAssign != null;

              return DataRow(
                cells: [
                  _cell(delivery.awb ?? '-', palette),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor(statusCode),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        ShipmentStatusHelper.displayLabelForCode(statusCode),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  _cell(delivery.receiverName ?? '-', palette),
                  _cell(delivery.receiverMobile ?? '-', palette),
                  _cell(delivery.messengerName ?? '-', palette),
                  _cell(delivery.estimatedDeliveryTime ?? '-', palette),
                  _cell(delivery.paymentStatus ?? '-', palette),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (showAssign)
                          IconButton(
                            icon: Icon(
                              Icons.person_add_alt_1,
                              color: palette.accent,
                              size: 20,
                            ),
                            tooltip: 'Assign',
                            onPressed: () => onAssign!(delivery),
                          ),
                        if (showPay && onPay != null)
                          IconButton(
                            icon: Icon(
                              Icons.payment,
                              size: 20,
                              color: Colors.amber[800],
                            ),
                            tooltip: 'Pay',
                            onPressed: () => onPay!(delivery),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  DataColumn _header(String label, AppPalette palette) {
    return DataColumn(
      label: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: palette.textPrimary,
        ),
      ),
    );
  }

  DataCell _cell(String text, AppPalette palette) {
    return DataCell(
      Text(text, style: TextStyle(color: palette.textPrimary)),
    );
  }

  Color _statusColor(String code) {
    switch (code.toUpperCase()) {
      case 'PAR':
        return Colors.deepPurple;
      case 'R4P':
        return Colors.deepOrange;
      case 'ASSIGNED':
        return Colors.blue;
      case 'DELIVERED':
        return Colors.green;
      case 'OVERDUE':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
