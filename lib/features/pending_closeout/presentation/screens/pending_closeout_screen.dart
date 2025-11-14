import 'package:courier_app/configuration/auth_service.dart';
import 'package:courier_app/features/pending_closeout/bloc/pending_closeout_bloc.dart';
import 'package:courier_app/features/pending_closeout/data/model/pending_closeout_model.dart';
import 'package:courier_app/features/pending_closeout/presentation/widgets/pending_closeout_table.dart';
import 'package:courier_app/features/branches/bloc/branches_bloc.dart';
import 'package:courier_app/features/branches/model/branches_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PendingCloseoutScreen extends StatefulWidget {
  const PendingCloseoutScreen({super.key});

  @override
  State<PendingCloseoutScreen> createState() => _PendingCloseoutScreenState();
}

class _PendingCloseoutScreenState extends State<PendingCloseoutScreen> {
  final TextEditingController _searchController = TextEditingController();
  int? _selectedBranchId;
  String? _selectedStatus;
  final AuthService _authService = AuthService();
  List<PendingCloseout> _allPendingCloseouts = [];
  List<PendingCloseout> _filteredPendingCloseouts = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    // Fetch branches
    context.read<BranchesBloc>().add(FetchBranches());

    // Get user's branch as default
    final branch = await _authService.getBranch();
    if (branch != null) {
      setState(() {
        _selectedBranchId = int.tryParse(branch);
      });
      _fetchPendingCloseouts();
    } else {
      _fetchPendingCloseouts();
    }
  }

  void _fetchPendingCloseouts() {
    context.read<PendingCloseoutBloc>().add(
          FetchPendingCloseouts(
            branchId: _selectedBranchId,
          ),
        );
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      _filteredPendingCloseouts = _allPendingCloseouts.where((closeout) {
        // Branch filter
        if (_selectedBranchId != null && closeout.branchId != _selectedBranchId) {
          return false;
        }

        // Status filter
        if (_selectedStatus != null && closeout.status != _selectedStatus) {
          return false;
        }

        // Search filter
        final searchQuery = _searchController.text.toLowerCase();
        if (searchQuery.isNotEmpty) {
          final matchesSearch = closeout.tellerName.toLowerCase().contains(searchQuery) ||
              closeout.branchName.toLowerCase().contains(searchQuery) ||
              closeout.branchCode.toLowerCase().contains(searchQuery) ||
              closeout.transactionReference.toLowerCase().contains(searchQuery) ||
              closeout.reason.toLowerCase().contains(searchQuery) ||
              closeout.recordedByName.toLowerCase().contains(searchQuery) ||
              closeout.liabilityId.toString().contains(searchQuery);
          if (!matchesSearch) {
            return false;
          }
        }

        return true;
      }).toList();
    });
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
                      'Pending Closeout',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              // Filters Section
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Branch Filter
                    BlocBuilder<BranchesBloc, BranchesState>(
                      builder: (context, state) {
                        List<BranchesModel> branches = [];
                        if (state is FetchBranchesLoaded) {
                          branches = state.branches;
                        }

                        return DropdownButtonFormField<int>(
                          value: _selectedBranchId,
                          decoration: InputDecoration(
                            labelText: 'Filter by Branch',
                            hintText: 'All Branches',
                            prefixIcon: const Icon(Icons.business),
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
                            const DropdownMenuItem<int>(
                              value: null,
                              child: Text('All Branches'),
                            ),
                            ...branches.map((branch) {
                              return DropdownMenuItem<int>(
                                value: branch.id,
                                child: Text('${branch.name} (${branch.code})'),
                              );
                            }),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedBranchId = value;
                            });
                            _fetchPendingCloseouts();
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Status Filter and Search Row
                    Row(
                      children: [
                        // Status Filter
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedStatus,
                            decoration: InputDecoration(
                              labelText: 'Filter by Status',
                              hintText: 'All Statuses',
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
                            items: const [
                              DropdownMenuItem<String>(
                                value: null,
                                child: Text('All Statuses'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'PENDING',
                                child: Text('PENDING'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'APPROVED',
                                child: Text('APPROVED'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'REJECTED',
                                child: Text('REJECTED'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'RESOLVED',
                                child: Text('RESOLVED'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedStatus = value;
                              });
                              _applyFilters();
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Search Bar
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              labelText: 'Search',
                              hintText: 'Search by teller, branch, reference...',
                              prefixIcon: const Icon(Icons.search),
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
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Pending Closeouts Table
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.1)
                        : Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: BlocListener<PendingCloseoutBloc, PendingCloseoutState>(
                    listener: (context, state) {
                      if (state is PendingCloseoutLoaded) {
                        setState(() {
                          _allPendingCloseouts = state.pendingCloseouts.data;
                          _applyFilters();
                        });
                      }
                    },
                    child: BlocBuilder<PendingCloseoutBloc, PendingCloseoutState>(
                      builder: (context, state) {
                        if (state is PendingCloseoutLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (state is PendingCloseoutError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: isDarkMode ? Colors.white : Colors.red,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Error: ${state.message}',
                                  style: TextStyle(
                                    color: isDarkMode ? Colors.white : Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _fetchPendingCloseouts,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        }

                        if (state is PendingCloseoutLoaded || _filteredPendingCloseouts.isNotEmpty) {
                          if (_filteredPendingCloseouts.isEmpty) {
                            return Center(
                              child: Text(
                                'No pending closeouts found',
                                style: TextStyle(
                                  color: isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            );
                          }

                          return Column(
                            children: [
                              // Summary Card
                              Container(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildSummaryCard(
                                      context,
                                      'Total Pending',
                                      _filteredPendingCloseouts.length.toString(),
                                      Icons.pending_actions,
                                    ),
                                    _buildSummaryCard(
                                      context,
                                      'Total Shortfall',
                                      _calculateTotalShortfall(_filteredPendingCloseouts),
                                      Icons.trending_down,
                                    ),
                                    _buildSummaryCard(
                                      context,
                                      'Avg Days Pending',
                                      _calculateAvgDaysPending(_filteredPendingCloseouts),
                                      Icons.calendar_today,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: PendingCloseoutTable(
                                  pendingCloseouts: _filteredPendingCloseouts,
                                ),
                              ),
                            ],
                          );
                        }

                        return Center(
                          child: Text(
                            'No data available',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.white.withOpacity(0.1)
            : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.2)
              : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isDarkMode ? Colors.white : Colors.black,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  String _calculateTotalShortfall(List<PendingCloseout> closeouts) {
    final total = closeouts.fold<double>(
      0.0,
      (sum, closeout) => sum + closeout.shortfallAmount,
    );
    return NumberFormat.currency(symbol: '', decimalDigits: 2).format(total);
  }

  String _calculateAvgDaysPending(List<PendingCloseout> closeouts) {
    if (closeouts.isEmpty) return '0';
    final total = closeouts.fold<int>(
      0,
      (sum, closeout) => sum + closeout.daysPending,
    );
    final avg = (total / closeouts.length).round();
    return '$avg days';
  }
}

