import 'package:courier_app/features/miles_configuration/bloc/miles_configuration_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../add_shipment/bloc/add_shipment_bloc.dart';
import '../../models/miles_configuration_model.dart';
import 'package:courier_app/core/theme/app_palette.dart';

class MilesConfigurationWidgets {
  static Widget buildMilesConfigurationTable({
    required BuildContext context,
    required bool isDarkMode,
    required List<MilesConfigurationModel> configurations,
    required VoidCallback onAddConfig,
  }) {
    final tableHeaderColor = isDarkMode
        ? const Color.fromARGB(255, 75, 23, 160)
        : context.palette.appBarBackground;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.palette.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.palette.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Miles Configuration Table',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: context.palette.textPrimary,
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  // Table header
                  Container(
                    decoration: BoxDecoration(
                      color: tableHeaderColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Row(
                      children: [
                        _buildHeaderCell(context, 'ID', 0.1, isDarkMode),
                        _buildHeaderCell(context, 'Origin Branch', 0.25, isDarkMode),
                        _buildHeaderCell(
                            context, 'Destination Branch', 0.25, isDarkMode),
                        _buildHeaderCell(context, 'Unit', 0.15, isDarkMode),
                        _buildHeaderCell(context, 'Miles/Unit', 0.25, isDarkMode),
                      ],
                    ),
                  ),
                  // Table rows
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: configurations.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: context.palette.surfaceMuted,
                    ),
                    itemBuilder: (context, index) {
                      final config = configurations[index];
                      final isEven = index % 2 == 0;
                      return Container(
                        decoration: BoxDecoration(
                          color: isEven
                              ? (context.palette.surface)
                              : context.palette.surfaceMuted,
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        child: Row(
                          children: [
                            _buildCell(context, config.id.toString(), 0.1),
                            _buildCell(
                                context, config.originBranchName, 0.25),
                            _buildCell(
                                context, config.destinationBranchName, 0.25),
                            _buildCell(context, config.unit, 0.15),
                            _buildCell(context, config.milesPerUnit.toString(), 0.25),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: onAddConfig,
            icon: const Icon(Icons.add),
            label: const Text('Add Miles Configuration'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildHeaderCell(
    BuildContext context,
    String text,
    double flex,
    bool isDarkMode,
  ) {
    return Expanded(
      flex: (flex * 100).toInt(),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: context.palette.textPrimary,
        ),
      ),
    );
  }

  static Widget _buildCell(BuildContext context, String text, double flex) {
    return Expanded(
      flex: (flex * 100).toInt(),
      child: Text(
        text,
        style: TextStyle(
          color: context.palette.textSecondary,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  static Future<void> showAddMilesConfigModal(BuildContext context) async {
    final addShipmentBloc = context.read<AddShipmentBloc>();
    // final milesConfigBloc = context.read<MilesConfigurationBloc>();
    addShipmentBloc.add(FetchBranches(true));

    final TextEditingController unitController = TextEditingController();
    final TextEditingController milesPerUnitController =
        TextEditingController();
    String? selectedOriginBranch;
    String? selectedDestinationBranch;
    // String? selectedOriginBranchName;
    // String? selectedDestinationBranchName;

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing while loading
      builder: (context) {
        final isDarkMode = context.isDarkMode;

        return BlocListener<MilesConfigurationBloc, MilesConfigurationState>(
          listener: (context, state) {
            if (state is AddMilesConfigSuccess) {
              // Close modal
              Navigator.of(context).pop();

              // Fetch updated configurations
              context
                  .read<MilesConfigurationBloc>()
                  .add(FetchMilesConfiguration());

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Miles configuration added successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is MilesConfigurationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: BlocBuilder<AddShipmentBloc, AddShipmentState>(
            builder: (context, state) {
              if (state is FetchBranchesLoading) {
                return Center(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }

              if (state is FetchBranchesSuccess) {
                return BlocBuilder<MilesConfigurationBloc,
                    MilesConfigurationState>(
                  builder: (context, milesConfigState) {
                    return Stack(
                      children: [
                        AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: context.palette.surface,
                          title: Text(
                            'Add Miles Configuration',
                            style: TextStyle(
                              color: context.palette.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: StatefulBuilder(
                            builder: (context, setState) {
                              return Container(
                                width: 400,
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    DropdownButtonFormField<String>(
                                      value: selectedOriginBranch,
                                      dropdownColor: context.palette.surface,
                                      items: state.branches.map((branch) {
                                        return DropdownMenuItem(
                                          value: branch.id.toString(),
                                          child: Text(
                                            branch.name!,
                                            style: TextStyle(
                                              color: context.palette.textPrimary,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedOriginBranch = value;
                                          // selectedOriginBranchName = state
                                          //     .branches
                                          //     .firstWhere((b) =>
                                          //         b.id.toString() == value)
                                          //     .name;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Origin Branch',
                                        labelStyle: TextStyle(
                                          color: isDarkMode
                                              ? Colors.blue[300]
                                              : Colors.blue[700],
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        filled: true,
                                        fillColor: context.palette.surfaceMuted,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    DropdownButtonFormField<String>(
                                      value: selectedDestinationBranch,
                                      dropdownColor: context.palette.surface,
                                      items: state.branches.map((branch) {
                                        return DropdownMenuItem(
                                          value: branch.id.toString(),
                                          child: Text(
                                            branch.name!,
                                            style: TextStyle(
                                              color: context.palette.textPrimary,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedDestinationBranch = value;
                                          // selectedDestinationBranchName = state
                                          //     .branches
                                          //     .firstWhere((b) =>
                                          //         b.id.toString() == value)
                                          //     .name;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Destination Branch',
                                        labelStyle: TextStyle(
                                          color: isDarkMode
                                              ? Colors.blue[300]
                                              : Colors.blue[700],
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        filled: true,
                                        fillColor: context.palette.surfaceMuted,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: unitController,
                                      style: TextStyle(
                                        color: context.palette.textPrimary,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Unit',
                                        labelStyle: TextStyle(
                                          color: isDarkMode
                                              ? Colors.blue[300]
                                              : Colors.blue[700],
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        filled: true,
                                        fillColor: context.palette.surfaceMuted,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: milesPerUnitController,
                                      style: TextStyle(
                                        color: context.palette.textPrimary,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Miles/Unit',
                                        labelStyle: TextStyle(
                                          color: isDarkMode
                                              ? Colors.blue[300]
                                              : Colors.blue[700],
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        filled: true,
                                        fillColor: context.palette.surfaceMuted,
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed:
                                  milesConfigState is MilesConfigurationLoading
                                      ? null // Disable when loading
                                      : () => Navigator.of(context).pop(),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: context.palette.textSecondary,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: milesConfigState
                                      is MilesConfigurationLoading
                                  ? null // Disable when loading
                                  : () {
                                      if (selectedOriginBranch != null &&
                                          selectedDestinationBranch != null &&
                                          unitController.text.isNotEmpty &&
                                          milesPerUnitController
                                              .text.isNotEmpty) {
                                        context
                                            .read<MilesConfigurationBloc>()
                                            .add(AddNewMilesConfiguration(
                                                originBranchId: int.parse(
                                                    selectedOriginBranch!),
                                                destinationBranchId: int.parse(
                                                    selectedDestinationBranch!),
                                                unit: unitController.text,
                                                milesPerUnit: int.parse(
                                                    milesPerUnitController
                                                        .text)));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text('Please fill all fields'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child:
                                  milesConfigState is MilesConfigurationLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        )
                                      : const Text('Save'),
                            ),
                          ],
                        ),
                        if (milesConfigState is MilesConfigurationLoading)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black.withOpacity(0.3),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                );
              }

              return Center(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text('Failed to load branches'),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
