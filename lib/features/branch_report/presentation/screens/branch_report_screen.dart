import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:courier_app/configuration/auth_service.dart';
import 'package:courier_app/features/branch_report/bloc/branch_report_bloc.dart';
import 'package:courier_app/features/branch_report/data/model/branch_shipment_model.dart';
import 'package:courier_app/features/branch_report/data/model/branch_shipment_report_summary.dart';
import 'package:courier_app/features/branches/bloc/branches_bloc.dart';
import 'package:courier_app/core/theme/app_palette.dart';

class BranchReportScreen extends StatefulWidget {
  const BranchReportScreen({super.key});

  @override
  State<BranchReportScreen> createState() => _BranchReportScreenState();
}

class _BranchReportScreenState extends State<BranchReportScreen> {
  late DateTime _startDate;
  late DateTime _endDate;
  int? _selectedBranchId;
  String? _branchName;
  final AuthService _authService = AuthService();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _startDate = DateTime(today.year, today.month, today.day);
    _endDate = _startDate;
    _initializeData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    context.read<BranchesBloc>().add(FetchBranches());
    final branch = await _authService.getBranch();
    if (branch != null) {
      setState(() {
        _selectedBranchId = int.tryParse(branch);
      });
      _fetchShipments();
    }
  }

  String _resolveBranchName(BranchReportLoaded? state) {
    if (state?.branchName != null && state!.branchName!.isNotEmpty) {
      return state.branchName!;
    }
    if (_branchName != null && _branchName!.isNotEmpty) {
      return _branchName!;
    }

    final branchesState = context.read<BranchesBloc>().state;
    if (branchesState is FetchBranchesLoaded && _selectedBranchId != null) {
      for (final branch in branchesState.branches) {
        if (branch.id == _selectedBranchId) {
          return branch.name;
        }
      }
    }

    return 'Branch';
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final picked = await _pickDate(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2015),
      lastDate: _endDate,
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        if (_startDate.isAfter(_endDate)) {
          _endDate = _startDate;
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final picked = await _pickDate(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
        if (_endDate.isBefore(_startDate)) {
          _startDate = _endDate;
        }
      });
    }
  }

  Future<DateTime?> _pickDate({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: context.palette.accent,
              onPrimary: Colors.white,
              surface: context.palette.surface,
              onSurface: context.palette.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  void _fetchShipments() {
    if (_selectedBranchId == null) return;

    final startDateString = DateFormat('yyyy-MM-dd').format(_startDate);
    final endDateString = DateFormat('yyyy-MM-dd').format(_endDate);
    context.read<BranchReportBloc>().add(
          FetchBranchShipments(
            branchId: _selectedBranchId!,
            startDate: startDateString,
            endDate: endDateString,
          ),
        );
  }

  List<BranchShipmentModel> _filterShipments(
    List<BranchShipmentModel> shipments,
  ) {
    final query = _searchController.text.trim();
    if (query.isEmpty) return shipments;
    return shipments.where((shipment) => shipment.matchesSearch(query)).toList();
  }

  void _onSearchChanged(String value) {
    setState(() {});
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {});
  }

  Future<void> _copyAwb(String? awb) async {
    final value = awb?.trim();
    if (value == null || value.isEmpty) return;

    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('AWB copied: $value')),
    );
  }

  Future<void> _exportReport(
    List<BranchShipmentModel> shipments,
    String branchName,
  ) async {
    if (shipments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No shipments to export')),
      );
      return;
    }

    try {
      final buffer = StringBuffer(
        'Shipment ID,Sender,Sender Mobile,Receiver,Receiver Mobile,Qty,Status,Payment Method,Amount,Staff,Branch\n',
      );

      for (final shipment in shipments) {
        buffer.writeln([
          _csvCell(shipment.awb),
          _csvCell(shipment.senderName),
          _csvCell(shipment.senderMobileDisplay),
          _csvCell(shipment.receiverName),
          _csvCell(shipment.receiverMobileDisplay),
          _csvCell(shipment.qty?.toString()),
          _csvCell(shipment.statusCode),
          _csvCell(shipment.paymentMethodCode),
          _csvCell(shipment.feeAmount.toStringAsFixed(0)),
          _csvCell(shipment.addedByName),
          _csvCell(shipment.branchDisplayName ?? branchName),
        ].join(','));
      }

      final directory = await getTemporaryDirectory();
      final fileName =
          'branch_report_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv';
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(buffer.toString());

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exported to ${file.path}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
    }
  }

  String _csvCell(String? value) {
    final safe = (value ?? '').replaceAll('"', '""');
    return '"$safe"';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.palette.appBarBackground,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.palette.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Branch Shipment Report',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: context.palette.textPrimary,
          ),
        ),
      ),
      body: BlocListener<BranchesBloc, BranchesState>(
        listener: (context, state) {
          if (state is FetchBranchesLoaded && _selectedBranchId != null) {
            final branch = state.branches.firstWhere(
              (item) => item.id == _selectedBranchId,
              orElse: () => state.branches.first,
            );
            if (mounted) {
              setState(() => _branchName = branch.name);
            }
          }
        },
        child: BlocBuilder<BranchReportBloc, BranchReportState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildFilterSection(),
                  if (state is BranchReportLoading)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 64),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: context.palette.accent,
                        ),
                      ),
                    )
                  else if (state is BranchReportError)
                    _buildErrorState(state.message)
                  else if (state is BranchReportLoaded) ...[
                    Builder(
                      builder: (context) {
                        final branchName = _resolveBranchName(state);
                        final filteredShipments =
                            _filterShipments(state.shipments);
                        final hasSearch =
                            _searchController.text.trim().isNotEmpty;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildHeaderCard(
                              branchName: branchName,
                              onExport: () => _exportReport(
                                filteredShipments,
                                branchName,
                              ),
                            ),
                            _buildSearchBar(),
                            _buildSummaryCards(state.summary),
                            if (filteredShipments.isEmpty)
                              _buildEmptyState(hasSearch: hasSearch)
                            else
                              _buildShipmentsTable(
                                shipments: filteredShipments,
                                branchName: branchName,
                              ),
                          ],
                        );
                      },
                    ),
                  ] else
                    const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.palette.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Options',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: context.palette.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDateField(
                  label: 'Starting Date',
                  date: _startDate,
                  onTap: () => _selectStartDate(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDateField(
                  label: 'Ending Date',
                  date: _endDate,
                  onTap: () => _selectEndDate(context),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: _fetchShipments,
                icon: Icon(Icons.refresh, color: context.palette.accent),
                label: Text(
                  'Refresh',
                  style: TextStyle(color: context.palette.accent),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  side: BorderSide(color: context.palette.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: context.palette.surfaceMuted,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.palette.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.palette.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MM/dd/yyyy').format(date),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: context.palette.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.calendar_today, color: context.palette.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard({
    required String branchName,
    required VoidCallback onExport,
  }) {
    final dateRange =
        '${DateFormat('yyyy-MM-dd').format(_startDate)} → ${DateFormat('yyyy-MM-dd').format(_endDate)}';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4F46E5),
            Color(0xFF7C3AED),
            Color(0xFF0D9488),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  branchName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  dateRange,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: onExport,
            icon: const Icon(Icons.download, size: 18),
            label: const Text('Export'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF22C55E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.palette.border),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search by AWB, sender phone, or receiver phone',
          hintStyle: TextStyle(
            color: context.palette.textSecondary,
            fontSize: 14,
          ),
          border: InputBorder.none,
          icon: Icon(Icons.search, color: context.palette.textSecondary),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: context.palette.textSecondary,
                  ),
                  onPressed: _clearSearch,
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildSummaryCards(BranchShipmentReportSummary summary) {
    final cards = [
      _SummaryCardData('Total Shipments', summary.totalShipments.toString(),
          const Color(0xFF2563EB)),
      _SummaryCardData('CASH', summary.cash.toString(), const Color(0xFF16A34A)),
      _SummaryCardData('COD', summary.cod.toString(), const Color(0xFFEA580C)),
      _SummaryCardData('EBIRR', summary.ebirr.toString(), const Color(0xFF9333EA)),
      _SummaryCardData('SAHAY', summary.sahay.toString(), const Color(0xFFDB2777)),
      _SummaryCardData(
        'Total Fee',
        summary.totalFee.toStringAsFixed(0),
        const Color(0xFF0D9488),
      ),
    ];

    return SizedBox(
      height: 96,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final card = cards[index];
          return Container(
            width: 140,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: card.color,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: card.color.withOpacity(0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  card.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  card.value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildShipmentsTable({
    required List<BranchShipmentModel> shipments,
    required String branchName,
  }) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.palette.surfaceMuted,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(
              context.palette.surface,
            ),
            dataRowColor: WidgetStateProperty.all(
              context.palette.surfaceMuted,
            ),
            columnSpacing: 24,
            columns: [
                _tableColumn('Shipment ID'),
                _tableColumn('Sender'),
                _tableColumn('Receiver'),
                _tableColumn('Qty'),
                _tableColumn('Status'),
                _tableColumn('Payment Method'),
                _tableColumn('Amount'),
                _tableColumn('Staff'),
                _tableColumn('Branch'),
              ],
              rows: shipments.map((shipment) {
                return DataRow(
                  color: WidgetStateProperty.all(context.palette.surfaceMuted),
                  cells: [
                    DataCell(
                      Text(
                        shipment.awb ?? '',
                        style: TextStyle(color: context.palette.textPrimary),
                      ),
                      onLongPress: () => _copyAwb(shipment.awb),
                    ),
                    DataCell(_buildContactCell(
                      name: shipment.senderName,
                      mobile: shipment.senderMobileDisplay,
                    )),
                    DataCell(_buildContactCell(
                      name: shipment.receiverName,
                      mobile: shipment.receiverMobileDisplay,
                    )),
                    DataCell(Text(
                      _formatQty(shipment.qty),
                      style: TextStyle(color: context.palette.textPrimary),
                    )),
                    DataCell(_buildStatusBadge(shipment.statusCode)),
                    DataCell(Text(
                      shipment.paymentMethodCode,
                      style: TextStyle(
                        color: context.palette.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                    DataCell(Text(
                      shipment.feeAmount.toStringAsFixed(0),
                      style: TextStyle(color: context.palette.textPrimary),
                    )),
                    DataCell(Text(
                      shipment.addedByName,
                      style: TextStyle(color: context.palette.textPrimary),
                    )),
                    DataCell(Text(
                      shipment.branchDisplayName ?? branchName,
                      style: TextStyle(color: context.palette.textPrimary),
                    )),
                  ],
                );
              }).toList(),
          ),
        ),
      ),
    );
  }

  DataColumn _tableColumn(String label) {
    return DataColumn(
      label: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: context.palette.textPrimary,
        ),
      ),
    );
  }

  Widget _buildContactCell({String? name, required String mobile}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          (name ?? '').toUpperCase(),
          style: TextStyle(
            color: context.palette.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          mobile,
          style: TextStyle(
            color: context.palette.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String? status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: context.palette.surfaceMuted,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: context.palette.border),
      ),
      child: Text(
        status ?? 'N/A',
        style: TextStyle(
          color: context.palette.textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatQty(double? qty) {
    if (qty == null) return '0';
    if (qty == qty.roundToDouble()) {
      return qty.toInt().toString();
    }
    return qty.toString();
  }

  Widget _buildEmptyState({bool hasSearch = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        children: [
          Icon(
            hasSearch ? Icons.search_off : Icons.inbox_outlined,
            size: 64,
            color: context.palette.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            hasSearch
                ? 'No shipments match your search'
                : 'No shipments found',
            style: TextStyle(
              color: context.palette.textSecondary,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Error: $message',
            style: TextStyle(
              color: context.palette.textPrimary,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _fetchShipments,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.palette.accent,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _SummaryCardData {
  final String title;
  final String value;
  final Color color;

  const _SummaryCardData(this.title, this.value, this.color);
}
