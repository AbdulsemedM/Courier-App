import 'package:courier_app/features/track_order/model/shipmet_status_model.dart';
import 'package:courier_app/features/add_shipment/presentation/screens/print_shipment_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search by AWB Number',
                    hintStyle: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                    filled: true,
                    fillColor:
                        isDarkMode ? const Color(0xFF1E293B) : Colors.grey[100],
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
                      isDarkMode ? const Color(0xFF1E293B) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButton<String>(
                  value: selectedStatus,
                  dropdownColor:
                      isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
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
        color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
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
                  isDarkMode ? const Color(0xFF0F172A) : Colors.blue[50]!,
            ),
            dataRowColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return isDarkMode
                      ? Colors.blue.withOpacity(0.1)
                      : Colors.blue[100]!;
                }
                return isDarkMode ? const Color(0xFF1E293B) : Colors.white;
              },
            ),
            columns: [
              DataColumn(
                label: Text(
                  'AWB Number',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Status',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Net Fee',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Sender',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Receiver',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Action',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
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
                      color: isDarkMode ? Colors.white : Colors.black87,
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
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  )),
                  DataCell(Text(
                    shipment.senderName ?? '',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  )),
                  DataCell(Text(
                    shipment.receiverName ?? '',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black87,
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

  static Widget buildShimmerEffect(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: isDarkMode ? Colors.grey[850]! : Colors.grey[300]!,
        highlightColor: isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
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

  static Widget buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_shipping_outlined,
            size: 64,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            'No shipments found',
            style: TextStyle(
              fontSize: 18,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
