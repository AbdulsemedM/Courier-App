import 'package:courier_app/features/track_order/model/statuses_model.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:provider/provider.dart';
// import '../../../../core/theme/theme_provider.dart';

class BarcodeReaderWidgets {
  static Widget buildScanner({
    required bool isDarkMode,
    required Function(String) onBarcodeDetected,
  }) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDarkMode ? Colors.blue.shade700 : Colors.blue.shade200,
                width: 2,
              ),
            ),
            margin: const EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: MobileScanner(
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  if (barcodes.isNotEmpty && barcodes[0].rawValue != null) {
                    onBarcodeDetected(barcodes[0].rawValue!);
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Align barcode within the frame',
          style: TextStyle(
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  static Widget buildManualEntry({
    required bool isDarkMode,
    required TextEditingController controller,
    required Function(dynamic) onSubmit,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Enter AWB Number(s)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Separate multiple entries with commas',
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            textCapitalization: TextCapitalization.characters,
            onChanged: (value) {
              // Remove spaces and convert to uppercase
              final newValue = value.replaceAll(' ', '').toUpperCase();
              if (value != newValue) {
                controller.value = controller.value.copyWith(
                  text: newValue,
                  selection: TextSelection.collapsed(offset: newValue.length),
                );
              }
            },
            decoration: InputDecoration(
              hintText: 'e.g. ETAA11111,ETAA22222,ETAA33333',
              hintStyle: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
              filled: true,
              fillColor: isDarkMode
                  ? Colors.grey[800]!.withOpacity(0.5)
                  : Colors.grey[100],
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
                ),
              ),
            ),
            onSubmitted: (value) {
              if (value.isEmpty) return;

              final barcodes = value
                  .split(',')
                  .where((code) => code.trim().isNotEmpty)
                  .map((code) => code.trim())
                  .toList();

              onSubmit(barcodes);
              controller.clear();
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isEmpty) return;

              final barcodes = controller.text
                  .split(',')
                  .where((code) => code.trim().isNotEmpty)
                  .map((code) => code.trim())
                  .toList();

              onSubmit(barcodes);
              controller.clear();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode ? Colors.blue[700] : Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Track Shipment(s)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildToggleButton({
    required bool isDarkMode,
    required bool isScanning,
    required VoidCallback onToggle,
  }) {
    return FloatingActionButton.extended(
      onPressed: onToggle,
      backgroundColor: isDarkMode ? Colors.blue[700] : Colors.blue,
      icon: Icon(
        isScanning ? Icons.edit : Icons.qr_code_scanner,
        color: Colors.white,
      ),
      label: Text(
        isScanning ? 'Manual Entry' : 'Scan Barcode',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static Widget buildErrorMessage(String message, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.red[900]!.withOpacity(0.2) : Colors.red[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.red[700]! : Colors.red[300]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: isDarkMode ? Colors.red[300] : Colors.red[700],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: isDarkMode ? Colors.red[300] : Colors.red[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildStatusDropdown({
    required bool isDarkMode,
    required String? selectedStatus,
    required List<StatusModel> statuses,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Status',
            style: TextStyle(
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.grey[800]!.withOpacity(0.5)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedStatus,
                hint: Text(
                  'Select status',
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                isExpanded: true,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
                dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
                items: statuses
                    .map((status) => DropdownMenuItem<String>(
                          value: status.code,
                          child: Text(
                            '${status.code} - ${status.description}',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
