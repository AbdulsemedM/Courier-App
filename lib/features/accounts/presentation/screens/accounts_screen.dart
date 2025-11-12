import 'package:courier_app/features/accounts/bloc/account_bloc.dart';
import 'package:courier_app/features/accounts/data/model/account_model.dart';
import 'package:courier_app/features/accounts/presentation/widgets/accounts_table.dart';
import 'package:courier_app/features/accounts/presentation/widgets/accounts_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedAccountType; // null means "All"
  int _currentPage = 0;
  static const int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to ensure context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AccountBloc>().add(FetchAccounts());
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
                      'Accounts',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              // Account Type Filter Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonFormField<String>(
                  value: _selectedAccountType,
                  decoration: InputDecoration(
                    labelText: 'Filter by Account Type',
                    hintText: 'All Account Types',
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
                      child: Text('All Account Types'),
                    ),
                    const DropdownMenuItem<String>(
                      value: 'BRANCH',
                      child: Text('BRANCH'),
                    ),
                    const DropdownMenuItem<String>(
                      value: 'BRANCH_EXPENSE',
                      child: Text('BRANCH_EXPENSE'),
                    ),
                    const DropdownMenuItem<String>(
                      value: 'TELLER',
                      child: Text('TELLER'),
                    ),
                    const DropdownMenuItem<String>(
                      value: 'HQ',
                      child: Text('HQ'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedAccountType = value;
                      _currentPage =
                          0; // Reset to first page when filter changes
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),

              // Search Bar
              SearchBarWidget(
                controller: _searchController,
                onChanged: (query) {
                  setState(() {
                    _currentPage = 0; // Reset to first page when search changes
                  });
                },
                hintText: 'Search by account number, branch, or teller...',
              ),

              // Main Content
              Expanded(
                child: BlocBuilder<AccountBloc, AccountState>(
                  builder: (context, state) {
                    if (state is FetchAccountsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is FetchAccountsSuccess) {
                      final filteredAccounts =
                          _getFilteredAccounts(state.accounts);

                      if (filteredAccounts.isEmpty) {
                        return Center(
                          child: Text(
                            'No accounts found',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        );
                      }

                      final totalPages =
                          (filteredAccounts.length / _itemsPerPage).ceil();
                      // Ensure current page is within valid range
                      if (_currentPage >= totalPages) {
                        _currentPage = totalPages > 0 ? totalPages - 1 : 0;
                      }
                      final paginatedAccounts =
                          _getPaginatedAccounts(filteredAccounts);

                      return Column(
                        children: [
                          Expanded(
                            child: AccountsTable(accounts: paginatedAccounts),
                          ),
                          // Pagination Controls
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Colors.black.withOpacity(0.2)
                                  : Colors.white.withOpacity(0.1),
                            ),
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
                                  'Total: ${filteredAccounts.length}',
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

                    if (state is FetchAccountsError) {
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
                                context
                                    .read<AccountBloc>()
                                    .add(FetchAccounts());
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

  List<AccountModel> _getFilteredAccounts(List<AccountModel> allAccounts) {
    List<AccountModel> filtered = allAccounts;

    // Filter by account type if selected
    if (_selectedAccountType != null) {
      filtered = filtered
          .where((account) => account.accountType == _selectedAccountType)
          .toList();
    }

    // Filter by search query if provided
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered
          .where((account) =>
              account.accountNumber.toLowerCase().contains(query) ||
              (account.branchName?.toLowerCase().contains(query) ?? false) ||
              (account.tellerName?.toLowerCase().contains(query) ?? false))
          .toList();
    }

    return filtered;
  }

  List<AccountModel> _getPaginatedAccounts(List<AccountModel> accounts) {
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
