import 'package:courier_app/features/transport_modes/model/transport_modes_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [
                    const Color.fromARGB(255, 75, 23, 160),
                    const Color(0xFF5b3895),
                  ]
                : [
                    const Color.fromARGB(255, 75, 23, 160),
                    const Color(0xFF5b3895),
                  ],
          ),
        ),
        child: SafeArea(
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
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Transport Modes',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () => _showAddTransportModeModal(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Add'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5a00),
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
                            color: isDarkMode ? Colors.white : Colors.black,
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
