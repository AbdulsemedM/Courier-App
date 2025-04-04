import 'package:courier_app/features/shipment_types/models/shipment_types_models.dart';
import 'package:courier_app/features/shipment_types/presentation/widget/add_shipment_types_modal.dart';
import 'package:courier_app/features/shipment_types/presentation/widget/shipment_types_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/shipment_types_bloc.dart';

class ShipmentTypesScreen extends StatefulWidget {
  const ShipmentTypesScreen({super.key});

  @override
  State<ShipmentTypesScreen> createState() => _ShipmentTypesScreenState();
}

class _ShipmentTypesScreenState extends State<ShipmentTypesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ShipmentTypesModels> _filteredTypes = [];

  @override
  void initState() {
    super.initState();
    _fetchShipmentTypes();
  }

  void _fetchShipmentTypes() {
    context.read<ShipmentTypesBloc>().add(FetchShipmentTypes());
  }

  void _handleSearch(String query) {
    final state = context.read<ShipmentTypesBloc>().state;
    if (state is ShipmentTypesLoaded) {
      setState(() {
        _filteredTypes = state.shipmentTypes.where((type) {
          final searchLower = query.toLowerCase();
          return (type.type.toLowerCase().contains(searchLower)) ||
              (type.description.toLowerCase().contains(searchLower));
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipment Types'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return Dialog(
                    insetPadding: const EdgeInsets.all(24),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: const AddShipmentTypeModal(),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ShipmentTypesBloc, ShipmentTypesState>(
        builder: (context, state) {
          if (state is ShipmentTypesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ShipmentTypesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  ElevatedButton(
                    onPressed: _fetchShipmentTypes,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ShipmentTypesLoaded) {
            final types =
                _filteredTypes.isEmpty && _searchController.text.isEmpty
                    ? state.shipmentTypes
                    : _filteredTypes;

            return Column(
              children: [
                SearchBarWidget(
                  controller: _searchController,
                  onChanged: _handleSearch,
                ),
                Expanded(
                  child: ShipmentTypesTable(
                    shipmentTypes: types,
                  ),
                ),
              ],
            );
          }

          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
