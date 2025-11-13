import 'package:courier_app/configuration/auth_service.dart';
import 'package:courier_app/features/transaction_hq_to_branch/bloc/transaction_hq_to_branch_bloc.dart';
import 'package:courier_app/features/transaction_hq_to_branch/presentation/widgets/transaction_hq_to_branch_table.dart';
import 'package:courier_app/features/branches/bloc/branches_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TransactionHqToBranchScreen extends StatefulWidget {
  const TransactionHqToBranchScreen({super.key});

  @override
  State<TransactionHqToBranchScreen> createState() =>
      _TransactionHqToBranchScreenState();
}

class _TransactionHqToBranchScreenState
    extends State<TransactionHqToBranchScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 90));
  DateTime _endDate = DateTime.now();
  int? _selectedBranchId;
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
      _fetchTransactions();
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2015),
      lastDate: _endDate,
      builder: (context, child) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFFFF5a00),
              onPrimary: Colors.white,
              surface: isDarkMode ? Colors.grey[850]! : Colors.white,
              onSurface: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        if (_startDate.isAfter(_endDate)) {
          _endDate = _startDate;
        }
      });
      _fetchTransactions();
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime.now(),
      builder: (context, child) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFFFF5a00),
              onPrimary: Colors.white,
              surface: isDarkMode ? Colors.grey[850]! : Colors.white,
              onSurface: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
        if (_endDate.isBefore(_startDate)) {
          _startDate = _endDate;
        }
      });
      _fetchTransactions();
    }
  }

  void _fetchTransactions() {
    if (_selectedBranchId != null) {
      final startDateString = DateFormat('yyyy-MM-dd').format(_startDate);
      final endDateString = DateFormat('yyyy-MM-dd').format(_endDate);
      context.read<TransactionHqToBranchBloc>().add(
            FetchTransactions(
              branchId: _selectedBranchId!,
              startDate: startDateString,
              endDate: endDateString,
            ),
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
                      'Transaction HQ to Branch',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const Spacer(),
                    // Export Button (placeholder)
                    IconButton(
                      icon: Icon(
                        Icons.file_download,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      onPressed: () {
                        // TODO: Implement export functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Export functionality coming soon'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Date Range and Branch Selector
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Date Range Pickers
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectStartDate(context),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color:
                                        isDarkMode ? Colors.white : Colors.black87,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Starting Date',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isDarkMode
                                                ? Colors.white70
                                                : Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          DateFormat('MMM dd, yyyy')
                                              .format(_startDate),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color:
                                        isDarkMode ? Colors.white : Colors.black87,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectEndDate(context),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color:
                                        isDarkMode ? Colors.white : Colors.black87,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Ending Date',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isDarkMode
                                                ? Colors.white70
                                                : Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          DateFormat('MMM dd, yyyy')
                                              .format(_endDate),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color:
                                        isDarkMode ? Colors.white : Colors.black87,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
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
                              });
                              _fetchTransactions();
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Main Content
              Expanded(
                child: BlocBuilder<TransactionHqToBranchBloc,
                    TransactionHqToBranchState>(
                  builder: (context, state) {
                    if (state is FetchTransactionsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is FetchTransactionsSuccess) {
                      final transactions = state.transactions;

                      if (transactions.data.isEmpty) {
                        return Center(
                          child: Text(
                            'No transactions found',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: [
                          // Summary Info
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Date Range',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDarkMode
                                            ? Colors.white70
                                            : Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${DateFormat('MMM dd, yyyy').format(_startDate)} — ${DateFormat('MMM dd, yyyy').format(_endDate)}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Total Transactions',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDarkMode
                                            ? Colors.white70
                                            : Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      transactions.data.length.toString(),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Transactions Table
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TransactionHqToBranchTable(
                                transactions: transactions.data,
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    if (state is FetchTransactionsError) {
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
                              onPressed: _fetchTransactions,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    return Center(
                      child: Text(
                        'Select a branch and date range to view transactions',
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
}

