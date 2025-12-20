import 'package:courier_app/configuration/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:courier_app/features/roles/model/roles_model.dart';

class RolesWidget {
  static Widget buildRolesGrid(
    List<RolesModel> roles,
    bool isDarkMode, {
    Function(RolesModel)? onRoleTap,
  }) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: roles.length,
      itemBuilder: (context, index) {
        final role = roles[index];
        return RoleCard(
          role: role,
          isDarkMode: isDarkMode,
          onTap: onRoleTap != null ? () => onRoleTap(role) : null,
        );
      },
    );
  }

  static Widget buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_off_outlined,
            size: 64,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            'No Roles Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add new roles to get started',
            style: TextStyle(
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class RoleCard extends StatelessWidget {
  final RolesModel role;
  final bool isDarkMode;
  final VoidCallback? onTap;

  const RoleCard({
    Key? key,
    required this.role,
    required this.isDarkMode,
    this.onTap,
  }) : super(key: key);

  // Generate a color based on role name for variety
  Color _getRoleColor(String roleName) {
    final colors = [
      const Color(0xFF6366F1), // Indigo
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFFEC4899), // Pink
      const Color(0xFFF59E0B), // Amber
      const Color(0xFF10B981), // Emerald
      const Color(0xFF3B82F6), // Blue
      const Color(0xFFEF4444), // Red
      const Color(0xFF14B8A6), // Teal
    ];
    final index = roleName.hashCode.abs() % colors.length;
    return colors[index];
  }

  @override
  Widget build(BuildContext context) {
    final roleColor = _getRoleColor(role.role);
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isDarkMode 
              ? Colors.white.withOpacity(0.1) 
              : Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      color: isDarkMode 
          ? const Color(0xFF152642) 
          : Colors.white,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon with colored background
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: roleColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.badge_rounded,
                      color: roleColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Role name
                  Text(
                    role.role,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                      letterSpacing: -0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Description
                  Expanded(
                    child: Text(
                      role.description,
                      style: TextStyle(
                        color: isDarkMode 
                            ? Colors.grey[400] 
                            : Colors.grey[600],
                        fontSize: 13,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Footer with tap indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: roleColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 14,
                              color: roleColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '0 users',
                              style: TextStyle(
                                color: roleColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: isDarkMode 
                            ? Colors.grey[500] 
                            : Colors.grey[400],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddRoleModal extends StatelessWidget {
  final bool isDarkMode;
  final Function(Map<String, dynamic>) onSubmit;

  AddRoleModal({
    Key? key,
    required this.isDarkMode,
    required this.onSubmit,
  }) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[900] : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Add New Role',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Role Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter a role name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final authService = AuthService();
                      final newRole = {
                        'role': _nameController.text,
                        'description': _descriptionController.text,
                        "added_by": authService.getUserId(),
                      };
                      onSubmit(newRole);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Add Role'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
