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

  @override
  void initState() {
    super.initState();
    context.read<BranchesBloc>().add(FetchBranches());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Teller',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Teller Name'),
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
                      decoration: const InputDecoration(labelText: 'Branch Id'),
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
                  return const CircularProgressIndicator();
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final authService = AuthService();
                    final tellerData = {
                      'tellerName': _nameController.text,
                      'branchId': int.parse(_selectedBranchId!),
                      'addedBy': authService.getUserId(),
                    };
                    context
                        .read<TellersBloc>()
                        .add(AddTeller(teller: tellerData));
                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
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
