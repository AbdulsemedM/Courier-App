import 'package:courier_app/features/add_shipment/model/branch_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_provider.dart';

class FirstPage extends StatelessWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onNext;
  final List<BranchModel> branch;

  const FirstPage({
    super.key,
    required this.formData,
    required this.onNext,
    required this.branch,
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
            'RECEIVER INFORMATION',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red[400],
            ),
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            label: 'Receiver Branch',
            value: formData['receiverBranchId']?.toString(),
            items: branch
                .map((branch) => DropdownMenuItem(
                      value: branch.id?.toString(),
                      child: Text(branch.name ?? ''),
                    ))
                .where((item) => item.value != null)
                .toList(),
            onChanged: (value) {
              if (value != null) {
                final selectedBranch = branch.firstWhere(
                  (b) => b.id?.toString() == value,
                  orElse: () => BranchModel(),
                );
                formData['receiverBranchId'] = selectedBranch.id;
                // formData['receiverBranchObject'] = selectedBranch;
              }
            },
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Receiver Mobile',
            value: formData['receiverMobile'],
            onChanged: (value) => formData['receiverMobile'] = value,
            isDarkMode: isDarkMode,
            keyboardType: TextInputType.phone,
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement receiver check
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('CHECK RECEIVER'),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Receiver Name',
            value: formData['receiverName'],
            onChanged: (value) => formData['receiverName'] = value,
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 32),
          Text(
            'SENDER INFORMATION',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green[400],
            ),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Sender Mobile',
            value: formData['senderMobile'],
            onChanged: (value) => formData['senderMobile'] = value,
            isDarkMode: isDarkMode,
            keyboardType: TextInputType.phone,
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement sender check
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('CHECK SENDER'),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Sender Name',
            value: formData['senderName'],
            onChanged: (value) => formData['senderName'] = value,
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            label: 'Sender Branch',
            value: formData['senderBranchId']?.toString(),
            items: branch
                .map((branch) => DropdownMenuItem(
                      value: branch.id?.toString(),
                      child: Text(branch.name ?? ''),
                    ))
                .where((item) => item.value != null)
                .toList(),
            onChanged: (value) {
              if (value != null) {
                final selectedBranch = branch.firstWhere(
                  (b) => b.id?.toString() == value,
                  orElse: () => BranchModel(),
                );
                formData['senderBranchId'] = selectedBranch.id;
                // formData['senderBranchObject'] = selectedBranch;
              }
            },
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.blue[700] : Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Next',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          onChanged: onChanged,
          keyboardType: keyboardType,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor:
                isDarkMode ? Colors.grey[800]!.withOpacity(0.5) : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDarkMode ? Colors.blue[400]! : Colors.blue[700]!,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
    required bool isDarkMode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items,
          onChanged: onChanged,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
          dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
          decoration: InputDecoration(
            filled: true,
            fillColor:
                isDarkMode ? Colors.grey[800]!.withOpacity(0.5) : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDarkMode ? Colors.blue[400]! : Colors.blue[700]!,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }
}
