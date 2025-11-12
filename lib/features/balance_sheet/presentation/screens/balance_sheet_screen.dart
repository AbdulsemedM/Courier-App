import 'package:courier_app/configuration/auth_service.dart';
import 'package:courier_app/features/balance_sheet/bloc/balance_sheet_bloc.dart';
import 'package:courier_app/features/balance_sheet/presentation/widgets/balance_sheet_widgets.dart';
import 'package:courier_app/features/branches/bloc/branches_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BalanceSheetScreen extends StatefulWidget {
  const BalanceSheetScreen({super.key});

  @override
  State<BalanceSheetScreen> createState() => _BalanceSheetScreenState();
}

class _BalanceSheetScreenState extends State<BalanceSheetScreen> {
  DateTime _selectedDate = DateTime.now();
  int? _selectedBranchId;
  bool _assetsExpanded = true;
  bool _liabilitiesExpanded = true;
  bool _equityExpanded = true;
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
      _fetchBalanceSheet();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015),
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _fetchBalanceSheet();
    }
  }

  void _fetchBalanceSheet() {
    if (_selectedBranchId != null) {
      final dateString = DateFormat('yyyy-MM-dd').format(_selectedDate);
      context.read<BalanceSheetBloc>().add(
            FetchBalanceSheet(
              branchId: _selectedBranchId!,
              asOfDate: dateString,
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
                      'Balance Sheet',
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

              // Date and Branch Selector
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Date Picker
                    InkWell(
                      onTap: () => _selectDate(context),
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
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'As Of Date',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDarkMode
                                          ? Colors.white70
                                          : Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('MMM dd, yyyy').format(_selectedDate),
                                    style: TextStyle(
                                      fontSize: 16,
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
                              _fetchBalanceSheet();
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
                child: BlocBuilder<BalanceSheetBloc, BalanceSheetState>(
                  builder: (context, state) {
                    if (state is FetchBalanceSheetLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is FetchBalanceSheetSuccess) {
                      final balanceSheet = state.balanceSheet;
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
                                  Text(
                                    'Report Date: ${DateFormat('MMMM dd, yyyy').format(DateTime.parse(balanceSheet.reportDate))}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDarkMode
                                          ? Colors.white70
                                          : Colors.grey[700],
                                    ),
                                  ),
                                  Text(
                                    'Branch ID: ${balanceSheet.branchId}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDarkMode
                                          ? Colors.white70
                                          : Colors.grey[700],
                                    ),
                                  ),
                                  Text(
                                    'Period: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(balanceSheet.fromDate))} - ${DateFormat('MMM dd, yyyy').format(DateTime.parse(balanceSheet.toDate))}',
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
                                  child: SummaryCard(
                                    title: 'Total Assets',
                                    amount: balanceSheet.totalAssets,
                                    color: Colors.blue,
                                    icon: Icons.account_balance_wallet,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: SummaryCard(
                                    title: 'Total Liabilities',
                                    amount: balanceSheet.totalLiabilities,
                                    color: Colors.orange,
                                    icon: Icons.account_balance,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: SummaryCard(
                                    title: 'Total Equity',
                                    amount: balanceSheet.totalEquity,
                                    color: Colors.green,
                                    icon: Icons.trending_up,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Assets Section
                            SectionHeader(
                              title: 'Assets',
                              subtitle: 'Current and fixed assets breakdown',
                              titleColor: Colors.blue,
                              isExpanded: _assetsExpanded,
                              onTap: () {
                                setState(() {
                                  _assetsExpanded = !_assetsExpanded;
                                });
                              },
                            ),
                            if (_assetsExpanded) ...[
                              const SizedBox(height: 8),
                              CategoryRow(
                                label: 'Cash and Bank',
                                amount: balanceSheet.assets.cashAndBank,
                              ),
                              CategoryRow(
                                label: 'Accounts Receivable',
                                amount: balanceSheet.assets.accountsReceivable,
                              ),
                              CategoryRow(
                                label: 'Inventory',
                                amount: balanceSheet.assets.inventory,
                              ),
                              CategoryRow(
                                label: 'Prepaid Expenses',
                                amount: balanceSheet.assets.prepaidExpenses,
                              ),
                              CategoryRow(
                                label: 'Current Assets',
                                amount: balanceSheet.assets.currentAssets,
                                isTotal: true,
                                backgroundColor: Colors.blue[50],
                              ),
                              CategoryRow(
                                label: 'Fixed Assets',
                                amount: balanceSheet.assets.fixedAssets,
                              ),
                              CategoryRow(
                                label: 'Total Assets',
                                amount: balanceSheet.assets.totalAssets,
                                isTotal: true,
                                backgroundColor: Colors.blue[100],
                              ),
                              if (balanceSheet.assets.assetItems.isNotEmpty)
                                BalanceSheetTable(
                                  items: balanceSheet.assets.assetItems,
                                ),
                            ],
                            const SizedBox(height: 16),

                            // Liabilities Section
                            SectionHeader(
                              title: 'Liabilities',
                              subtitle: 'Current and long-term liabilities breakdown',
                              titleColor: Colors.red,
                              isExpanded: _liabilitiesExpanded,
                              onTap: () {
                                setState(() {
                                  _liabilitiesExpanded = !_liabilitiesExpanded;
                                });
                              },
                            ),
                            if (_liabilitiesExpanded) ...[
                              const SizedBox(height: 8),
                              CategoryRow(
                                label: 'Accounts Payable',
                                amount: balanceSheet.liabilities.accountsPayable,
                              ),
                              CategoryRow(
                                label: 'Accrued Expenses',
                                amount: balanceSheet.liabilities.accruedExpenses,
                              ),
                              CategoryRow(
                                label: 'Short-term Debt',
                                amount: balanceSheet.liabilities.shortTermDebt,
                              ),
                              CategoryRow(
                                label: 'Current Liabilities',
                                amount: balanceSheet.liabilities.currentLiabilities,
                                isTotal: true,
                                backgroundColor: Colors.orange[50],
                              ),
                              CategoryRow(
                                label: 'Long-term Debt',
                                amount: balanceSheet.liabilities.longTermDebt,
                              ),
                              CategoryRow(
                                label: 'Total Liabilities',
                                amount: balanceSheet.liabilities.totalLiabilities,
                                isTotal: true,
                                backgroundColor: Colors.orange[100],
                              ),
                              if (balanceSheet.liabilities.liabilityItems.isNotEmpty)
                                BalanceSheetTable(
                                  items: balanceSheet.liabilities.liabilityItems,
                                ),
                            ],
                            const SizedBox(height: 16),

                            // Equity Section
                            SectionHeader(
                              title: 'Equity',
                              subtitle: "Owner's equity and retained earnings",
                              titleColor: Colors.green,
                              isExpanded: _equityExpanded,
                              onTap: () {
                                setState(() {
                                  _equityExpanded = !_equityExpanded;
                                });
                              },
                            ),
                            if (_equityExpanded) ...[
                              const SizedBox(height: 8),
                              CategoryRow(
                                label: 'Capital',
                                amount: balanceSheet.equity.capital,
                              ),
                              CategoryRow(
                                label: 'Retained Earnings',
                                amount: balanceSheet.equity.retainedEarnings,
                              ),
                              CategoryRow(
                                label: 'Current Year Profit',
                                amount: balanceSheet.equity.currentYearProfit,
                              ),
                              CategoryRow(
                                label: 'Total Equity',
                                amount: balanceSheet.equity.totalEquity,
                                isTotal: true,
                                backgroundColor: Colors.green[50],
                              ),
                              if (balanceSheet.equity.equityItems.isNotEmpty)
                                BalanceSheetTable(
                                  items: balanceSheet.equity.equityItems,
                                ),
                            ],
                            const SizedBox(height: 16),

                            // Balancing Amount
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: balanceSheet.balancingAmount < 0
                                    ? Colors.red.withOpacity(0.2)
                                    : Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: balanceSheet.balancingAmount < 0
                                      ? Colors.red
                                      : Colors.green,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Balancing Amount',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    'ETB ${NumberFormat.currency(symbol: '', decimalDigits: 2).format(balanceSheet.balancingAmount)}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: balanceSheet.balancingAmount < 0
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is FetchBalanceSheetError) {
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
                              onPressed: _fetchBalanceSheet,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    return Center(
                      child: Text(
                        'Select a branch and date to view balance sheet',
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

