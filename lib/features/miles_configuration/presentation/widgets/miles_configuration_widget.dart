import 'package:courier_app/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../add_shipment/bloc/add_shipment_bloc.dart';
import '../../models/miles_configuration_model.dart';
import 'package:provider/provider.dart';

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
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(12),
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
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  // Table header
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? const Color(0xFF0F172A)
                          : Colors.grey[100],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Row(
                      children: [
                        _buildHeaderCell('ID', 0.1, isDarkMode),
                        _buildHeaderCell('Origin Branch', 0.25, isDarkMode),
                        _buildHeaderCell(
                            'Destination Branch', 0.25, isDarkMode),
                        _buildHeaderCell('Unit', 0.15, isDarkMode),
                        _buildHeaderCell('Miles/Unit', 0.25, isDarkMode),
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
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                    ),
                    itemBuilder: (context, index) {
                      final config = configurations[index];
                      final isEven = index % 2 == 0;
                      return Container(
                        decoration: BoxDecoration(
                          color: isEven
                              ? (isDarkMode
                                  ? const Color(0xFF1E293B)
                                  : Colors.white)
                              : (isDarkMode
                                  ? const Color(0xFF0F172A)
                                  : Colors.grey[50]),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        child: Row(
                          children: [
                            _buildCell(config.id.toString(), 0.1, isDarkMode),
                            _buildCell(
                                config.originBranchName, 0.25, isDarkMode),
                            _buildCell(
                                config.destinationBranchName, 0.25, isDarkMode),
                            _buildCell(config.unit, 0.15, isDarkMode),
                            _buildCell(config.milesPerUnit.toString(), 0.25,
                                isDarkMode),
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

  static Widget _buildHeaderCell(String text, double flex, bool isDarkMode) {
    return Expanded(
      flex: (flex * 100).toInt(),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.blue[300] : Colors.blue[700],
        ),
      ),
    );
  }

  static Widget _buildCell(String text, double flex, bool isDarkMode) {
    return Expanded(
      flex: (flex * 100).toInt(),
      child: Text(
        text,
        style: TextStyle(
          color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  static Future<void> showAddMilesConfigModal(BuildContext context) async {
    final addShipmentBloc = context.read<AddShipmentBloc>();
    addShipmentBloc.add(FetchBranches());

    final TextEditingController unitController = TextEditingController();
    final TextEditingController milesPerUnitController =
        TextEditingController();
    String? selectedOriginBranch;
    String? selectedDestinationBranch;

    showDialog(
      context: context,
      builder: (context) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        final isDarkMode = themeProvider.isDarkMode;

        return BlocBuilder<AddShipmentBloc, AddShipmentState>(
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
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor:
                    isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                title: Text(
                  'Add Miles Configuration',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
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
                            dropdownColor: isDarkMode
                                ? const Color(0xFF1E293B)
                                : Colors.white,
                            items: state.branches.map((branch) {
                              return DropdownMenuItem(
                                value: branch.id.toString(),
                                child: Text(
                                  branch.name!,
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedOriginBranch = value;
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
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: isDarkMode
                                  ? const Color(0xFF0F172A)
                                  : Colors.grey[50],
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: selectedDestinationBranch,
                            dropdownColor: isDarkMode
                                ? const Color(0xFF1E293B)
                                : Colors.white,
                            items: state.branches.map((branch) {
                              return DropdownMenuItem(
                                value: branch.id.toString(),
                                child: Text(
                                  branch.name!,
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedDestinationBranch = value;
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
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: isDarkMode
                                  ? const Color(0xFF0F172A)
                                  : Colors.grey[50],
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: unitController,
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Unit',
                              labelStyle: TextStyle(
                                color: isDarkMode
                                    ? Colors.blue[300]
                                    : Colors.blue[700],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: isDarkMode
                                  ? const Color(0xFF0F172A)
                                  : Colors.grey[50],
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: milesPerUnitController,
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Miles/Unit',
                              labelStyle: TextStyle(
                                color: isDarkMode
                                    ? Colors.blue[300]
                                    : Colors.blue[700],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: isDarkMode
                                  ? const Color(0xFF0F172A)
                                  : Colors.grey[50],
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
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle save logic
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Save'),
                  ),
                ],
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
        );
      },
    );
  }
}
