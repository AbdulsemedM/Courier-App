import 'package:courier_app/features/currency/model/currency_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/currency_bloc.dart';
import '../widget/currency_widget.dart';
import '../widget/add_currency_modal.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<CurrencyModel> _filteredCurrencies = [];

  @override
  void initState() {
    super.initState();
    context.read<CurrencyBloc>().add(FetchCurrencies());
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
                    const Color(0xFF1A1C2E),
                    const Color(0xFF2D3250),
                  ]
                : [
                    const Color(0xFFF0F4FF),
                    const Color(0xFFFFFFFF),
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
                      'Currencies',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () => _showAddCurrencyModal(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Currency'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
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
                onChanged: _filterCurrencies,
              ),

              // Main Content
              Expanded(
                child: BlocBuilder<CurrencyBloc, CurrencyState>(
                  builder: (context, state) {
                    if (state is FetchCurrencyLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is FetchCurrencySuccess) {
                      final currencies = _searchController.text.isEmpty
                          ? state.currencies
                          : _filteredCurrencies;

                      return CurrencyTable(
                        currencies: currencies,
                        onEdit: (currency) => _handleEdit(context, currency),
                        onDelete: (currency) =>
                            _handleDelete(context, currency),
                      );
                    }

                    if (state is FetchCurrencyFailure) {
                      return Center(
                        child: Text(
                          'Error: ${state.message}',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
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
      ),
    );
  }

  void _filterCurrencies(String query) {
    final state = context.read<CurrencyBloc>().state;
    if (state is FetchCurrencySuccess) {
      setState(() {
        _filteredCurrencies = state.currencies
            .where((currency) =>
                currency.code.toLowerCase().contains(query.toLowerCase()) ==
                    true ||
                currency.description
                        .toLowerCase()
                        .contains(query.toLowerCase()) ==
                    true ||
                currency.id.toString().contains(query) == true)
            .toList();
      });
    }
  }

    Future<void> _showAddCurrencyModal(BuildContext context) async {
    final success = await showDialog<bool>(  // Specify the return type as bool
      context: context,
      builder: (context) => const AddCurrencyModal(),
    );

    if (success == true && mounted) {  // Check if the result is true
      context.read<CurrencyBloc>().add(FetchCurrencies());  // Refresh the list
    }
  }

  void _handleEdit(BuildContext context, CurrencyModel currency) {
    // Handle edit action
  }

  void _handleDelete(BuildContext context, CurrencyModel currency) {
    // Handle delete action
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
