import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:courier_app/features/roles/bloc/roles_bloc.dart';
import 'package:courier_app/features/roles/presentation/widget/roles_widget.dart';
import 'package:courier_app/features/roles/presentation/widget/permissions_modal.dart';
import 'package:courier_app/features/roles/model/permission_model.dart';
import 'package:courier_app/features/roles/model/roles_model.dart';
import 'package:courier_app/core/theme/app_palette.dart';

class RolesScreen extends StatefulWidget {
  const RolesScreen({Key? key}) : super(key: key);

  @override
  State<RolesScreen> createState() => _RolesScreenState();
}

class _RolesScreenState extends State<RolesScreen> {
  List<PermissionModel>? _allPermissions;
  List<RolesModel>? _cachedRoles;
  int? _selectedRoleId;

  @override
  void initState() {
    super.initState();
    context.read<RolesBloc>().add(FetchRolesEvent());
    context.read<RolesBloc>().add(FetchAllPermissionsEvent());
  }

  void _showAddRoleModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddRoleModal(
        isDarkMode: context.isDarkMode,
        onSubmit: (role) {
          context.read<RolesBloc>().add(AddRolesEvent(roles: role));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;

    return Scaffold(
      backgroundColor: context.palette.background,
      appBar: AppBar(
        backgroundColor: context.palette.appBarBackground,
        elevation: 0,
        title: Text(
          'Roles Management',
          style: TextStyle(
            color: context.palette.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(
          color: context.palette.textPrimary,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: context.palette.textPrimary,
            ),
            onPressed: _showAddRoleModal,
            tooltip: 'Add Role',
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<RolesBloc, RolesState>(
            listener: (context, state) {
              if (state is FetchAllPermissionsSuccess) {
                setState(() {
                  _allPermissions = state.permissions;
                });
              } else if (state is FetchRolePermissionsSuccess) {
                // Show permissions modal
                if (_allPermissions != null && _selectedRoleId != null) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => PermissionsModal(
                      roleId: _selectedRoleId!,
                      roleName: state.rolePermissions.roleName,
                      allPermissions: _allPermissions!,
                      rolePermissions: state.rolePermissions.permissions,
                    ),
                  );
                }
              } else if (state is AddRolesSuccess) {
                // Refresh roles list after adding
                context.read<RolesBloc>().add(FetchRolesEvent());
              }
            },
          ),
        ],
        child: BlocBuilder<RolesBloc, RolesState>(
          builder: (context, state) {
            // Cache roles when successfully fetched
            if (state is FetchRolesSuccess) {
              _cachedRoles = state.roles;
            }
            
            // Show loading only if we don't have cached roles
            if (state is FetchRolesLoading && _cachedRoles == null) {
              return const Center(child: CircularProgressIndicator());
            } 
            
            // Show roles if we have them (either from current state or cached)
            if (_cachedRoles != null) {
              return _cachedRoles!.isEmpty
                  ? RolesWidget.buildEmptyState(context)
                  : RolesWidget.buildRolesGrid(
                      context,
                      _cachedRoles!,
                      onRoleTap: (role) {
                        setState(() {
                          _selectedRoleId = role.id;
                        });
                        context.read<RolesBloc>().add(
                          FetchRolePermissionsEvent(roleId: role.id),
                        );
                      },
                    );
            }
            
            if (state is FetchRolesError) {
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
      ),
    );
  }
}
