import 'package:courier_app/features/teller_accounts/bloc/teller_account_bloc.dart';
import 'package:courier_app/features/teller_accounts/data/model/teller_account_model.dart';
import 'package:courier_app/features/teller_accounts/presentation/widgets/teller_accounts_table.dart';
import 'package:courier_app/features/branches/bloc/branches_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TellerAccountsScreen extends StatefulWidget {
  const TellerAccountsScreen({super.key});

  @override
  State<TellerAccountsScreen> createState() => _TellerAccountsScreenState();
}

class _TellerAccountsScreenState extends State<TellerAccountsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedAccountType = 'TELLER'; // Default to TELLER
  String? _selectedBranchName; // null means "All Branches"
  String? _selectedTellerStatus; // null means "All Statuses"
  int _currentPage = 0;
  static const int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    // Fetch branches
    context.read<BranchesBloc>().add(FetchBranches());
    // Fetch teller accounts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<TellerAccountBloc>().add(FetchTellerAccounts(accountType: _selectedAccountType!));
      }
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
                      'Teller Accounts',
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
                    // Account Type Filter
                    DropdownButtonFormField<String>(
                      value: _selectedAccountType,
                      decoration: InputDecoration(
                        labelText: 'Account Type',
                        prefixIcon: const Icon(Icons.account_balance),
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
                      items: const [
                        DropdownMenuItem<String>(
                          value: 'TELLER',
                          child: Text('TELLER'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'BRANCH',
                          child: Text('BRANCH'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'BRANCH_EXPENSE',
                          child: Text('BRANCH_EXPENSE'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'HQ',
                          child: Text('HQ'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedAccountType = value;
                          _currentPage = 0;
                        });
                        if (value != null) {
                          context.read<TellerAccountBloc>().add(
                                FetchTellerAccounts(accountType: value),
                              );
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    // Branch Filter
                    BlocBuilder<BranchesBloc, BranchesState>(
                      builder: (context, state) {
                        if (state is FetchBranchesLoaded) {
                          return DropdownButtonFormField<String>(
                            value: _selectedBranchName,
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
                            dropdownColor: isDarkMode
                                ? const Color(0xFF1A1C2E)
                                : Colors.white,
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
                                  child: Text(
                                    '${branch.name} (${branch.code})',
                                    style: TextStyle(
                                      color: isDarkMode ? Colors.white : Colors.black,
                                    ),
                                  ),
                                );
                              }),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedBranchName = value;
                                _currentPage = 0;
                              });
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 12),
                    // Teller Status Filter
                    DropdownButtonFormField<String>(
                      value: _selectedTellerStatus,
                      decoration: InputDecoration(
                        labelText: 'Filter by Teller Status',
                        hintText: 'All Statuses',
                        prefixIcon: const Icon(Icons.person),
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
                          _selectedTellerStatus = value;
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
                        hintText: 'Search by account number, teller name, branch...',
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
                          borderSide: const BorderSide(color: Colors.blue, width: 2),
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
                child: BlocBuilder<TellerAccountBloc, TellerAccountState>(
                  builder: (context, state) {
                    if (state is FetchTellerAccountsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is FetchTellerAccountsSuccess) {
                      final filteredAccounts = _getFilteredAccounts(state.accounts);

                      if (filteredAccounts.isEmpty) {
                        return Center(
                          child: Text(
                            'No teller accounts found',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        );
                      }

                      final totalPages = (filteredAccounts.length / _itemsPerPage).ceil();
                      // Ensure current page is within valid range
                      if (_currentPage >= totalPages) {
                        _currentPage = totalPages > 0 ? totalPages - 1 : 0;
                      }
                      final paginatedAccounts = _getPaginatedAccounts(filteredAccounts);

                      return Column(
                        children: [
                          Expanded(
                            child: TellerAccountsTable(accounts: paginatedAccounts),
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
                                    color: isDarkMode ? Colors.white : Colors.black,
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
                                    color: isDarkMode ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                IconButton(
                                  icon: Icon(
                                    Icons.chevron_right,
                                    color: isDarkMode ? Colors.white : Colors.black,
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
                                  'Total: ${filteredAccounts.length}',
                                  style: TextStyle(
                                    color: isDarkMode ? Colors.white70 : Colors.black87,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }

                    if (state is FetchTellerAccountsError) {
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
                                if (_selectedAccountType != null) {
                                  context.read<TellerAccountBloc>().add(
                                        FetchTellerAccounts(
                                            accountType: _selectedAccountType!),
                                      );
                                }
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

  List<TellerAccountModel> _getFilteredAccounts(List<TellerAccountModel> allAccounts) {
    List<TellerAccountModel> filtered = allAccounts;

    // Filter by branch
    if (_selectedBranchName != null) {
      filtered = filtered
          .where((account) => account.branchName == _selectedBranchName)
          .toList();
    }

    // Filter by teller status
    if (_selectedTellerStatus != null) {
      filtered = filtered
          .where((account) => account.tellerStatus == _selectedTellerStatus)
          .toList();
    }

    // Filter by search query
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((account) {
        final matchesAccountNumber =
            account.accountNumber.toLowerCase().contains(query);
        final matchesTellerName =
            account.tellerName.toLowerCase().contains(query);
        final matchesBranchName =
            account.branchName.toLowerCase().contains(query);
        return matchesAccountNumber || matchesTellerName || matchesBranchName;
      }).toList();
    }

    return filtered;
  }

  List<TellerAccountModel> _getPaginatedAccounts(List<TellerAccountModel> accounts) {
    if (accounts.isEmpty) return [];
    final startIndex = _currentPage * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, accounts.length);
    if (startIndex >= accounts.length) return [];
    return accounts.sublist(startIndex, endIndex);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

