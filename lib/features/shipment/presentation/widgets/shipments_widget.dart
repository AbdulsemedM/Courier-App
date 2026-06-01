import 'package:courier_app/features/track_order/model/shipmet_status_model.dart';
import 'package:courier_app/features/add_shipment/presentation/screens/print_shipment_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:courier_app/core/theme/app_palette.dart';

class ShipmentsWidgets {
  static Widget buildSearchAndFilter({
    required bool isDarkMode,
    required TextEditingController searchController,
    required String selectedStatus,
    required List<String> statusOptions,
    required Function(String) onStatusChanged,
    required VoidCallback onSearch,
  }) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search Bar
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  style: TextStyle(
                    color: AppPalette.forMode(isDarkMode).textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search by AWB Number',
                    hintStyle: TextStyle(
                      color: AppPalette.forMode(isDarkMode).textSecondary,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppPalette.forMode(isDarkMode).textSecondary,
                    ),
                    filled: true,
                    fillColor:
                        AppPalette.forMode(isDarkMode).surfaceMuted,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onSubmitted: (_) => onSearch(),
                ),
              ),
              const SizedBox(width: 12),
              // Status Filter Dropdown
              Container(
                decoration: BoxDecoration(
                  color:
                      AppPalette.forMode(isDarkMode).surfaceMuted,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButton<String>(
                  value: selectedStatus,
                  dropdownColor:
                      AppPalette.forMode(isDarkMode).surface,
                  style: TextStyle(
                    color: AppPalette.forMode(isDarkMode).textPrimary,
                  ),
                  underline: const SizedBox(),
                  items: statusOptions.map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      onStatusChanged(newValue);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget buildShipmentsTable({
    required bool isDarkMode,
    required List<ShipmentModel> shipments,
    bool showDeliverButton = false,
    Function(String)? onDeliver,
  }) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPalette.forMode(isDarkMode).surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            headingRowColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) =>
                  AppPalette.forMode(isDarkMode).surfaceMuted,
            ),
            dataRowColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return isDarkMode
                      ? Colors.blue.withOpacity(0.1)
                      : Colors.blue[100]!;
                }
                return AppPalette.forMode(isDarkMode).surface;
              },
            ),
            columns: [
              DataColumn(
                label: Text(
                  'AWB Number',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppPalette.forMode(isDarkMode).textPrimary,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Status',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppPalette.forMode(isDarkMode).textPrimary,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Net Fee',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppPalette.forMode(isDarkMode).textPrimary,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Sender',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppPalette.forMode(isDarkMode).textPrimary,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Receiver',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppPalette.forMode(isDarkMode).textPrimary,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Action',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppPalette.forMode(isDarkMode).textPrimary,
                  ),
                ),
              ),
            ],
            rows: shipments.map((shipment) {
              return DataRow(
                cells: [
                  DataCell(Text(
                    shipment.awb ?? '',
                    style: TextStyle(
                      color: AppPalette.forMode(isDarkMode).textPrimary,
                    ),
                  )),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(shipment.shipmentStatus?.code ?? ''),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        shipment.shipmentStatus?.code ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  DataCell(Text(
                    'ETB ${shipment.netFee}',
                    style: TextStyle(
                      color: AppPalette.forMode(isDarkMode).textPrimary,
                    ),
                  )),
                  DataCell(Text(
                    shipment.senderName ?? '',
                    style: TextStyle(
                      color: AppPalette.forMode(isDarkMode).textPrimary,
                    ),
                  )),
                  DataCell(Text(
                    shipment.receiverName ?? '',
                    style: TextStyle(
                      color: AppPalette.forMode(isDarkMode).textPrimary,
                    ),
                  )),
                  DataCell(
                    Builder(
                      builder: (context) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.print,
                              color: isDarkMode ? Colors.blue[300] : Colors.blue,
                              size: 20,
                            ),
                            onPressed: () {
                              if (shipment.awb != null && shipment.awb!.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PrintShipmentScreen(
                                      trackingNumber: shipment.awb!,
                                    ),
                                  ),
                                );
                              }
                            },
                            tooltip: 'Print',
                          ),
                          if (showDeliverButton && onDeliver != null)
                            IconButton(
                              icon: Icon(
                                Icons.local_shipping,
                                color: isDarkMode ? Colors.green[300] : Colors.green,
                                size: 20,
                              ),
                              onPressed: () {
                                if (shipment.awb != null && shipment.awb!.isNotEmpty) {
                                  onDeliver(shipment.awb!);
                                }
                              },
                              tooltip: 'Deliver',
                            ),
                        ],
                      ),
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

  static Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'arr':
        return Colors.orange;
      case 'tra':
        return Colors.blue;
      case 'r4p':
        return Colors.green;
      case 'mis':
        return Colors.red;
      case 'otw':
        return Colors.yellow;
      case 'ctm':
        return Colors.indigo;
      case 'del':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  static Widget buildShimmerEffect(BuildContext context) {
    final isDarkMode = context.isDarkMode;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: isDarkMode ? Colors.grey[850]! : AppPalette.forMode(isDarkMode).border,
        highlightColor: isDarkMode ? Colors.grey[700]! : AppPalette.forMode(isDarkMode).surfaceMuted,
        child: Column(
          children: [
            // Search and Filter Shimmer
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 16),
            // Table Shimmer
            Container(
              height: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildEmptyState(BuildContext context) {
    final palette = context.palette;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_shipping_outlined,
            size: 64,
            color: palette.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No shipments found',
            style: TextStyle(
              fontSize: 18,
              color: palette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
