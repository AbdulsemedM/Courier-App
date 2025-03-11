import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_provider.dart';

class ThirdPage extends StatelessWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onPrevious;
  final VoidCallback onSubmit;

  const ThirdPage({
    super.key,
    required this.formData,
    required this.onPrevious,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PAYMENT DETAILS',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.orange[400],
            ),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Rate',
            value: formData['rate']?.toString() ?? '',
            onChanged: (value) => formData['rate'] = double.tryParse(value) ?? 0.0,
            isDarkMode: isDarkMode,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixIcon: Icon(
              Icons.attach_money,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Extra Fee',
            value: formData['extraFee']?.toString() ?? '',
            onChanged: (value) => formData['extraFee'] = double.tryParse(value) ?? 0.0,
            isDarkMode: isDarkMode,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixIcon: Icon(
              Icons.add_circle_outline,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Extra Fee Description',
            value: formData['extraFeeDescription'] ?? '',
            onChanged: (value) => formData['extraFeeDescription'] = value,
            isDarkMode: isDarkMode,
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            label: 'Payment Method',
            value: formData['paymentMethod'],
            items: const ['Cash', 'Credit', 'Bank Transfer'],
            onChanged: (value) => formData['paymentMethod'] = value,
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            label: 'Delivery Type',
            value: formData['deliveryType'],
            items: const ['Door to Door', 'Branch Pickup'],
            onChanged: (value) => formData['deliveryType'] = value,
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onPrevious,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode 
                        ? Colors.grey[800] 
                        : Colors.grey[200],
                    foregroundColor: isDarkMode 
                        ? Colors.white 
                        : Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Previous',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode 
                        ? Colors.green[700] 
                        : Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    required Function(String) onChanged,
    required bool isDarkMode,
    TextInputType? keyboardType,
    Widget? prefixIcon,
    int? maxLines,
  }) {
    return TextFormField(
      initialValue: value,
      onChanged: onChanged,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required bool isDarkMode,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
    );
  }
}
