import 'package:courier_app/features/tellers/presentation/widget/teller_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:courier_app/core/theme/app_palette.dart';
import '../../bloc/tellers_bloc.dart';
import '../../model/teller_model.dart';
import '../widget/add_teller_modal.dart';

class TellerScreen extends StatefulWidget {
  const TellerScreen({super.key});

  @override
  State<TellerScreen> createState() => _TellerScreenState();
}

class _TellerScreenState extends State<TellerScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<TellerModel> _filteredTellers = [];

  @override
  void initState() {
    super.initState();
    context.read<TellersBloc>().add(FetchTellers());
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
                      'Manage Tellers',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: context.palette.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () => _showAddTellerModal(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Teller'),
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
                onChanged: _filterUsers,
              ),

              // Main Content
              Expanded(
                child: BlocBuilder<TellersBloc, TellersState>(
                  builder: (context, state) {
                    if (state is FetchTellersLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is FetchTellersSuccess) {
                      final tellers = _searchController.text.isEmpty
                          ? state.tellers
                          : _filteredTellers;

                      if (tellers.isEmpty) {
                        return Center(
                          child: Text(
                            'No tellers found',
                            style: TextStyle(
                              color: context.palette.textPrimary,
                            ),
                          ),
                        );
                      }

                      return TellersTable(
                        tellers: tellers,
                        onEdit: (teller) => _handleEdit(context, teller),
                        onDelete: (teller) => _handleDelete(context, teller),
                      );
                    }

                    if (state is FetchTellersError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Error: ${state.message}',
                              style: TextStyle(
                                color: context.palette.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.read<TellersBloc>().add(FetchTellers());
                              },
                              child: const Text('Retry'),
                            ),
                          ],
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

  void _filterUsers(String query) {
    final state = context.read<TellersBloc>().state;
    if (state is FetchTellersSuccess) {
      setState(() {
        _filteredTellers = state.tellers
            .where((teller) =>
                teller.tellerName.toLowerCase().contains(query.toLowerCase()) ==
                    true ||
                teller.branchName.toLowerCase().contains(query.toLowerCase()) ==
                    true)
            .toList();
      });
    }
  }

  Future<void> _showAddTellerModal(BuildContext context) async {
    final success = await showDialog<bool>(
      context: context,
      builder: (context) => const AddTellerModal(),
    );

    if (success == true && mounted) {
      context.read<TellersBloc>().add(FetchTellers());
    }
  }

  void _handleEdit(BuildContext context, TellerModel teller) {
    // showDialog<bool>(
    //   context: context,
    //   builder: (context) => AddUserModal(userToEdit: user),
    // ).then((success) {
    //   if (success == true && mounted) {
    //     context.read<ManageUserBloc>().add(FetchUsersEvent());
    //   }
    // });
  }

  void _handleDelete(BuildContext context, TellerModel teller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text(
            'Are you sure you want to delete ${teller.tellerName} ${teller.branchName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
