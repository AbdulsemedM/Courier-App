import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:courier_app/features/shelves_management/bloc/shelves_management_bloc.dart';
import 'package:courier_app/features/branches/bloc/branches_bloc.dart';
import 'package:courier_app/features/shelves_management/presentation/widgets/shelves_widgets.dart';

class ShelvesScreen extends StatefulWidget {
  const ShelvesScreen({Key? key}) : super(key: key);

  @override
  State<ShelvesScreen> createState() => _ShelvesScreenState();
}

class _ShelvesScreenState extends State<ShelvesScreen> {
  int? selectedBranchId;

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  void _refreshData() {
    context.read<ShelvesManagementBloc>().add(FetchShelvesEvent());
    context.read<BranchesBloc>().add(FetchBranches());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shelves Management'),
      ),
      body: Column(
        children: [
          // Branch Filter
          BlocBuilder<BranchesBloc, BranchesState>(
            builder: (context, state) {
              if (state is FetchBranchesLoaded) {
                return BranchFilter(
                  branches: state.branches,
                  selectedBranchId: selectedBranchId,
                  onBranchSelected: (branchId) {
                    setState(() {
                      selectedBranchId = branchId;
                    });
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // Shelves Table
          Expanded(
            child: BlocBuilder<ShelvesManagementBloc, ShelvesManagementState>(
              builder: (context, state) {
                if (state is FetchShelvesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is FetchShelvesSuccess) {
                  return ShelvesTable(
                    shelves: state.shelves,
                    selectedBranchId: selectedBranchId,
                    onEdit: (shelf) {
                      // TODO: Implement edit functionality
                      _refreshData();
                    },
                  );
                }
                if (state is FetchShelvesFailure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: ${state.message}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _refreshData,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                return const Center(child: Text('No shelves found'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
