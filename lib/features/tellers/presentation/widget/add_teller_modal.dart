import 'package:courier_app/configuration/auth_service.dart';
import 'package:courier_app/features/tellers/bloc/tellers_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../branches/bloc/branches_bloc.dart';

class AddTellerModal extends StatefulWidget {
  const AddTellerModal({super.key});

  @override
  State<AddTellerModal> createState() => _AddTellerModalState();
}

class _AddTellerModalState extends State<AddTellerModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedBranchId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<BranchesBloc>().add(FetchBranches());
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<TellersBloc, TellersState>(
      listener: (context, state) {
        if (state is AddTellerSuccess) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Teller added successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is AddTellerError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isLoading = false;
          });
        }
      },
      child: Dialog(
        backgroundColor: isDarkMode ? const Color(0xFF1A1C2E) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person_add,
                      color: isDarkMode ? Colors.white : Colors.black87,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Add Teller',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Teller Name',
                    hintText: 'Enter teller name',
                    prefixIcon: const Icon(Icons.badge),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: isDarkMode
                        ? Colors.white.withOpacity(0.05)
                        : Colors.grey.withOpacity(0.1),
                  ),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a teller name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                BlocBuilder<BranchesBloc, BranchesState>(
                  builder: (context, state) {
                    if (state is FetchBranchesLoaded) {
                      return DropdownButtonFormField<String>(
                        value: _selectedBranchId,
                        decoration: InputDecoration(
                          labelText: 'Select Branch',
                          hintText: 'Choose a branch',
                          prefixIcon: const Icon(Icons.business),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: isDarkMode
                              ? Colors.white.withOpacity(0.05)
                              : Colors.grey.withOpacity(0.1),
                        ),
                        dropdownColor:
                            isDarkMode ? const Color(0xFF1A1C2E) : Colors.white,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        items: state.branches.map((branch) {
                          return DropdownMenuItem(
                            value: branch.id.toString(),
                            child: Text(
                              '${branch.name} (${branch.code})',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedBranchId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a branch';
                          }
                          return null;
                        },
                      );
                    }
                    if (state is FetchBranchesError) {
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Error loading branches: ${state.message}',
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Container(
                      padding: const EdgeInsets.all(16),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed:
                          _isLoading ? null : () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    BlocBuilder<TellersBloc, TellersState>(
                      builder: (context, state) {
                        _isLoading = state is AddTellerLoading;

                        return ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    final authService = AuthService();
                                    final userId =
                                        await authService.getUserId();
                                    final tellerData = {
                                      'tellerName': _nameController.text.trim(),
                                      'branchId': int.parse(_selectedBranchId!),
                                      'addedBy': int.parse(userId ?? '0'),
                                    };
                                    context
                                        .read<TellersBloc>()
                                        .add(AddTeller(teller: tellerData));
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF5a00),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 2,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Submit'),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
