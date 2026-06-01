import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:courier_app/core/theme/app_palette.dart';
import '../../bloc/exchange_rate_bloc.dart';
import '../../model/exchange_rate_model.dart';
import '../widget/exchange_rate_widget.dart';
import '../widget/add_exchange_rate_modal.dart';

class ExchangeRateScreen extends StatefulWidget {
  const ExchangeRateScreen({super.key});

  @override
  State<ExchangeRateScreen> createState() => _ExchangeRateScreenState();
}

class _ExchangeRateScreenState extends State<ExchangeRateScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ExchangeRateModel> _filteredRates = [];

  @override
  void initState() {
    super.initState();
    context.read<ExchangeRateBloc>().add(FetchExchangeRates());
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;

    return Scaffold(
      backgroundColor: context.isDarkMode ? const Color(0xFF5B3895) : context.palette.background,
      body: SafeArea(
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
                        color: context.palette.textPrimary,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Exchange Rates',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: context.palette.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () => _showAddExchangeRateModal(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Add'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.palette.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Search Bar
              SearchBarWidget(
                controller: _searchController,
                onChanged: _filterExchangeRates,
              ),

              // Main Content
              Expanded(
                child: BlocBuilder<ExchangeRateBloc, ExchangeRateState>(
                  builder: (context, state) {
                    if (state is FetchExchangeRatesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is FetchExchangeRatesSuccess) {
                      final rates = _searchController.text.isEmpty
                          ? state.exchangeRates
                          : _filteredRates;

                      return ExchangeRateTable(
                        exchangeRates: rates,
                        onEdit: (rate) => _handleEdit(context, rate),
                        onDelete: (rate) => _handleDelete(context, rate),
                      );
                    }

                    if (state is FetchExchangeRatesFailure) {
                      return Center(
                        child: Text(
                          'Error: ${state.error}',
                          style: TextStyle(
                            color: context.palette.textPrimary,
                          ),
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
    );
  }

  void _filterExchangeRates(String query) {
    final state = context.read<ExchangeRateBloc>().state;
    if (state is FetchExchangeRatesSuccess) {
      setState(() {
        _filteredRates = state.exchangeRates
            .where((rate) =>
                rate.fromCurrency.code
                        .toLowerCase()
                        .contains(query.toLowerCase()) ==
                    true ||
                rate.toCurrency.code
                        .toLowerCase()
                        .contains(query.toLowerCase()) ==
                    true ||
                rate.factor.toString().contains(query))
            .toList();
      });
    }
  }

  Future<void> _showAddExchangeRateModal(BuildContext context) async {
    final success = await showDialog<bool>(
      context: context,
      builder: (context) => const AddExchangeRateModal(),
    );

    if (success == true && mounted) {
      context.read<ExchangeRateBloc>().add(FetchExchangeRates());
    }
  }

  void _handleEdit(BuildContext context, ExchangeRateModel rate) {
    // Handle edit action
  }

  void _handleDelete(BuildContext context, ExchangeRateModel rate) {
    // Handle delete action
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
