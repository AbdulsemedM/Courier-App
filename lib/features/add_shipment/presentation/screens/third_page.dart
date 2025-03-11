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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shipment Information Section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color(0xFF1A1F37).withOpacity(0.5)
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.local_shipping_outlined,
                      color: Colors.red[400],
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'SHIPMENT INFORMATION',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[400],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildDropdownField(
                  label: 'Payment Mode',
                  value: formData['paymentMode'],
                  items: const ['CASH', 'CREDIT'],
                  onChanged: (value) => formData['paymentMode'] = value,
                  isDarkMode: isDarkMode,
                  icon: Icons.payment,
                ),
                const SizedBox(height: 24),
                _buildDropdownField(
                  label: 'Payment Method',
                  value: formData['paymentMethod'],
                  items: const ['cash', 'bank transfer', 'mobile money'],
                  onChanged: (value) => formData['paymentMethod'] = value,
                  isDarkMode: isDarkMode,
                  icon: Icons.account_balance_wallet,
                ),
                const SizedBox(height: 24),
                _buildDropdownField(
                  label: 'Delivery Type',
                  value: formData['deliveryType'],
                  items: const ['BRANCH TO BRANCH', 'DOOR TO DOOR'],
                  onChanged: (value) => formData['deliveryType'] = value,
                  isDarkMode: isDarkMode,
                  icon: Icons.local_shipping,
                ),
                const SizedBox(height: 24),
                _buildDropdownField(
                  label: 'Transport Mode',
                  value: formData['transportMode'],
                  items: const ['ground', 'air'],
                  onChanged: (value) => formData['transportMode'] = value,
                  isDarkMode: isDarkMode,
                  icon: Icons.directions_bus,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Credit Account Section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color(0xFF1A1F37).withOpacity(0.5)
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.account_balance,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Credit Account',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  label: 'Credit Account',
                  value: formData['creditAccount'] ?? '',
                  onChanged: (value) => formData['creditAccount'] = value,
                  isDarkMode: isDarkMode,
                  hintText: 'Type something...',
                  icon: Icons.credit_card,
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  label: 'Hudhud Percent',
                  value: formData['hudhudPercent']?.toString() ?? '',
                  onChanged: (value) =>
                      formData['hudhudPercent'] = double.tryParse(value) ?? 0.0,
                  isDarkMode: isDarkMode,
                  keyboardType: TextInputType.number,
                  icon: Icons.percent,
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  label: 'HudHudNet',
                  value: formData['hudHudNet']?.toString() ?? '',
                  onChanged: (value) =>
                      formData['hudHudNet'] = double.tryParse(value) ?? 0.0,
                  isDarkMode: isDarkMode,
                  keyboardType: TextInputType.number,
                  icon: Icons.attach_money,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // Navigation Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onPrevious,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    foregroundColor: isDarkMode ? Colors.white : Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onSubmit,
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isDarkMode ? Colors.green[700] : Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
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
    String? hintText,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          onChanged: onChanged,
          keyboardType: keyboardType,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
            ),
            filled: true,
            fillColor: isDarkMode ? const Color(0xFF1A1F37) : Colors.white,
            prefixIcon: icon != null
                ? Icon(
                    icon,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDarkMode ? Colors.blue[400]! : Colors.blue[700]!,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required bool isDarkMode,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: onChanged,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
          icon: const Icon(Icons.arrow_drop_down_circle_outlined),
          dropdownColor: isDarkMode ? const Color(0xFF1A1F37) : Colors.white,
          decoration: InputDecoration(
            filled: true,
            fillColor: isDarkMode ? const Color(0xFF1A1F37) : Colors.white,
            prefixIcon: icon != null
                ? Icon(
                    icon,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDarkMode ? Colors.blue[400]! : Colors.blue[700]!,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
