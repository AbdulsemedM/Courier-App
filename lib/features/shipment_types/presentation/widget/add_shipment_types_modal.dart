import 'package:courier_app/configuration/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/shipment_types_bloc.dart';

class AddShipmentTypeModal extends StatefulWidget {
  const AddShipmentTypeModal({super.key});

  @override
  State<AddShipmentTypeModal> createState() => _AddShipmentTypeModalState();
}

class _AddShipmentTypeModalState extends State<AddShipmentTypeModal> {
  final _formKey = GlobalKey<FormState>();
  final _typeController = TextEditingController();
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
              controller: _typeController,
              decoration: InputDecoration(
                labelText: 'Type',
                hintText: 'ex Document',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter shipment type';
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
        "type": _typeController.text,
        "description": _descriptionController.text,
        "addedBy": await authService.getUserId(),
      };

      context
          .read<ShipmentTypesBloc>()
          .add(AddShipmentType(shipmentType: typeData));

      // Wait for the state to change
      await for (final state in context.read<ShipmentTypesBloc>().stream) {
        if (state is AddShipmentTypesLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Shipment type added successfully'),
              backgroundColor: Colors.green,
            ),
          );
          context.read<ShipmentTypesBloc>().add(FetchShipmentTypes());
          Navigator.pop(context);
          break;
        } else if (state is AddShipmentTypesError) {
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
    _typeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
