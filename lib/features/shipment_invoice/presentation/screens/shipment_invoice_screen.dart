import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:courier_app/core/services/shipment_invoice_pdf_generator.dart';
import 'package:courier_app/core/services/sunmi_invoice_printer.dart';
import 'package:courier_app/core/theme/app_palette.dart';
import 'package:courier_app/features/branches/bloc/branches_bloc.dart';
import 'package:printing/printing.dart';
import '../../bloc/shipment_invoice_bloc.dart';
import '../../model/shipment_invoice_model.dart';
import '../widgets/shipment_invoice_widget.dart';

class ShipmentInvoiceScreen extends StatefulWidget {
  const ShipmentInvoiceScreen({super.key});

  @override
  State<ShipmentInvoiceScreen> createState() => _ShipmentInvoiceScreenState();
}

class _ShipmentInvoiceScreenState extends State<ShipmentInvoiceScreen> {
  final _searchController = TextEditingController();
  bool _isSunmiDevice = false;
  bool _isDownloadingPdf = false;

  @override
  void initState() {
    super.initState();
    _checkIfSunmiDevice();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<BranchesBloc>().add(FetchBranches());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _checkIfSunmiDevice() async {
    final isSunmi = await SunmiInvoicePrinter.isSunmiDevice();
    if (mounted) {
      setState(() => _isSunmiDevice = isSunmi);
    }
  }

  void _onSearch() {
    final awb = _searchController.text.trim();
    if (awb.isNotEmpty) {
      context.read<ShipmentInvoiceBloc>().add(FetchShipmentInvoice(awb: awb));
    }
  }

  Map<int, String> _branchNamesById() {
    final state = context.read<BranchesBloc>().state;
    if (state is FetchBranchesLoaded) {
      return {for (final branch in state.branches) branch.id: branch.name};
    }
    return {};
  }

  Future<void> _downloadPdf(ShipmentInvoiceModel invoice) async {
    if (_isDownloadingPdf) return;
    setState(() => _isDownloadingPdf = true);
    try {
      final pdf = await ShipmentInvoicePdfGenerator.generate(
        invoice,
        branchNamesById: _branchNamesById(),
      );
      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'invoice_${invoice.awb}.pdf',
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isDownloadingPdf = false);
      }
    }
  }

  Future<void> _printInvoice(ShipmentInvoiceModel invoice) async {
    try {
      final success = await SunmiInvoicePrinter.printInvoice(
        data: invoice.toPrintMap(),
        awb: invoice.awb,
        branchNamesById: _branchNamesById(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Invoice printed successfully!'
                : 'Failed to connect to printer.',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error printing: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color.fromARGB(255, 75, 23, 160)
          : const Color.fromARGB(255, 75, 23, 160),
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? const Color.fromARGB(255, 75, 23, 160)
            : const Color.fromARGB(255, 75, 23, 160),
        title: const Text('Shipment Invoice'),
      ),
      body: Column(
        children: [
          ShipmentInvoiceWidgets.buildSearchInput(
            isDarkMode: isDarkMode,
            controller: _searchController,
            onSearch: _onSearch,
          ),
          Expanded(
            child: BlocBuilder<ShipmentInvoiceBloc, ShipmentInvoiceState>(
              builder: (context, state) {
                if (state is FetchShipmentInvoiceLoading) {
                  return ShipmentInvoiceWidgets.buildShimmerEffect(context);
                }

                if (state is FetchShipmentInvoiceSuccess) {
                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: ShipmentInvoiceWidgets.buildInvoiceDetails(
                            isDarkMode: isDarkMode,
                            invoice: state.shipmentInvoice,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          children: [
                            if (_isSunmiDevice) ...[
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () =>
                                      _printInvoice(state.shipmentInvoice),
                                  icon: const Icon(Icons.print),
                                  label: const Text('Print Invoice'),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(50),
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _isDownloadingPdf
                                    ? null
                                    : () => _downloadPdf(state.shipmentInvoice),
                                icon: _isDownloadingPdf
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(Icons.download),
                                label: Text(
                                  _isDownloadingPdf
                                      ? 'Generating PDF...'
                                      : 'Download PDF',
                                ),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(50),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                if (state is FetchShipmentInvoiceFailure) {
                  return Center(
                    child: Text(
                      state.errorMessage,
                      style: TextStyle(
                        color: context.palette.textPrimary,
                      ),
                    ),
                  );
                }

                return ShipmentInvoiceWidgets.buildEmptyState(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
