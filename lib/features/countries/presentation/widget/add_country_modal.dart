import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/countries_bloc.dart';

class AddCountryModal extends StatefulWidget {
  const AddCountryModal({super.key});

  @override
  State<AddCountryModal> createState() => _AddCountryModalState();
}

class _AddCountryModalState extends State<AddCountryModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _isoCodeController = TextEditingController();
  final _countryCodeController = TextEditingController();

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
              'Add Country',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 24),

            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'ex Kenya',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter country name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ISO Code Field
            TextFormField(
              controller: _isoCodeController,
              decoration: InputDecoration(
                labelText: 'ISO Code',
                hintText: 'ex KE',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter ISO code';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Country Code Field
            TextFormField(
              controller: _countryCodeController,
              decoration: InputDecoration(
                labelText: 'Country Code',
                hintText: 'ex +254',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter country code';
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
    if (_formKey.currentState!.validate()) {
      final countryData = {
        "name": _nameController.text,
        "isoCode": _isoCodeController.text,
        "countryCode": _countryCodeController.text,
      };

      context.read<CountriesBloc>().add(AddCountry(country: countryData));

      // Wait for the state to change
      await for (final state in context.read<CountriesBloc>().stream) {
        if (state is AddCountrySuccess) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Country added successfully'),
              backgroundColor: Colors.green,
            ),
          );
          context.read<CountriesBloc>().add(FetchCountries());
          Navigator.pop(context);
          break;
        } else if (state is AddCountryFailure) {
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
    _isoCodeController.dispose();
    _countryCodeController.dispose();
    super.dispose();
  }
}
