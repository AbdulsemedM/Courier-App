import 'package:courier_app/features/payment_method/models/payemnt_methods_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/payment_methods_bloc.dart';
import '../widgets/payment_methods_widget.dart';
import '../widgets/add_payment_method_modal.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<PaymentMethodModel> _filteredMethods = [];

  @override
  void initState() {
    super.initState();
    _fetchPaymentMethods();
  }

  void _fetchPaymentMethods() {
    context.read<PaymentMethodsBloc>().add(FetchPaymentMethods());
  }

  void _handleSearch(String query) {
    final state = context.read<PaymentMethodsBloc>().state;
    if (state is PaymentMethodsLoaded) {
      setState(() {
        _filteredMethods = state.paymentMethods.where((method) {
          final searchLower = query.toLowerCase();
          return (method.method?.toLowerCase().contains(searchLower) ?? false) ||
              (method.description?.toLowerCase().contains(searchLower) ?? false);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5b3895),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 75, 23, 160),
        title: const Text('Payment Methods'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return Dialog(
                    insetPadding: const EdgeInsets.all(24),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: const AddPaymentMethodModal(),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<PaymentMethodsBloc, PaymentMethodsState>(
        builder: (context, state) {
          if (state is PaymentMethodsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PaymentMethodsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  ElevatedButton(
                    onPressed: _fetchPaymentMethods,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is PaymentMethodsLoaded) {
            final methods =
                _filteredMethods.isEmpty && _searchController.text.isEmpty
                    ? state.paymentMethods
                    : _filteredMethods;

            return Column(
              children: [
                SearchBarWidget(
                  controller: _searchController,
                  onChanged: _handleSearch,
                ),
                Expanded(
                  child: PaymentMethodsTable(
                    paymentMethods: methods,
                  ),
                ),
              ],
            );
          }

          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
