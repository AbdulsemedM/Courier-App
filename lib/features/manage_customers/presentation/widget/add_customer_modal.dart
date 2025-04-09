import 'package:courier_app/features/manage_customers/bloc/manage_customers_bloc.dart';
import 'package:courier_app/features/manage_customers/model/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../branches/bloc/branches_bloc.dart';
import '../../../../configuration/auth_service.dart';

class AddCustomerModal extends StatefulWidget {
  final CustomerModel? customerToEdit;

  const AddCustomerModal({
    super.key,
    this.customerToEdit,
  });

  @override
  State<AddCustomerModal> createState() => _AddCustomerModalState();
}

class _AddCustomerModalState extends State<AddCustomerModal> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _companyController = TextEditingController();
  String? _selectedBranchId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<BranchesBloc>().add(FetchBranches());

    if (widget.customerToEdit != null) {
      _fullNameController.text = widget.customerToEdit!.fullname;
      _emailController.text = widget.customerToEdit!.email;
      _phoneController.text = widget.customerToEdit!.phone;
      _companyController.text = widget.customerToEdit!.company;
      _selectedBranchId = widget.customerToEdit!.branchId.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isEditing = widget.customerToEdit != null;

    return BlocListener<ManageCustomersBloc, ManageCustomersState>(
      listener: (context, state) {
        if (state is AddCustomerSuccess || state is UpdateCustomerSuccess) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isEditing
                  ? 'Customer updated successfully'
                  : 'Customer added successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is AddCustomerError || state is UpdateCustomerError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state is AddCustomerError
                  ? state.error
                  : (state as UpdateCustomerError).error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Dialog(
        backgroundColor: isDarkMode ? const Color(0xFF1A1C2E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Edit Customer' : 'Add Customer',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 24),
                BlocBuilder<BranchesBloc, BranchesState>(
                  builder: (context, state) {
                    if (state is FetchBranchesLoaded) {
                      return DropdownButtonFormField<String>(
                        value: _selectedBranchId,
                        decoration: InputDecoration(
                          labelText: 'Select Branch',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: state.branches.map((branch) {
                          return DropdownMenuItem(
                            value: branch.id.toString(),
                            child: Text(branch.name),
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
                      return Center(
                        child: Text('Error loading branches: ${state.message}'),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _companyController,
                  decoration: InputDecoration(
                    labelText: 'Company',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter company name';
                    }
                    return null;
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
                    BlocBuilder<ManageCustomersBloc, ManageCustomersState>(
                      builder: (context, state) {
                        _isLoading = state is AddCustomerLoading ||
                            state is UpdateCustomerLoading;

                        return ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    final authService = AuthService();
                                    final customerData = {
                                      'fullName': _fullNameController.text,
                                      'email': _emailController.text,
                                      'phone': _phoneController.text,
                                      'company': _companyController.text,
                                      'branchId': int.parse(_selectedBranchId!),
                                      'addedBy': int.parse(
                                          await authService.getUserId() ?? '0')
                                    };

                                    if (isEditing) {
                                      context.read<ManageCustomersBloc>().add(
                                            UpdateCustomerEvent(
                                              customer: customerData,
                                              customerId:
                                                  widget.customerToEdit!.id
                                                      .toString(),
                                            ),
                                          );
                                    } else {
                                      context.read<ManageCustomersBloc>().add(
                                            AddCustomerEvent(
                                                customer: customerData),
                                          );
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
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
                              : Text(isEditing ? 'Update' : 'Submit'),
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
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyController.dispose();
    super.dispose();
  }
}
