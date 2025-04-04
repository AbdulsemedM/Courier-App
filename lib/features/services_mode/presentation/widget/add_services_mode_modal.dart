import 'package:courier_app/configuration/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/services_mode_bloc.dart';

class AddServicesModeModal extends StatefulWidget {
  const AddServicesModeModal({super.key});

  @override
  State<AddServicesModeModal> createState() => _AddServicesModeModalState();
}

class _AddServicesModeModalState extends State<AddServicesModeModal> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();

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
            Text(
              'Add Shipment Type',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 24),

            // Type Field
            TextFormField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: 'Code',
                hintText: 'ex DOC',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter code';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description Field
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'ex Document shipment',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter description';
                }
                return null;
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
                child: const Text('Submit'),
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
      final typeData = {
        "code": _codeController.text,
        "description": _descriptionController.text,
        "addedBy": await authService.getUserId(),
      };

      context
          .read<ServicesModeBloc>()
          .add(AddServicesMode(servicesMode: typeData));

      // Wait for the state to change
      await for (final state in context.read<ServicesModeBloc>().stream) {
        if (state is AddServicesModeLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Shipment type added successfully'),
              backgroundColor: Colors.green,
            ),
          );
          context.read<ServicesModeBloc>().add(FetchServicesMode());
          Navigator.pop(context);
          break;
        } else if (state is AddServicesModeError) {
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
    _codeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
