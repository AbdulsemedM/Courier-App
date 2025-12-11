import 'dart:io';
import 'package:courier_app/features/shipment/bloc/shipments_bloc.dart';
import 'package:courier_app/features/track_order/model/shipmet_status_model.dart';
import 'package:courier_app/app/utils/dialog_utils.dart';
import 'package:courier_app/features/shipment/data/data_provider/deliver_shipment_data_provider.dart';
import 'package:courier_app/features/shipment/data/repository/deliver_shipment_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../track_order/bloc/track_order_bloc.dart';
import '../widgets/shipments_widget.dart';
import '../widgets/deliver_shipment_modal.dart';

class ShipmentsScreen extends StatefulWidget {
  final String? initialStatus;
  
  const ShipmentsScreen({super.key, this.initialStatus});

  @override
  State<ShipmentsScreen> createState() => _ShipmentsScreenState();
}

class _ShipmentsScreenState extends State<ShipmentsScreen> {
  final _searchController = TextEditingController();
  String _selectedStatus = 'All';
  List<String> _statusOptions = ['All'];
  List<ShipmentModel> _filteredShipments = [];

  @override
  void initState() {
    super.initState();
    context.read<ShipmentsBloc>().add(FetchShipments(status: widget.initialStatus));
    context.read<TrackOrderBloc>().add(FetchStatuses());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterShipments(List<ShipmentModel> shipments) {
    final searchTerm = _searchController.text.toLowerCase().trim();
    setState(() {
      _filteredShipments = shipments.where((shipment) {
        final matchesSearch = searchTerm.isEmpty ||
            (shipment.awb?.toLowerCase().contains(searchTerm) ?? false);
        final matchesStatus = _selectedStatus == 'All' ||
            (shipment.shipmentStatus?.code == _selectedStatus);
        return matchesSearch && matchesStatus;
      }).toList();
    });
  }

  void _onStatusChanged(String status) {
    setState(() {
      _selectedStatus = status;
    });
    if (context.read<ShipmentsBloc>().state is FetchShipmentsSuccess) {
      final shipments =
          (context.read<ShipmentsBloc>().state as FetchShipmentsSuccess)
              .shipments;
      _filterShipments(shipments);
    }
  }

  void _onSearch() {
    if (context.read<ShipmentsBloc>().state is FetchShipmentsSuccess) {
      final shipments =
          (context.read<ShipmentsBloc>().state as FetchShipmentsSuccess)
              .shipments;
      _filterShipments(shipments);
    }
  }

  void _handleDeliver(String awb) {
    final outerContext = context; // Store the outer context
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => DeliverShipmentModal(
        awb: awb,
        onDeliver: ({
          required String awb,
          required bool isSelf,
          File? customerIdFile,
          String? deliveredToName,
          String? deliveredToPhone,
        }) async {
          try {
            // Close the modal
            Navigator.pop(modalContext);
            
            // Show loading using outer context
            if (!mounted) return;
            showDialog(
              context: outerContext,
              barrierDismissible: false,
              builder: (dialogContext) => const Center(
                child: CircularProgressIndicator(),
              ),
            );

            // Call the deliver API
            final repository = DeliverShipmentRepository(
              deliverShipmentDataProvider: DeliverShipmentDataProvider(),
            );
            
            final message = await repository.deliverShipment(
              awb: awb,
              isSelf: isSelf,
              customerIdFile: customerIdFile,
              deliveredToName: deliveredToName,
              deliveredToPhone: deliveredToPhone,
            );

            // Close loading dialog
            if (!mounted) return;
            Navigator.pop(outerContext);

            // Show success message
            if (!mounted) return;
            displaySnack(outerContext, message, Colors.green);

            // Refresh shipments
            if (!mounted) return;
            outerContext.read<ShipmentsBloc>().add(
              FetchShipments(status: widget.initialStatus),
            );
          } catch (e) {
            // Close loading dialog if still open
            if (mounted) {
              try {
                Navigator.pop(outerContext);
              } catch (_) {
                // Dialog might already be closed
              }
              
              // Show error message
              displaySnack(outerContext, e.toString(), Colors.red);
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color(0xFF5b3895)
          : const Color(0xFF5b3895),
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? const Color(0xFF5b3895)
            : const Color(0xFF5b3895),
        title: const Text('Shipments'),
      ),
      body: Column(
        children: [
          BlocListener<TrackOrderBloc, TrackOrderState>(
            listener: (context, state) {
              if (state is FetchStatusSuccess) {
                final newStatusOptions = [
                  'All',
                  ...state.statuses.map((s) => s.code)
                ];
                setState(() {
                  _statusOptions = newStatusOptions;
                  // Set the initial status after statuses are loaded
                  if (widget.initialStatus != null && 
                      newStatusOptions.contains(widget.initialStatus)) {
                    _selectedStatus = widget.initialStatus!;
                  }
                });
              }
            },
            child: ShipmentsWidgets.buildSearchAndFilter(
              isDarkMode: isDarkMode,
              searchController: _searchController,
              selectedStatus: _selectedStatus,
              statusOptions: _statusOptions,
              onStatusChanged: _onStatusChanged,
              onSearch: _onSearch,
            ),
          ),
          Expanded(
            child: MultiBlocListener(
              listeners: [
                BlocListener<ShipmentsBloc, ShipmentsState>(
                  listener: (context, state) {
                    if (state is FetchShipmentsSuccess) {
                      _filterShipments(state.shipments);
                    }
                  },
                ),
                BlocListener<TrackOrderBloc, TrackOrderState>(
                  listener: (context, state) {
                    if (state is ChangeStatusSuccess) {
                      displaySnack(context, state.message, Colors.green);
                      // Refresh shipments after status change
                      context.read<ShipmentsBloc>().add(
                        FetchShipments(status: widget.initialStatus),
                      );
                    } else if (state is ChangeStatusFailure) {
                      displaySnack(context, state.errorMessage, Colors.red);
                    }
                  },
                ),
              ],
              child: BlocConsumer<ShipmentsBloc, ShipmentsState>(
                listener: (context, state) {
                  // Listener removed as it's now in MultiBlocListener
                },
              builder: (context, state) {
                if (state is FetchShipmentsLoading) {
                  return ShipmentsWidgets.buildShimmerEffect(isDarkMode);
                }

                if (state is FetchShipmentsSuccess) {
                  if (_filteredShipments.isEmpty) {
                    return ShipmentsWidgets.buildEmptyState(isDarkMode);
                  }
                  final showDeliverButton = widget.initialStatus == 'ARR' || _selectedStatus == 'ARR';
                  return ShipmentsWidgets.buildShipmentsTable(
                    isDarkMode: isDarkMode,
                    shipments: _filteredShipments,
                    showDeliverButton: showDeliverButton,
                    onDeliver: _handleDeliver,
                  );
                }

                if (state is FetchShipmentsFailure) {
                  return Center(
                    child: Text(
                      state.errorMessage,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  );
                }

                return ShipmentsWidgets.buildEmptyState(isDarkMode);
              },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
