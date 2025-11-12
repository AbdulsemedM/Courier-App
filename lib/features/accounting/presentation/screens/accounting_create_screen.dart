import 'package:courier_app/features/tellers/presentation/widget/teller_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:courier_app/features/tellers/bloc/tellers_bloc.dart';
import 'package:courier_app/features/tellers/model/teller_model.dart';
import 'package:courier_app/features/tellers/presentation/widget/add_teller_modal.dart';
import 'package:courier_app/features/branches/bloc/branches_bloc.dart';

class AccountingCreateScreen extends StatefulWidget {
  const AccountingCreateScreen({super.key});

  @override
  State<AccountingCreateScreen> createState() => _AccountingCreateScreenState();
}

class _AccountingCreateScreenState extends State<AccountingCreateScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedBranchName; // null means "All Branches"

  @override
  void initState() {
    super.initState();
    // Fetch branches first, then tellers
    context.read<BranchesBloc>().add(FetchBranches());
    context.read<TellersBloc>().add(FetchTellers());
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
                      'Create',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () => _showAddTellerModal(context),
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

              // Branch Filter Dropdown
              BlocBuilder<BranchesBloc, BranchesState>(
                builder: (context, state) {
                  if (state is FetchBranchesLoaded) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonFormField<String>(
                        value: _selectedBranchName,
                        decoration: InputDecoration(
                          labelText: 'Filter by Branch',
                          hintText: 'All Branches',
                          prefixIcon: const Icon(Icons.filter_list),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: isDarkMode
                              ? Colors.white.withOpacity(0.1)
                              : Colors.white.withOpacity(0.9),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        dropdownColor:
                            isDarkMode ? const Color(0xFF1A1C2E) : Colors.white,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('All Branches'),
                          ),
                          ...state.branches.map((branch) {
                            return DropdownMenuItem<String>(
                              value: branch.name,
                              child: Text('${branch.name} (${branch.code})'),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedBranchName = value;
                            _applyFilters();
                          });
                        },
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 8),

              // Search Bar
              SearchBarWidget(
                controller: _searchController,
                onChanged: (query) {
                  _filterTellers(query);
                },
              ),

              // Main Content
              Expanded(
                child: BlocBuilder<TellersBloc, TellersState>(
                  builder: (context, state) {
                    if (state is FetchTellersLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is FetchTellersSuccess) {
                      final tellers = _getFilteredTellers(state.tellers);

                      if (tellers.isEmpty) {
                        return Center(
                          child: Text(
                            'No tellers found',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        );
                      }

                      return TellersTable(
                        tellers: tellers,
                        onEdit: (teller) => _handleEdit(context, teller),
                        onDelete: (teller) => _handleDelete(context, teller),
                      );
                    }

                    if (state is FetchTellersError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Error: ${state.message}',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.read<TellersBloc>().add(FetchTellers());
                              },
                              child: const Text('Retry'),
                            ),
                          ],
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

  List<TellerModel> _getFilteredTellers(List<TellerModel> allTellers) {
    List<TellerModel> filtered = allTellers;

    // Filter by branch if selected
    if (_selectedBranchName != null) {
      filtered = filtered
          .where((teller) => teller.branchName == _selectedBranchName)
          .toList();
    }

    // Filter by search query if provided
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered
          .where((teller) =>
              teller.tellerName.toLowerCase().contains(query) ||
              teller.branchName.toLowerCase().contains(query) ||
              teller.branchCode.toLowerCase().contains(query))
          .toList();
    }

    return filtered;
  }

  void _filterTellers(String query) {
    setState(() {
      // The filtering is handled by _getFilteredTellers
    });
  }

  void _applyFilters() {
    setState(() {
      // Trigger rebuild to apply filters
    });
  }

  Future<void> _showAddTellerModal(BuildContext context) async {
    final success = await showDialog<bool>(
      context: context,
      builder: (context) => const AddTellerModal(),
    );

    if (success == true && mounted) {
      context.read<TellersBloc>().add(FetchTellers());
    }
  }

  void _handleEdit(BuildContext context, TellerModel teller) {
    // Edit functionality can be implemented later if needed
  }

  void _handleDelete(BuildContext context, TellerModel teller) {
    // Delete functionality can be implemented later if needed
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
