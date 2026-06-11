import 'dart:io';
import 'package:courier_app/features/shipment/bloc/shipments_bloc.dart';
import 'package:courier_app/features/track_order/model/shipmet_status_model.dart';
import 'package:courier_app/features/track_order/model/statuses_model.dart';
import 'package:courier_app/app/utils/dialog_utils.dart';
import 'package:courier_app/features/shipment/data/data_provider/deliver_shipment_data_provider.dart';
import 'package:courier_app/features/shipment/data/repository/deliver_shipment_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:courier_app/core/theme/app_palette.dart';
import '../../../track_order/bloc/track_order_bloc.dart';
import '../widgets/shipments_widget.dart';
import 'package:courier_app/features/pay_by_awb/presentation/screen/pay_by_awb_screen.dart';
import '../widgets/deliver_shipment_modal.dart';

class ShipmentsScreen extends StatefulWidget {
  final String? initialStatus;
  
  const ShipmentsScreen({super.key, this.initialStatus});

  @override
  State<ShipmentsScreen> createState() => _ShipmentsScreenState();
}

class _ShipmentsScreenState extends State<ShipmentsScreen> {
  final _searchController = TextEditingController();
  String? _selectedStatus;
  List<StatusModel> _statuses = [];
  List<ShipmentModel> _filteredShipments = [];

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.initialStatus;
    if (_selectedStatus != null) {
      context.read<ShipmentsBloc>().add(FetchShipments(status: _selectedStatus));
    }
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
        return searchTerm.isEmpty ||
            (shipment.awb?.toLowerCase().contains(searchTerm) ?? false);
      }).toList();
    });
  }

  void _onStatusChanged(String status) {
    setState(() {
      _selectedStatus = status;
    });
    context.read<ShipmentsBloc>().add(FetchShipments(status: status));
  }

  void _applyStatuses(List<StatusModel> statuses) {
    if (statuses.isEmpty) return;

    final hasValidSelection = _selectedStatus != null &&
        statuses.any((s) => s.code == _selectedStatus);
    final nextStatus = hasValidSelection
        ? _selectedStatus!
        : (widget.initialStatus != null &&
                statuses.any((s) => s.code == widget.initialStatus)
            ? widget.initialStatus!
            : statuses.first.code);

    final previousStatus = _selectedStatus;

    setState(() {
      _statuses = statuses;
      _selectedStatus = nextStatus;
    });

    if (previousStatus != nextStatus) {
      context.read<ShipmentsBloc>().add(FetchShipments(status: nextStatus));
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

  void _handlePay(String awb) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PayByAwbScreen(initialAwb: awb),
      ),
    );
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
            if (_selectedStatus != null) {
              outerContext.read<ShipmentsBloc>().add(
                FetchShipments(status: _selectedStatus),
              );
            }
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
    final isDarkMode = context.isDarkMode;

    return Scaffold(
      backgroundColor: context.palette.appBarBackground,
      appBar: AppBar(
        backgroundColor: context.palette.appBarBackground,
        title: const Text('Shipments'),
      ),
      body: Column(
        children: [
          BlocListener<TrackOrderBloc, TrackOrderState>(
            listener: (context, state) {
              if (state is FetchStatusSuccess) {
                _applyStatuses(state.statuses);
              }
            },
            child: ShipmentsWidgets.buildSearchAndFilter(
              isDarkMode: isDarkMode,
              searchController: _searchController,
              selectedStatus: _selectedStatus ?? '',
              statuses: _statuses,
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
                      if (_selectedStatus != null) {
                        context.read<ShipmentsBloc>().add(
                          FetchShipments(status: _selectedStatus),
                        );
                      }
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
                  return ShipmentsWidgets.buildShimmerEffect(context);
                }

                if (state is FetchShipmentsSuccess) {
                  if (_filteredShipments.isEmpty) {
                    return ShipmentsWidgets.buildEmptyState(context);
                  }
                  return ShipmentsWidgets.buildShipmentsTable(
                    isDarkMode: isDarkMode,
                    shipments: _filteredShipments,
                    statuses: _statuses,
                    onDeliver: _handleDeliver,
                    onPay: _handlePay,
                  );
                }

                if (state is FetchShipmentsFailure) {
                  return Center(
                    child: Text(
                      state.errorMessage,
                      style: TextStyle(
                        color: context.palette.textPrimary,
                      ),
                    ),
                  );
                }

                return ShipmentsWidgets.buildEmptyState(context);
              },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
