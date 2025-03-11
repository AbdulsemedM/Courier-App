import 'package:courier_app/features/track_order/bloc/track_order_bloc.dart';
import 'package:courier_app/features/track_order/model/statuses_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/shipmet_status_model.dart';
import '../widgets/track_order_widget.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_provider.dart';

class TrackOrderScreen extends StatefulWidget {
  const TrackOrderScreen({super.key});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  List<StatusModel> statuses = [];
  String? selectedStatus;
  Set<ShipmentModel> selectedShipments = {};
  bool isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    _loadShipments();
  }

  Future<void> _loadShipments() async {
    context.read<TrackOrderBloc>().add(TrackOrder());
    context.read<TrackOrderBloc>().add(FetchStatuses());
  }

  void _onShipmentTapped(ShipmentModel shipment) {
    // Handle shipment tap
    // Navigate to shipment details
  }

  void _toggleShipmentSelection(ShipmentModel shipment) {
    setState(() {
      if (selectedShipments.contains(shipment)) {
        selectedShipments.remove(shipment);
        if (selectedShipments.isEmpty) {
          isSelectionMode = false;
        }
      } else {
        selectedShipments.add(shipment);
      }
    });
  }

  void _onLongPressShipment(ShipmentModel shipment) {
    setState(() {
      isSelectionMode = true;
      selectedShipments.add(shipment);
    });
  }

  Future<void> _showStatusChangeDialog() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;

    final String? newStatus = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? const Color(0xFF1E2837) : Colors.white,
        title: Text(
          'Change Status',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${selectedShipments.length} shipments selected',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.grey[800]!.withOpacity(0.5)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text(
                    'Select new status',
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
                  items: statuses
                      .map((status) => DropdownMenuItem<String>(
                            value: status.code,
                            child: Text(
                              '${status.code} - ${status.description}',
                              style: TextStyle(
                                color:
                                    isDarkMode ? Colors.white : Colors.black87,
                              ),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) => Navigator.pop(context, value),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );

    if (newStatus != null) {
      // Update status for selected shipments
      // context.read<TrackOrderBloc>().add(
      //       UpdateShipmentStatus(
      //         shipmentIds: selectedShipments.map((s) => s.id).toList(),
      //         newStatus: newStatus,
      //       ),
      //     );
      setState(() {
        selectedShipments.clear();
        isSelectionMode = false;
      });
    }
  }

  Widget _buildStatusFilter(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(
            Icons.filter_list,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.grey[800]!.withOpacity(0.5)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedStatus,
                  hint: Text(
                    'Filter by status',
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  isExpanded: true,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                  dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
                  items: [
                    DropdownMenuItem<String>(
                      value: null,
                      child: Text(
                        'All Statuses',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    ...statuses
                        .map((status) => DropdownMenuItem<String>(
                              value: status.code,
                              child: Text(
                                '${status.code} - ${status.description}',
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ))
                        .toList(),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value;
                    });
                  },
                ),
              ),
            ),
          ),
          if (selectedStatus != null) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                Icons.clear,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
              onPressed: () {
                setState(() {
                  selectedStatus = null;
                });
              },
              tooltip: 'Clear filter',
            ),
          ],
        ],
      ),
    );
  }

  List<ShipmentModel> _filterShipments(List<ShipmentModel> shipments) {
    if (selectedStatus == null) return shipments;
    return shipments
        .where((shipment) => shipment.shipmentStatus.code == selectedStatus)
        .toList();
  }

  AppBar _buildAppBar(bool isDarkMode) {
    if (isSelectionMode) {
      return AppBar(
        elevation: 0,
        backgroundColor: isDarkMode
            ? const Color(0xFF0A1931).withOpacity(0.95)
            : Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            setState(() {
              selectedShipments.clear();
              isSelectionMode = false;
            });
          },
        ),
        title: Text(
          '${selectedShipments.length} Selected',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note),
            onPressed:
                selectedShipments.isEmpty ? null : _showStatusChangeDialog,
            tooltip: 'Change Status',
          ),
        ],
      );
    }

    return AppBar(
      elevation: 0,
      backgroundColor: isDarkMode
          ? const Color(0xFF0A1931).withOpacity(0.95)
          : Colors.white.withOpacity(0.8),
      title: Text(
        'Shipments',
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: _buildAppBar(isDarkMode),
      body: RefreshIndicator(
        onRefresh: _loadShipments,
        child: BlocBuilder<TrackOrderBloc, TrackOrderState>(
          builder: (context, state) {
            if (state is TrackOrderLoading) {
              return TrackOrderWidgets.buildShimmerEffect(isDarkMode);
            }
            if (state is FetchStatusLoading) {
              return TrackOrderWidgets.buildShimmerEffect(isDarkMode);
            }
            if (state is FetchStatusSuccess) {
              statuses = state.statuses;
            }

            if (state is TrackOrdeFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: isDarkMode ? Colors.red[300] : Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading shipments',
                      style: TextStyle(
                        fontSize: 18,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.errorMessage,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.grey[500] : Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _loadShipments,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isDarkMode ? Colors.blue[700] : Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }

            if (state is TrackOrderSuccess) {
              return Column(
                children: [
                  if (!isSelectionMode) _buildStatusFilter(isDarkMode),
                  Expanded(
                    child: state.shipments.isEmpty
                        ? TrackOrderWidgets.buildEmptyState(isDarkMode)
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filterShipments(state.shipments).length,
                            itemBuilder: (context, index) {
                              final shipment =
                                  _filterShipments(state.shipments)[index];
                              return TrackOrderWidgets.buildShipmentCard(
                                isDarkMode: isDarkMode,
                                shipment: shipment,
                                isSelected:
                                    selectedShipments.contains(shipment),
                                onTap: () {
                                  if (isSelectionMode) {
                                    _toggleShipmentSelection(shipment);
                                  } else {
                                    _onShipmentTapped(shipment);
                                  }
                                },
                                onLongPress: () =>
                                    _onLongPressShipment(shipment),
                              );
                            },
                          ),
                  ),
                ],
              );
            }

            return TrackOrderWidgets.buildShimmerEffect(isDarkMode);
          },
        ),
      ),
    );
  }
}
