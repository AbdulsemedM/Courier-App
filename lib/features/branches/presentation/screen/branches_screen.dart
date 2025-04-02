import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/branches_bloc.dart';
import '../../model/branches_model.dart';
import '../widget/branches_widget.dart';

class BranchesScreen extends StatefulWidget {
  const BranchesScreen({super.key});

  @override
  State<BranchesScreen> createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<BranchesModel> _filteredBranches = [];

  @override
  void initState() {
    super.initState();
    context.read<BranchesBloc>().add(FetchBranches());
  }

  void _handleSearch(String query) {
    // final branches =
    //     (context.read<BranchesBloc>().state as BranchesLoadedState).branches;
    // setState(() {
    //   _filteredBranches = branches.where((branch) {
    //     return branch.name.toLowerCase().contains(query.toLowerCase()) ||
    //         branch.code.toLowerCase().contains(query.toLowerCase()) ||
    //         branch.phone.toLowerCase().contains(query.toLowerCase());
    //   }).toList();
    // });
  }

  void _handleEdit(BranchesModel branch) {
    // TODO: Implement edit functionality
    print('Editing ${branch.name}');
  }

  void _handleDelete(BranchesModel branch) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete ${branch.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // context.read<BranchesBloc>().add(DeleteBranchEvent(branch.id));
              // Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Branches'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Implement add new branch
            },
          ),
        ],
      ),
      body: BlocBuilder<BranchesBloc, BranchesState>(
        builder: (context, state) {
          if (state is FetchBranchesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FetchBranchesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  ElevatedButton(
                    onPressed: () {
                      context.read<BranchesBloc>().add(FetchBranches());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is FetchBranchesLoaded) {
            final branches =
                _filteredBranches.isEmpty && _searchController.text.isEmpty
                    ? state.branches
                    : _filteredBranches;

            return Column(
              children: [
                SearchBarWidget(
                  controller: _searchController,
                  onChanged: _handleSearch,
                ),
                Expanded(
                  child: BranchesTable(
                    branches: branches,
                    onEdit: _handleEdit,
                    onDelete: _handleDelete,
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
