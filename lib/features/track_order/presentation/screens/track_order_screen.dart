import 'package:courier_app/core/utils/shipment_status_helper.dart';
import 'package:courier_app/features/shelves_management/presentation/widgets/shelf_picker.dart';
import 'package:courier_app/features/track_order/bloc/track_order_bloc.dart';
import 'package:courier_app/features/track_order/model/statuses_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/shipmet_status_model.dart';
import '../widgets/track_order_widget.dart';
import 'package:courier_app/core/theme/app_palette.dart';

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
    String? dialogStatus;
    int? dialogShelfId;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final isArr = dialogStatus?.toUpperCase() ==
              ShipmentStatusHelper.arrivedStatusCode;

          return AlertDialog(
            backgroundColor: context.palette.surface,
            title: Text(
              'Change Status',
              style: TextStyle(
                color: context.palette.textPrimary,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${selectedShipments.length} shipments selected',
                    style: TextStyle(
                      color: context.palette.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: context.palette.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: context.palette.border,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: dialogStatus,
                        isExpanded: true,
                        hint: Text(
                          'Select new status',
                          style: TextStyle(
                            color: context.palette.textSecondary,
                          ),
                        ),
                        dropdownColor: context.palette.surface,
                        items: statuses
                            .map((status) => DropdownMenuItem<String>(
                                  value: status.code,
                                  child: Text(
                                    '${status.code} - ${status.description}',
                                    style: TextStyle(
                                      color: context.palette.textPrimary,
                                    ),
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setDialogState(() {
                            dialogStatus = value;
                            if (value?.toUpperCase() !=
                                ShipmentStatusHelper.arrivedStatusCode) {
                              dialogShelfId = null;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  if (isArr) ...[
                    const SizedBox(height: 16),
                    ShelfPicker(
                      selectedShelfId: dialogShelfId,
                      onChanged: (shelfId) {
                        setDialogState(() => dialogShelfId = shelfId);
                      },
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: context.palette.textSecondary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (dialogStatus == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select a status'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  if (isArr && dialogShelfId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select a shelf'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  Navigator.pop(context, true);
                },
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    color: context.palette.accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    if (confirmed == true && dialogStatus != null && mounted) {
      context.read<TrackOrderBloc>().add(ChangeStatus(
            shipmentIds:
                selectedShipments.map((s) => s.awb.toString()).toList(),
            status: dialogStatus!,
            shelfId: dialogStatus!.toUpperCase() ==
                    ShipmentStatusHelper.arrivedStatusCode
                ? dialogShelfId
                : null,
          ));
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
            color: context.palette.textSecondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: context.palette.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: context.palette.border,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedStatus,
                  hint: Text(
                    'Filter by status',
                    style: TextStyle(
                      color: context.palette.textSecondary,
                    ),
                  ),
                  isExpanded: true,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: context.palette.textSecondary,
                  ),
                  dropdownColor: context.palette.surface,
                  items: [
                    DropdownMenuItem<String>(
                      value: null,
                      child: Text(
                        'All Statuses',
                        style: TextStyle(
                          color: context.palette.textPrimary,
                        ),
                      ),
                    ),
                    ...statuses
                        .map((status) => DropdownMenuItem<String>(
                              value: status.code,
                              child: Text(
                                '${status.code} - ${status.description}',
                                style: TextStyle(
                                  color: context.palette.textPrimary,
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
                color: context.palette.textSecondary,
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
        .where((shipment) => shipment.shipmentStatus?.code == selectedStatus)
        .toList();
  }

  AppBar _buildAppBar(bool isDarkMode) {
    if (isSelectionMode) {
      return AppBar(
        elevation: 0,
        backgroundColor: isDarkMode
            ? const Color.fromARGB(255, 75, 23, 160)
            : const Color.fromARGB(255, 75, 23, 160),
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
      backgroundColor: context.palette.appBarBackground,
      title: Text(
        'Shipments',
        style: TextStyle(
          color: context.palette.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;

    return MultiBlocListener(
      listeners: [
        BlocListener<TrackOrderBloc, TrackOrderState>(
          listenWhen: (previous, current) => current is ChangeStatusSuccess,
          listener: (context, state) {
            if (state is ChangeStatusSuccess) {
              _loadShipments();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: context.isDarkMode ? const Color(0xFF5B3895) : context.palette.background,
        appBar: _buildAppBar(isDarkMode),
        body: RefreshIndicator(
          onRefresh: _loadShipments,
          child: BlocBuilder<TrackOrderBloc, TrackOrderState>(
            builder: (context, state) {
              if (state is TrackOrderLoading) {
                return TrackOrderWidgets.buildShimmerEffect(context);
              }
              if (state is FetchStatusLoading) {
                return TrackOrderWidgets.buildShimmerEffect(context);
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
                          color:
                              context.palette.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.errorMessage,
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              context.palette.textSecondary,
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
                          ? TrackOrderWidgets.buildEmptyState(context)
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount:
                                  _filterShipments(state.shipments).length,
                              itemBuilder: (context, index) {
                                final shipment =
                                    _filterShipments(state.shipments)[index];
                                return TrackOrderWidgets.buildShipmentCard(
                                  context: context,
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

              return TrackOrderWidgets.buildShimmerEffect(context);
            },
          ),
        ),
      ),
    );
  }
}
