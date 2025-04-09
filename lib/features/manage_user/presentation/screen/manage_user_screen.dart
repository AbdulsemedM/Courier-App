import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/manage_user_bloc.dart';
import '../../model/user_model.dart';
import '../widget/manage_user_widget.dart';

class ManageUserScreen extends StatefulWidget {
  const ManageUserScreen({super.key});

  @override
  State<ManageUserScreen> createState() => _ManageUserScreenState();
}

class _ManageUserScreenState extends State<ManageUserScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    context.read<ManageUserBloc>().add(FetchUsersEvent());
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
                      'Manage Users',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const Spacer(),
                    // ElevatedButton.icon(
                    //   onPressed: () => _showAddUserModal(context),
                    //   icon: const Icon(Icons.add),
                    //   label: const Text('Add User'),
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.blue,
                    //     foregroundColor: Colors.white,
                    //     padding: const EdgeInsets.symmetric(horizontal: 16),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(8),
                    //     ),
                    //   ),
                    // ),
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
                child: BlocBuilder<ManageUserBloc, ManageUserState>(
                  builder: (context, state) {
                    if (state is FetchUsersLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is FetchUsersSuccess) {
                      final users = _searchController.text.isEmpty
                          ? state.users
                          : _filteredUsers;

                      if (users.isEmpty) {
                        return Center(
                          child: Text(
                            'No users found',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        );
                      }

                      return UsersTable(
                        users: users,
                        onEdit: (user) => _handleEdit(context, user),
                        onDelete: (user) => _handleDelete(context, user),
                      );
                    }

                    if (state is FetchUsersError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Error: ${state.message}',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<ManageUserBloc>()
                                    .add(FetchUsersEvent());
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
      ),
    );
  }

  void _filterUsers(String query) {
    final state = context.read<ManageUserBloc>().state;
    if (state is FetchUsersSuccess) {
      setState(() {
        _filteredUsers = state.users
            .where((user) =>
                user.firstName.toLowerCase().contains(query.toLowerCase()) ==
                    true ||
                user.lastName.toLowerCase().contains(query.toLowerCase()) ==
                    true ||
                user.email.toLowerCase().contains(query.toLowerCase()) ==
                    true ||
                user.phone.toLowerCase().contains(query.toLowerCase()) ==
                    true ||
                user.role.toLowerCase().contains(query.toLowerCase()) == true ||
                user.branchName.toLowerCase().contains(query.toLowerCase()) ==
                    true)
            .toList();
      });
    }
  }

  Future<void> _showAddUserModal(BuildContext context) async {
    // final success = await showDialog<bool>(
    //   context: context,
    //   builder: (context) => const AddUserModal(),
    // );

    // if (success == true && mounted) {
    //   context.read<ManageUserBloc>().add(FetchUsersEvent());
    // }
  }

  void _handleEdit(BuildContext context, UserModel user) {
    // showDialog<bool>(
    //   context: context,
    //   builder: (context) => AddUserModal(userToEdit: user),
    // ).then((success) {
    //   if (success == true && mounted) {
    //     context.read<ManageUserBloc>().add(FetchUsersEvent());
    //   }
    // });
  }

  void _handleDelete(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text(
            'Are you sure you want to delete ${user.firstName} ${user.lastName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          // TextButton(
          //   onPressed: () {
          //     Navigator.pop(context);
          //     context.read<ManageUserBloc>().add(DeleteUserEvent(user.id));
          //   },
          //   child: const Text(
          //     'Delete',
          //     style: TextStyle(color: Colors.red),
          //   ),
          // ),
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
