import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../bloc/shipment_invoice_bloc.dart';
import '../widgets/shipment_invoice_widget.dart';

class ShipmentInvoiceScreen extends StatefulWidget {
  const ShipmentInvoiceScreen({super.key});

  @override
  State<ShipmentInvoiceScreen> createState() => _ShipmentInvoiceScreenState();
}

class _ShipmentInvoiceScreenState extends State<ShipmentInvoiceScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final awb = _searchController.text.trim();
    if (awb.isNotEmpty) {
      context.read<ShipmentInvoiceBloc>().add(FetchShipmentInvoice(awb: awb));
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
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
                  return ShipmentInvoiceWidgets.buildShimmerEffect(isDarkMode);
                }

                if (state is FetchShipmentInvoiceSuccess) {
                  return ShipmentInvoiceWidgets.buildInvoiceDetails(
                    isDarkMode: isDarkMode,
                    invoice: state.shipmentInvoice,
                  );
                }

                if (state is FetchShipmentInvoiceFailure) {
                  return Center(
                    child: Text(
                      state.errorMessage,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  );
                }

                return ShipmentInvoiceWidgets.buildEmptyState(isDarkMode);
              },
            ),
          ),
        ],
      ),
    );
  }
}
