import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:courier_app/features/roles/bloc/roles_bloc.dart';
import 'package:courier_app/features/roles/presentation/widget/roles_widget.dart';

class RolesScreen extends StatefulWidget {
  const RolesScreen({Key? key}) : super(key: key);

  @override
  State<RolesScreen> createState() => _RolesScreenState();
}

class _RolesScreenState extends State<RolesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RolesBloc>().add(FetchRolesEvent());
  }

  void _showAddRoleModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddRoleModal(
        isDarkMode: Theme.of(context).brightness == Brightness.dark,
        onSubmit: (role) {
          context.read<RolesBloc>().add(AddRolesEvent(roles: role));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: const Color(0xFF5b3895),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 75, 23, 160),
        title: const Text('Roles Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddRoleModal,
          ),
        ],
      ),
      body: BlocBuilder<RolesBloc, RolesState>(
        builder: (context, state) {
          if (state is FetchRolesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FetchRolesSuccess) {
            return state.roles.isEmpty
                ? RolesWidget.buildEmptyState(isDarkMode)
                : RolesWidget.buildRolesGrid(state.roles, isDarkMode);
          } else if (state is FetchRolesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: isDarkMode ? Colors.red[300] : Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: TextStyle(
                      color: isDarkMode ? Colors.red[300] : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<RolesBloc>().add(FetchRolesEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
