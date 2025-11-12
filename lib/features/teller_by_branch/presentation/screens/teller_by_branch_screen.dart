import 'package:courier_app/configuration/auth_service.dart';
import 'package:courier_app/features/teller_by_branch/bloc/teller_by_branch_bloc.dart';
import 'package:courier_app/features/teller_by_branch/data/model/teller_by_branch_model.dart';
import 'package:courier_app/features/teller_by_branch/presentation/widgets/teller_by_branch_table.dart';
import 'package:courier_app/features/branches/bloc/branches_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TellerByBranchScreen extends StatefulWidget {
  const TellerByBranchScreen({super.key});

  @override
  State<TellerByBranchScreen> createState() => _TellerByBranchScreenState();
}

class _TellerByBranchScreenState extends State<TellerByBranchScreen> {
  final TextEditingController _searchController = TextEditingController();
  int? _selectedBranchId;
  String? _selectedStatus; // null means "All Statuses"
  int _currentPage = 0;
  static const int _itemsPerPage = 10;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _initializeData();
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
      _fetchTellers();
    }
  }

  void _fetchTellers() {
    if (_selectedBranchId != null) {
      context.read<TellerByBranchBloc>().add(
            FetchTellersByBranch(branchId: _selectedBranchId!),
          );
    }
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
                      'Tellers By Branch',
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Branch Selector
                    BlocBuilder<BranchesBloc, BranchesState>(
                      builder: (context, state) {
                        if (state is FetchBranchesLoaded) {
                          return DropdownButtonFormField<int>(
                            value: _selectedBranchId,
                            decoration: InputDecoration(
                              labelText: 'Select Branch',
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
                            dropdownColor: isDarkMode
                                ? const Color(0xFF1A1C2E)
                                : Colors.white,
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            items: state.branches.map((branch) {
                              return DropdownMenuItem<int>(
                                value: branch.id,
                                child: Text(
                                  '${branch.name} (${branch.code})',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedBranchId = value;
                                _currentPage = 0;
                              });
                              _fetchTellers();
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 12),
                    // Status Filter
                    DropdownButtonFormField<String>(
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
                          value: 'ASSIGNED',
                          child: Text('ASSIGNED'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'UNASSIGNED',
                          child: Text('UNASSIGNED'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedStatus = value;
                          _currentPage = 0;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    // Search Bar
                    TextField(
                      controller: _searchController,
                      onChanged: (query) {
                        setState(() {
                          _currentPage = 0;
                        });
                      },
                      decoration: InputDecoration(
                        hintText:
                            'Search by teller name, account number, branch...',
                        prefixIcon: Icon(
                          Icons.search,
                          color: isDarkMode ? Colors.grey : Colors.grey[600],
                        ),
                        filled: true,
                        fillColor: isDarkMode
                            ? Colors.white.withOpacity(0.1)
                            : Colors.white.withOpacity(0.9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 2),
                        ),
                      ),
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Main Content
              Expanded(
                child: BlocBuilder<TellerByBranchBloc, TellerByBranchState>(
                  builder: (context, state) {
                    if (state is FetchTellersByBranchLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is FetchTellersByBranchSuccess) {
                      final filteredTellers =
                          _getFilteredTellers(state.tellers);

                      if (filteredTellers.isEmpty) {
                        return Center(
                          child: Text(
                            'No tellers found',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        );
                      }

                      final totalPages =
                          (filteredTellers.length / _itemsPerPage).ceil();
                      // Ensure current page is within valid range
                      if (_currentPage >= totalPages) {
                        _currentPage = totalPages > 0 ? totalPages - 1 : 0;
                      }
                      final paginatedTellers =
                          _getPaginatedTellers(filteredTellers);

                      return Column(
                        children: [
                          Expanded(
                            child:
                                TellerByBranchTable(tellers: paginatedTellers),
                          ),
                          // Pagination Controls
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.chevron_left,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  onPressed: _currentPage > 0
                                      ? () {
                                          setState(() {
                                            _currentPage--;
                                          });
                                        }
                                      : null,
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'Page ${_currentPage + 1} of ${totalPages == 0 ? 1 : totalPages}',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                IconButton(
                                  icon: Icon(
                                    Icons.chevron_right,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  onPressed: _currentPage < totalPages - 1
                                      ? () {
                                          setState(() {
                                            _currentPage++;
                                          });
                                        }
                                      : null,
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'Total: ${filteredTellers.length}',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white70
                                        : Colors.black87,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }

                    if (state is FetchTellersByBranchError) {
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
                              onPressed: _fetchTellers,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    return Center(
                      child: Text(
                        'Select a branch to view tellers',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<TellerByBranchWithStatus> _getFilteredTellers(
      List<TellerByBranchWithStatus> allTellers) {
    List<TellerByBranchWithStatus> filtered = allTellers;

    // Filter by status
    if (_selectedStatus != null) {
      filtered = filtered
          .where((tellerWithStatus) =>
              tellerWithStatus.teller.status == _selectedStatus ||
              tellerWithStatus.accountStatus?.tellerStatus == _selectedStatus)
          .toList();
    }

    // Filter by search query
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((tellerWithStatus) {
        final teller = tellerWithStatus.teller;
        final status = tellerWithStatus.accountStatus;
        final matchesTellerName =
            teller.tellerName.toLowerCase().contains(query);
        final matchesAccountNumber =
            teller.accountNumber.toLowerCase().contains(query);
        final matchesBranchName =
            teller.getBranchName().toLowerCase().contains(query);
        final matchesAssignedUser =
            status?.assignedUserFullName?.toLowerCase().contains(query) ??
                false;
        return matchesTellerName ||
            matchesAccountNumber ||
            matchesBranchName ||
            matchesAssignedUser;
      }).toList();
    }

    return filtered;
  }

  List<TellerByBranchWithStatus> _getPaginatedTellers(
      List<TellerByBranchWithStatus> tellers) {
    if (tellers.isEmpty) return [];
    final startIndex = _currentPage * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, tellers.length);
    if (startIndex >= tellers.length) return [];
    return tellers.sublist(startIndex, endIndex);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
