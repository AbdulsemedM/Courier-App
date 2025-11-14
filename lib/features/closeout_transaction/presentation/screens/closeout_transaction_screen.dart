import 'package:courier_app/configuration/auth_service.dart';
import 'package:courier_app/features/closeout_transaction/bloc/closeout_transaction_bloc.dart';
import 'package:courier_app/features/closeout_transaction/presentation/widgets/closeout_transaction_table.dart';
import 'package:courier_app/features/teller_by_branch/bloc/teller_by_branch_bloc.dart';
import 'package:courier_app/features/teller_by_branch/data/model/teller_by_branch_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CloseoutTransactionScreen extends StatefulWidget {
  const CloseoutTransactionScreen({super.key});

  @override
  State<CloseoutTransactionScreen> createState() =>
      _CloseoutTransactionScreenState();
}

class _CloseoutTransactionScreenState extends State<CloseoutTransactionScreen> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  int? _selectedTellerId;
  final AuthService _authService = AuthService();
  int? _selectedBranchId;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Get user's branch as default
    final branch = await _authService.getBranch();
    if (branch != null) {
      setState(() {
        _selectedBranchId = int.tryParse(branch);
      });
      // Fetch tellers for the branch
      if (_selectedBranchId != null) {
        context.read<TellerByBranchBloc>().add(
              FetchTellersByBranch(branchId: _selectedBranchId!),
            );
      }
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
    if (_selectedTellerId != null) {
      final startDateStr = DateFormat('yyyy-MM-dd').format(_startDate);
      final endDateStr = DateFormat('yyyy-MM-dd').format(_endDate);
      context.read<CloseoutTransactionBloc>().add(
            FetchCloseoutTransactions(
              tellerId: _selectedTellerId!,
              startDate: startDateStr,
              endDate: endDateStr,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final dateFormat = DateFormat('MMM dd, yyyy');

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
                      'Closeout Transaction',
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
                    // Teller Selector
                    BlocBuilder<TellerByBranchBloc, TellerByBranchState>(
                      builder: (context, state) {
                        List<TellerByBranchWithStatus> tellers = [];
                        if (state is FetchTellersByBranchSuccess) {
                          tellers = state.tellers;
                        }

                        return DropdownButtonFormField<int>(
                          value: _selectedTellerId,
                          decoration: InputDecoration(
                            labelText: 'Select Teller',
                            hintText: 'Choose a teller',
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
                          dropdownColor:
                              isDarkMode ? const Color(0xFF1A1C2E) : Colors.white,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                          items: tellers.map((tellerWithStatus) {
                            return DropdownMenuItem<int>(
                              value: tellerWithStatus.teller.id,
                              child: Text(tellerWithStatus.teller.tellerName),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedTellerId = value;
                            });
                            _fetchTransactions();
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Date Range Selectors
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
                                border: Border.all(
                                  color: isDarkMode
                                      ? Colors.white.withOpacity(0.3)
                                      : Colors.grey.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: isDarkMode ? Colors.white : Colors.black,
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Start Date',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDarkMode
                                              ? Colors.white70
                                              : Colors.black54,
                                        ),
                                      ),
                                      Text(
                                        dateFormat.format(_startDate),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: isDarkMode ? Colors.white : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
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
                                border: Border.all(
                                  color: isDarkMode
                                      ? Colors.white.withOpacity(0.3)
                                      : Colors.grey.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: isDarkMode ? Colors.white : Colors.black,
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'End Date',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDarkMode
                                              ? Colors.white70
                                              : Colors.black54,
                                        ),
                                      ),
                                      Text(
                                        dateFormat.format(_endDate),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: isDarkMode ? Colors.white : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Transactions Table
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.1)
                        : Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: BlocBuilder<CloseoutTransactionBloc,
                      CloseoutTransactionState>(
                    builder: (context, state) {
                      if (state is CloseoutTransactionLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is CloseoutTransactionError) {
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
                                onPressed: _fetchTransactions,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }

                      if (state is CloseoutTransactionLoaded) {
                        if (state.transactions.data.isEmpty) {
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
                            // Summary Card
                            Container(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildSummaryCard(
                                    context,
                                    'Total Transactions',
                                    state.transactions.count.toString(),
                                    Icons.receipt_long,
                                  ),
                                  _buildSummaryCard(
                                    context,
                                    'Total Amount',
                                    _calculateTotalAmount(state.transactions.data),
                                    Icons.attach_money,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: CloseoutTransactionTable(
                                transactions: state.transactions.data,
                              ),
                            ),
                          ],
                        );
                      }

                      return Center(
                        child: Text(
                          'Select a teller and date range to view transactions',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
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

  String _calculateTotalAmount(List<dynamic> transactions) {
    final total = transactions.fold<double>(
      0.0,
      (sum, transaction) => sum + (transaction.amount ?? 0.0),
    );
    return NumberFormat.currency(symbol: '', decimalDigits: 2).format(total);
  }
}

