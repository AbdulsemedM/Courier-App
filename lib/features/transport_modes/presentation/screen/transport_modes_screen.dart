import 'package:courier_app/features/transport_modes/model/transport_modes_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:courier_app/core/theme/app_palette.dart';
import '../../bloc/transport_modes_bloc.dart';
import '../widget/transport_modes_widget.dart';
import '../widget/add_transport_mode_modal.dart';

class TransportModesScreen extends StatefulWidget {
  const TransportModesScreen({super.key});

  @override
  State<TransportModesScreen> createState() => _TransportModesScreenState();
}

class _TransportModesScreenState extends State<TransportModesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<TransportModesModel> _filteredModes = [];

  @override
  void initState() {
    super.initState();
    context.read<TransportModesBloc>().add(FetchTransportModes());
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;

    return Scaffold(
      backgroundColor: context.isDarkMode ? const Color(0xFF5B3895) : context.palette.background,
      body: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: context.palette.textPrimary,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Transport Modes',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: context.palette.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () => _showAddTransportModeModal(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Add'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.palette.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Search Bar
              SearchBarWidget(
                controller: _searchController,
                onChanged: _filterTransportModes,
              ),

              // Main Content
              Expanded(
                child: BlocBuilder<TransportModesBloc, TransportModesState>(
                  builder: (context, state) {
                    if (state is FetchTransportModesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is FetchTransportModesSuccess) {
                      final modes = _searchController.text.isEmpty
                          ? state.transportModes
                          : _filteredModes;
                      return TransportModesTable(
                        transportModes: modes,
                        onEdit: (mode) => _handleEdit(context, mode),
                        onDelete: (mode) => _handleDelete(context, mode),
                      );
                    }

                    if (state is FetchTransportModesFailure) {
                      return Center(
                        child: Text(
                          'Error: ${state.message}',
                          style: TextStyle(
                            color: context.palette.textPrimary,
                          ),
                        ),
                      );
                    }

                    return const Center(child: Text('No data available'));
                  },
                ),
              ),
            ],
          ),
        ),
    );
  }

  void _filterTransportModes(String query) {
    final state = context.read<TransportModesBloc>().state;
    if (state is FetchTransportModesSuccess) {
      setState(() {
        _filteredModes = state.transportModes
            .where((mode) =>
                mode.mode.toLowerCase().contains(query.toLowerCase()) ||
                mode.description.toLowerCase().contains(query.toLowerCase()))
            .cast<TransportModesModel>()
            .toList();
      });
    }
  }

  Future<void> _showAddTransportModeModal(BuildContext context) async {
    final success = await showDialog<bool>(
      context: context,
      builder: (context) => const AddTransportModeModal(),
    );

    if (success == true && mounted) {
      context.read<TransportModesBloc>().add(FetchTransportModes());
    }
  }

  void _handleEdit(BuildContext context, TransportModesModel mode) {
    // Handle edit action
  }

  void _handleDelete(BuildContext context, TransportModesModel mode) {
    // Handle delete action
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
