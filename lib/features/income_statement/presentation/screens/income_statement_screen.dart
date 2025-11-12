import 'package:courier_app/configuration/auth_service.dart';
import 'package:courier_app/features/income_statement/bloc/income_statement_bloc.dart';
import 'package:courier_app/features/income_statement/presentation/widgets/income_statement_widgets.dart';
import 'package:courier_app/features/branches/bloc/branches_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class IncomeStatementScreen extends StatefulWidget {
  const IncomeStatementScreen({super.key});

  @override
  State<IncomeStatementScreen> createState() => _IncomeStatementScreenState();
}

class _IncomeStatementScreenState extends State<IncomeStatementScreen> {
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();
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
      _fetchIncomeStatement();
    }
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fromDate,
      firstDate: DateTime(2015),
      lastDate: _toDate,
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
    if (picked != null && picked != _fromDate) {
      setState(() {
        _fromDate = picked;
        if (_fromDate.isAfter(_toDate)) {
          _toDate = _fromDate;
        }
      });
      _fetchIncomeStatement();
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _toDate,
      firstDate: _fromDate,
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
    if (picked != null && picked != _toDate) {
      setState(() {
        _toDate = picked;
        if (_toDate.isBefore(_fromDate)) {
          _fromDate = _toDate;
        }
      });
      _fetchIncomeStatement();
    }
  }

  void _fetchIncomeStatement() {
    if (_selectedBranchId != null) {
      final fromDateString = DateFormat('yyyy-MM-dd').format(_fromDate);
      final toDateString = DateFormat('yyyy-MM-dd').format(_toDate);
      context.read<IncomeStatementBloc>().add(
            FetchIncomeStatement(
              branchId: _selectedBranchId!,
              fromDate: fromDateString,
              toDate: toDateString,
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
                      'Income Statement',
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
                            onTap: () => _selectFromDate(context),
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
                                    color: isDarkMode ? Colors.white : Colors.black87,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                          DateFormat('MMM dd, yyyy').format(_fromDate),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: isDarkMode ? Colors.white : Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: isDarkMode ? Colors.white : Colors.black87,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectToDate(context),
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
                                    color: isDarkMode ? Colors.white : Colors.black87,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                          DateFormat('MMM dd, yyyy').format(_toDate),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: isDarkMode ? Colors.white : Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: isDarkMode ? Colors.white : Colors.black87,
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
                                    color: isDarkMode ? Colors.white : Colors.black,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedBranchId = value;
                              });
                              _fetchIncomeStatement();
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
                child: BlocBuilder<IncomeStatementBloc, IncomeStatementState>(
                  builder: (context, state) {
                    if (state is FetchIncomeStatementLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is FetchIncomeStatementSuccess) {
                      final incomeStatement = state.incomeStatement;
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Report Info
                            Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Income Statement',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: isDarkMode ? Colors.white : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.purple.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          incomeStatement.branches.isNotEmpty
                                              ? incomeStatement.branches.first['name'] ?? 'N/A'
                                              : 'N/A',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.purple,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${DateFormat('MMM dd, yyyy').format(DateTime.parse(incomeStatement.fromDate))} — ${DateFormat('MMM dd, yyyy').format(DateTime.parse(incomeStatement.toDate))}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDarkMode
                                          ? Colors.white70
                                          : Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Summary Cards
                            Row(
                              children: [
                                Expanded(
                                  child: IncomeSummaryCard(
                                    title: 'Gross Revenue',
                                    amount: incomeStatement.grossRevenue,
                                    color: Colors.green,
                                    icon: Icons.trending_up,
                                    marginText:
                                        'Margin: ${NumberFormat.currency(symbol: '', decimalDigits: 2).format(incomeStatement.grossMargin)}%',
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: IncomeSummaryCard(
                                    title: 'Total Expenses',
                                    amount: incomeStatement.totalExpenses,
                                    color: Colors.red,
                                    icon: Icons.trending_down,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: IncomeSummaryCard(
                                    title: 'Net Income',
                                    amount: incomeStatement.netIncome,
                                    color: incomeStatement.netIncome >= 0
                                        ? Colors.green
                                        : Colors.red,
                                    icon: Icons.account_balance_wallet,
                                    marginText:
                                        'Margin: ${NumberFormat.currency(symbol: '', decimalDigits: 2).format(incomeStatement.netMargin)}%',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Revenue Breakdown
                            BreakdownSection(
                              title: 'Revenue Breakdown',
                              titleColor: Colors.green,
                              items: [
                                {
                                  'label': 'Shipment Fees',
                                  'amount': incomeStatement.revenue.shipmentFees,
                                  'hasCopy': true,
                                },
                                {
                                  'label': 'Delivery Fees',
                                  'amount': incomeStatement.revenue.deliveryFees,
                                },
                                {
                                  'label': 'Extra Fees',
                                  'amount': incomeStatement.revenue.extraFees,
                                },
                                {
                                  'label': 'Other Revenue',
                                  'amount': incomeStatement.revenue.otherRevenue,
                                },
                              ],
                              total: incomeStatement.revenue.totalRevenue,
                              isRevenue: true,
                            ),

                            // Expense Breakdown
                            BreakdownSection(
                              title: 'Expense Breakdown',
                              titleColor: Colors.red,
                              items: [
                                {
                                  'label': 'Operational',
                                  'amount': incomeStatement.expenses.operationalExpenses,
                                },
                                {
                                  'label': 'Personnel',
                                  'amount': incomeStatement.expenses.personnelExpenses,
                                },
                                {
                                  'label': 'Marketing',
                                  'amount': incomeStatement.expenses.marketingExpenses,
                                },
                                {
                                  'label': 'Depreciation',
                                  'amount': incomeStatement.expenses.depreciation,
                                },
                                {
                                  'label': 'Other',
                                  'amount': incomeStatement.expenses.otherExpenses,
                                },
                              ],
                              total: incomeStatement.expenses.totalExpenses,
                              isRevenue: false,
                            ),
                            const SizedBox(height: 16),

                            // Account Balances Section
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDarkMode ? Colors.grey[850] : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Account Balances',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  AccountBalancesTable(
                                    accounts: incomeStatement.accounts,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is FetchIncomeStatementError) {
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
                              onPressed: _fetchIncomeStatement,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    return Center(
                      child: Text(
                        'Select a branch and date range to view income statement',
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

