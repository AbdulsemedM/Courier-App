import 'package:courier_app/features/manage_customers/bloc/manage_customers_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:courier_app/core/theme/app_palette.dart';
import '../../model/customer_model.dart';
import '../widget/manage_customers_widget.dart';
import '../widget/add_customer_modal.dart';

class ManageCustomersScreen extends StatefulWidget {
  const ManageCustomersScreen({super.key});

  @override
  State<ManageCustomersScreen> createState() => _ManageCustomersScreenState();
}

class _ManageCustomersScreenState extends State<ManageCustomersScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<CustomerModel> _filteredCustomers = [];

  @override
  void initState() {
    super.initState();
    context.read<ManageCustomersBloc>().add(FetchCustomersEvent());
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
                      'Manage Customers',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: context.palette.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () => _showAddCustomerModal(context),
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
                onChanged: _filterCustomers,
              ),

              // Main Content
              Expanded(
                child: BlocBuilder<ManageCustomersBloc, ManageCustomersState>(
                  builder: (context, state) {
                    if (state is FetchCustomersLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is FetchCustomersSuccess) {
                      final customers = _searchController.text.isEmpty
                          ? state.customers
                          : _filteredCustomers;

                      return CustomersTable(
                        customers: customers,
                        onEdit: (customer) => _handleEdit(context, customer),
                        onDelete: (customer) =>
                            _handleDelete(context, customer),
                      );
                    }

                    if (state is FetchCustomersError) {
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

  void _filterCustomers(String query) {
    final state = context.read<ManageCustomersBloc>().state;
    if (state is FetchCustomersSuccess) {
      setState(() {
        _filteredCustomers = state.customers
            .where((customer) =>
                customer.fullname.toLowerCase().contains(query.toLowerCase()) ||
                customer.email.toLowerCase().contains(query.toLowerCase()) ||
                customer.phone.toLowerCase().contains(query.toLowerCase()) ||
                customer.company.toLowerCase().contains(query.toLowerCase()) ||
                customer.branchName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  Future<void> _showAddCustomerModal(BuildContext context) async {
    final success = await showDialog<bool>(
      context: context,
      builder: (context) => const AddCustomerModal(),
    );

    if (success == true && mounted) {
      context.read<ManageCustomersBloc>().add(FetchCustomersEvent());
    }
  }

  void _handleEdit(BuildContext context, CustomerModel customer) {
    showDialog<bool>(
      context: context,
      builder: (context) => AddCustomerModal(customerToEdit: customer),
    ).then((success) {
      if (success == true && mounted) {
        context.read<ManageCustomersBloc>().add(FetchCustomersEvent());
      }
    });
  }

  void _handleDelete(BuildContext context, CustomerModel customer) {
    // Handle delete action
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
