import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/user_model.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search users...',
          prefixIcon: Icon(
            Icons.search,
            color: isDarkMode ? Colors.grey : Colors.grey[600],
          ),
          filled: true,
          fillColor: isDarkMode ? Colors.white10 : Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
        ),
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}

class UsersTable extends StatelessWidget {
  final List<UserModel> users;
  final Function(UserModel)? onEdit;
  final Function(UserModel)? onDelete;

  const UsersTable({
    super.key,
    required this.users,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columnSpacing: 24,
          columns: [
            DataColumn(
              label: Text(
                'First Name',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Last Name',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Email',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Phone',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Role',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Branch',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Created At',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (onEdit != null || onDelete != null)
              DataColumn(
                label: Text(
                  'Actions',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
          rows: users.map((user) {
            return DataRow(
              cells: [
                DataCell(Text(
                  user.firstName,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )),
                DataCell(Text(
                  user.lastName,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )),
                DataCell(Text(
                  user.email,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )),
                DataCell(Text(
                  user.phone,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getRoleColor(user.role),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      user.role,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                DataCell(Text(
                  user.branchName,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )),
                DataCell(Text(
                  DateFormat('MMM-dd-yyyy')
                      .format(DateTime.parse(user.createdAt)),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )),
                if (onEdit != null || onDelete != null)
                  DataCell(Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onEdit != null)
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: isDarkMode ? Colors.blue[300] : Colors.blue,
                          ),
                          onPressed: () => onEdit!(user),
                        ),
                      if (onDelete != null)
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: isDarkMode ? Colors.red[300] : Colors.red,
                          ),
                          onPressed: () => onDelete!(user),
                        ),
                    ],
                  )),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Color _getRoleColor(String? role) {
    switch (role?.toLowerCase()) {
      case 'admin':
        return Colors.red;
      case 'manager':
        return Colors.orange;
      case 'staff':
        return Colors.blue;
      case 'agent':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
