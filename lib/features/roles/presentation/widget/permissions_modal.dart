import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:courier_app/features/roles/model/permission_model.dart';
import 'package:courier_app/features/roles/bloc/roles_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../configuration/auth_service.dart';

class PermissionsModal extends StatefulWidget {
  final int roleId;
  final String roleName;
  final List<PermissionModel> allPermissions;
  final List<PermissionModel> rolePermissions;

  const PermissionsModal({
    super.key,
    required this.roleId,
    required this.roleName,
    required this.allPermissions,
    required this.rolePermissions,
  });

  @override
  State<PermissionsModal> createState() => _PermissionsModalState();
}

class _PermissionsModalState extends State<PermissionsModal> {
  late Set<int> _selectedPermissionIds;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedPermissionIds = widget.rolePermissions.map((p) => p.id).toSet();
  }

  bool _isPermissionSelected(int permissionId) {
    return _selectedPermissionIds.contains(permissionId);
  }

  void _togglePermission(int permissionId) {
    setState(() {
      if (_selectedPermissionIds.contains(permissionId)) {
        _selectedPermissionIds.remove(permissionId);
      } else {
        _selectedPermissionIds.add(permissionId);
      }
    });
  }

  Future<void> _savePermissions() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final authService = AuthService();
      final userIdString = await authService.getUserId();
      if (userIdString == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User ID not found')),
          );
        }
        return;
      }

      final addedBy = int.parse(userIdString);
      final permissionIds = _selectedPermissionIds.toList();

      if (!mounted) return;
      context.read<RolesBloc>().add(
        UpdateRolePermissionsEvent(
          roleId: widget.roleId,
          permissionIds: permissionIds,
          addedBy: addedBy,
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF5b3895) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          Text(
            'Permissions for ${widget.roleName}',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_selectedPermissionIds.length} of ${widget.allPermissions.length} permissions selected',
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          // Permissions list
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: ListView.builder(
              itemCount: widget.allPermissions.length,
              itemBuilder: (context, index) {
                final permission = widget.allPermissions[index];
                final isSelected = _isPermissionSelected(permission.id);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDarkMode
                            ? Colors.green.withOpacity(0.2)
                            : Colors.green.withOpacity(0.1))
                        : (isDarkMode
                            ? const Color(0xFF1E293B)
                            : Colors.grey[100]),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? Colors.green
                          : (isDarkMode ? Colors.grey[700]! : Colors.grey[300]!),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: SwitchListTile(
                    value: isSelected,
                    onChanged: (value) => _togglePermission(permission.id),
                    title: Text(
                      permission.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    subtitle: permission.description != null
                        ? Text(
                            permission.description!,
                            style: TextStyle(
                              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                              fontSize: 12,
                            ),
                          )
                        : null,
                    activeColor: Colors.green,
                    inactiveThumbColor: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                    inactiveTrackColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Save and Close buttons
          BlocListener<RolesBloc, RolesState>(
            listener: (context, state) {
              if (state is UpdateRolePermissionsSuccess) {
                setState(() {
                  _isSaving = false;
                });
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                }
              } else if (state is UpdateRolePermissionsError) {
                setState(() {
                  _isSaving = false;
                });
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isSaving ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDarkMode ? Colors.white : Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _savePermissions,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

