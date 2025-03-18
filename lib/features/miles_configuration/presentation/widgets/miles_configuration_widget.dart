import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../add_shipment/bloc/add_shipment_bloc.dart';
import '../../models/miles_configuration_model.dart';

class MilesConfigurationWidgets {
  static Widget buildMilesConfigurationTable({
    required bool isDarkMode,
    required List<MilesConfigurationModel> configurations,
    required VoidCallback onAddConfig,
  }) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Origin Branch')),
                DataColumn(label: Text('Destination Branch')),
                DataColumn(label: Text('Unit')),
                DataColumn(label: Text('Miles/Unit')),
              ],
              rows: configurations.map((config) {
                return DataRow(cells: [
                  DataCell(Text(config.id.toString())),
                  DataCell(Text(config.originBranchName)),
                  DataCell(Text(config.destinationBranchName)),
                  DataCell(Text(config.unit)),
                  DataCell(Text(config.milesPerUnit.toString())),
                ]);
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: onAddConfig,
          child: const Text('Add Miles Configuration'),
        ),
      ],
    );
  }

  static Future<void> showAddMilesConfigModal(BuildContext context) async {
    final addShipmentBloc = context.read<AddShipmentBloc>();
    addShipmentBloc.add(FetchBranches());

    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<AddShipmentBloc, AddShipmentState>(
          builder: (context, state) {
            if (state is FetchBranchesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is FetchBranchesSuccess) {
              return AlertDialog(
                title: const Text('Add Miles Configuration'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      items: state.branches.map((branch) {
                        return DropdownMenuItem(
                          value: branch.id.toString(),
                          child: Text(branch.name!),
                        );
                      }).toList(),
                      onChanged: (value) {},
                      decoration: const InputDecoration(
                        labelText: 'Origin Branch',
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      items: state.branches.map((branch) {
                        return DropdownMenuItem(
                          value: branch.id.toString(),
                          child: Text(branch.name!),
                        );
                      }).toList(),
                      onChanged: (value) {},
                      decoration: const InputDecoration(
                        labelText: 'Destination Branch',
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Unit'),
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Miles/Unit'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle save logic
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save'),
                  ),
                ],
              );
            }

            return const Center(child: Text('Failed to load branches'));
          },
        );
      },
    );
  }
}
