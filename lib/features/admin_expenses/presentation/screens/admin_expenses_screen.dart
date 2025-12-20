import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:courier_app/core/theme/theme_provider.dart';
import 'package:courier_app/features/admin_expenses/bloc/admin_expenses_bloc.dart';
import 'package:courier_app/features/branch_report/data/model/branch_shipment_model.dart';
import 'package:courier_app/features/branches/bloc/branches_bloc.dart';
import 'package:courier_app/features/branches/model/branches_model.dart';
import 'package:courier_app/configuration/auth_service.dart';

class AdminExpensesScreen extends StatefulWidget {
  const AdminExpensesScreen({super.key});

  @override
  State<AdminExpensesScreen> createState() => _AdminExpensesScreenState();
}

class _AdminExpensesScreenState extends State<AdminExpensesScreen> {
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
      if (_selectedBranchId != null) {
        _fetchExpenses();
      }
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
              primary: const Color(0xFFFF5A00),
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
      _fetchExpenses();
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
              primary: const Color(0xFFFF5A00),
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
      _fetchExpenses();
    }
  }

  void _fetchExpenses() {
    if (_selectedBranchId != null) {
      final fromDateString = DateFormat('yyyy-MM-dd').format(_fromDate);
      final toDateString = DateFormat('yyyy-MM-dd').format(_toDate);
      context.read<AdminExpensesBloc>().add(
            FetchAdminExpenses(
              branchId: _selectedBranchId!,
              fromDate: fromDateString,
              toDate: toDateString,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF1A1C2E) : const Color(0xFFF5F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkMode
            ? const Color.fromARGB(255, 91, 19, 207)
            : const Color(0xFF5b3895),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Admin Expenses',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [
                    const Color(0xFF1A1C2E),
                    const Color(0xFF2D3250),
                  ]
                : [
                    const Color(0xFFF5F6FA),
                    const Color(0xFFFFFFFF),
                  ],
          ),
        ),
        child: Column(
          children: [
            // Filters Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.grey[850]!.withOpacity(0.5)
                    : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Branch Selector
                  BlocBuilder<BranchesBloc, BranchesState>(
                    builder: (context, state) {
                      List<BranchesModel> branches = [];
                      if (state is FetchBranchesLoaded) {
                        branches = state.branches;
                      }

                      return DropdownButtonFormField<int>(
                        value: _selectedBranchId,
                        decoration: InputDecoration(
                          labelText: 'Select Branch',
                          hintText: 'Choose a branch',
                          prefixIcon: const Icon(Icons.business),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: isDarkMode
                              ? Colors.grey[800]
                              : Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        dropdownColor:
                            isDarkMode ? const Color(0xFF1A1C2E) : Colors.white,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                        items: branches.map((branch) {
                          return DropdownMenuItem<int>(
                            value: branch.id,
                            child: Text('${branch.name} (${branch.code})'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedBranchId = value;
                          });
                          _fetchExpenses();
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  // Date Range Selection
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectFromDate(context),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Colors.grey[800]
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDarkMode
                                    ? Colors.grey[700]!
                                    : Colors.grey[300]!,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'From Date',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDarkMode
                                            ? Colors.white70
                                            : Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      DateFormat('MMM dd, yyyy').format(_fromDate),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.calendar_today,
                                  color: isDarkMode
                                      ? Colors.white70
                                      : Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectToDate(context),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Colors.grey[800]
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDarkMode
                                    ? Colors.grey[700]!
                                    : Colors.grey[300]!,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'To Date',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDarkMode
                                            ? Colors.white70
                                            : Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      DateFormat('MMM dd, yyyy').format(_toDate),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.calendar_today,
                                  color: isDarkMode
                                      ? Colors.white70
                                      : Colors.black54,
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
            // Expenses Table
            Expanded(
              child: BlocBuilder<AdminExpensesBloc, AdminExpensesState>(
                builder: (context, state) {
                  if (state is AdminExpensesLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: const Color(0xFFFF5A00),
                      ),
                    );
                  }
                  if (state is AdminExpensesError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${state.message}',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black87,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _fetchExpenses,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF5A00),
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is AdminExpensesLoaded) {
                    if (state.shipments.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 64,
                              color: isDarkMode
                                  ? Colors.white38
                                  : Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No expenses found',
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.white70
                                    : Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Column(
                      children: [
                        // Summary Cards
                        _buildSummaryCards(
                          isDarkMode: isDarkMode,
                          shipments: state.shipments,
                        ),
                        // Shipments Table
                        Expanded(
                          child: _buildShipmentsTable(
                            isDarkMode: isDarkMode,
                            shipments: state.shipments,
                          ),
                        ),
                      ],
                    );
                  }
                  return Center(
                    child: Text(
                      _selectedBranchId == null
                          ? 'Please select a branch to view expenses'
                          : 'No data available',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards({
    required bool isDarkMode,
    required List<BranchShipmentModel> shipments,
  }) {
    int totalShipments = shipments.length;
    double totalQuantity = shipments.fold(0.0, (sum, s) => sum + (s.qty ?? 0));
    String unit = shipments.isNotEmpty ? shipments.first.unit ?? 'kg' : 'kg';
    double totalNetFee = shipments.fold(0.0, (sum, s) => sum + (s.netFee ?? 0));

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              isDarkMode: isDarkMode,
              title: 'Total Shipments',
              value: totalShipments.toString(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              isDarkMode: isDarkMode,
              title: 'Total Quantity',
              value: '${totalQuantity.toStringAsFixed(0)} $unit',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              isDarkMode: isDarkMode,
              title: 'Total Net Fee',
              value: NumberFormat.currency(symbol: '', decimalDigits: 2)
                  .format(totalNetFee),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required bool isDarkMode,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShipmentsTable({
    required bool isDarkMode,
    required List<BranchShipmentModel> shipments,
  }) {
    final currencyFormat =
        NumberFormat.currency(symbol: 'ETB ', decimalDigits: 2);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            headingRowColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) =>
                  isDarkMode ? const Color(0xFF0F172A) : Colors.blue[50]!,
            ),
            dataRowColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return isDarkMode
                      ? Colors.blue.withOpacity(0.1)
                      : Colors.blue[100]!;
                }
                return isDarkMode ? const Color(0xFF1E293B) : Colors.white;
              },
            ),
            columns: [
              DataColumn(
                label: Text(
                  'AWB',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Sender',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Receiver',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Qty',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Net Fee',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Total Amount',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Status',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Created At',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            rows: shipments.map((shipment) {
              final createdAt = shipment.createdAt != null
                  ? DateTime.tryParse(shipment.createdAt!)
                  : null;
              return DataRow(
                cells: [
                  DataCell(Text(
                    shipment.awb ?? 'N/A',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  )),
                  DataCell(Text(
                    shipment.senderName ?? 'N/A',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  )),
                  DataCell(Text(
                    shipment.receiverName ?? 'N/A',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  )),
                  DataCell(Text(
                    '${shipment.qty ?? 0} ${shipment.unit ?? 'kg'}',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  )),
                  DataCell(Text(
                    currencyFormat.format(shipment.netFee ?? 0),
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  )),
                  DataCell(Text(
                    currencyFormat.format(shipment.totalAmount ?? 0),
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  DataCell(Text(
                    shipment.shipmentStatus?.code ?? 'N/A',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  )),
                  DataCell(Text(
                    createdAt != null
                        ? DateFormat('MMM dd, yyyy').format(createdAt)
                        : 'N/A',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                      fontSize: 12,
                    ),
                  )),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

