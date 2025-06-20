import 'package:courier_app/features/shipment/bloc/shipments_bloc.dart';
import 'package:courier_app/features/track_order/model/shipmet_status_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../track_order/bloc/track_order_bloc.dart';
import '../widgets/shipments_widget.dart';

class ShipmentsScreen extends StatefulWidget {
  const ShipmentsScreen({super.key});

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
    context.read<ShipmentsBloc>().add(FetchShipments());
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
                setState(() {
                  _statusOptions = [
                    'All',
                    ...state.statuses.map((s) => s.code)
                  ];
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
            child: BlocConsumer<ShipmentsBloc, ShipmentsState>(
              listener: (context, state) {
                if (state is FetchShipmentsSuccess) {
                  _filterShipments(state.shipments);
                }
              },
              builder: (context, state) {
                if (state is FetchShipmentsLoading) {
                  return ShipmentsWidgets.buildShimmerEffect(isDarkMode);
                }

                if (state is FetchShipmentsSuccess) {
                  if (_filteredShipments.isEmpty) {
                    return ShipmentsWidgets.buildEmptyState(isDarkMode);
                  }
                  return ShipmentsWidgets.buildShipmentsTable(
                    isDarkMode: isDarkMode,
                    shipments: _filteredShipments,
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
        ],
      ),
    );
  }
}
