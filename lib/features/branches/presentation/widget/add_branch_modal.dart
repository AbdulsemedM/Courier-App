import 'package:courier_app/configuration/auth_service.dart';
import 'package:courier_app/features/branches/bloc/branches_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBranchModal extends StatefulWidget {
  const AddBranchModal({super.key});

  @override
  State<AddBranchModal> createState() => _AddBranchModalState();
}

class _AddBranchModalState extends State<AddBranchModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _hudhudPercentController = TextEditingController();
  final _currencyController =
      TextEditingController(text: 'ETB'); // Default currency
  String? _selectedCountryId;
  bool? _isAgent;

  @override
  void initState() {
    super.initState();
    context.read<BranchesBloc>().add(FetchCountry());
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Branch',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Country Dropdown
            BlocBuilder<BranchesBloc, BranchesState>(
              builder: (context, state) {
                if (state is FetchCountryLoading) {
                  return const CircularProgressIndicator();
                }

                if (state is FetchCountryLoaded) {
                  return DropdownButtonFormField<String>(
                    value: _selectedCountryId,
                    decoration: InputDecoration(
                      labelText: 'Select Country',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: state.countries.map((country) {
                      return DropdownMenuItem(
                        value: country.id.toString(),
                        child: Text(country.name ?? " "),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCountryId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) return 'Please select a country';
                      return null;
                    },
                  );
                }

                return const Text('Failed to load countries');
              },
            ),
            const SizedBox(height: 16),

            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Branch Name',
                hintText: 'ex Jigjiga branch',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter branch name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Code Field
            TextFormField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: 'Code',
                hintText: 'ex JJ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter branch code';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Phone Field
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
                hintText: 'ex 0912324565',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
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

            // Hudhud Percent Field
            TextFormField(
              controller: _hudhudPercentController,
              decoration: InputDecoration(
                labelText: 'Hudhud Percent',
                hintText: 'ex 1.4',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter hudhud percent';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Currency Field
            TextFormField(
              controller: _currencyController,
              decoration: InputDecoration(
                labelText: 'Currency',
                hintText: 'ex ETB',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Is Agent Switch
            SwitchListTile(
              title: const Text('Is Agent'),
              value: _isAgent ?? false,
              onChanged: (bool value) {
                setState(() {
                  _isAgent = value;
                });
              },
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Add Branch'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    final authService = AuthService();
    if (_formKey.currentState!.validate()) {
      final branchData = {
        "name": _nameController.text,
        "code": _codeController.text,
        "phone": _phoneController.text,
        "isAgent": _isAgent ?? false,
        "hudhudPercent": double.tryParse(_hudhudPercentController.text) ?? 0.0,
        "addedBy": await authService.getUserId(),
        "currency": _currencyController.text,
        "countryId": int.tryParse(_selectedCountryId ?? ''),
      };

      context.read<BranchesBloc>().add(AddBranch(body: branchData));

      // Wait for the state to change
      await for (final state in context.read<BranchesBloc>().stream) {
        if (state is AddBranchLoaded) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Branch added successfully'),
              backgroundColor: Colors.green,
            ),
          );
          context.read<BranchesBloc>().add(FetchBranches());
          Navigator.pop(context);
          break;
        } else if (state is AddBranchError) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
          break;
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _phoneController.dispose();
    _hudhudPercentController.dispose();
    _currencyController.dispose(); // Don't forget to dispose
    super.dispose();
  }
}
