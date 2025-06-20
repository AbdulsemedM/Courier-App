import 'package:courier_app/features/add_shipment/model/service_modes_model.dart';
import 'package:courier_app/features/add_shipment/model/shipment_type_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_provider.dart';

class SecondPage extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final List<ServiceModeModel> serviceModes;
  final List<ShipmentTypeModel> shipmentTypes;

  const SecondPage({
    super.key,
    required this.formData,
    required this.onNext,
    required this.onPrevious,
    required this.serviceModes,
    required this.shipmentTypes,
  });

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  String? selectedUnit;

  @override
  void initState() {
    super.initState();
    // selectedUnit = widget.formData['unit'] as String?;
  }

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
            'SHIPMENT DETAILS',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue[400],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'Quantity',
                  value: widget.formData['quantity']?.toString() ?? '',
                  onChanged: (value) =>
                      widget.formData['quantity'] = int.tryParse(value) ?? 0,
                  isDarkMode: isDarkMode,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildUnitDropdown(
                  label: 'Unit',
                  value: selectedUnit,
                  onChanged: (value) {
                    setState(() {
                      selectedUnit = value;
                      widget.formData['unit'] = value;
                    });
                  },
                  isDarkMode: isDarkMode,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'Number of Pieces',
                  value: widget.formData['numPcs']?.toString() ?? '',
                  onChanged: (value) => setState(() {
                    widget.formData['numPcs'] = int.tryParse(value) ?? 0;
                  }),
                  isDarkMode: isDarkMode,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  label: 'Number of Boxes',
                  value: widget.formData['numBoxes']?.toString() ?? '',
                  onChanged: (value) => setState(() {
                    widget.formData['numBoxes'] = int.tryParse(value) ?? 0;
                  }),
                  isDarkMode: isDarkMode,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Description',
            value: widget.formData['shipmentDescription'] ?? '',
            onChanged: (value) => setState(() {
              widget.formData['shipmentDescription'] = value;
            }),
            isDarkMode: isDarkMode,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            label: 'Service Mode',
            value: null,
            items: widget.serviceModes
                .map((mode) => DropdownMenuItem<String>(
                      value: mode.id?.toString(),
                      child: Text(mode.description ?? ''),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  final selectedMode = widget.serviceModes.firstWhere(
                    (mode) => mode.id?.toString() == value,
                    orElse: () => ServiceModeModel(),
                  );
                  widget.formData['serviceModeId'] = selectedMode.id;
                  // widget.formData['serviceModeObject'] = selectedMode;
                });
              }
            },
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            label: 'Shipment Type',
            value: null,
            items: widget.shipmentTypes
                .map((mode) => DropdownMenuItem<String>(
                      value: mode.id?.toString(),
                      child: Text(mode.description ?? ''),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  widget.formData['shipmentTypeId'] = int.parse(value);
                });
              }
            },
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.onPrevious,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    foregroundColor: isDarkMode ? Colors.white : Colors.black87,
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
                  onPressed: (widget.formData['quantity'] == null ||
                          widget.formData['quantity'] == 0 ||
                          widget.formData['unit'] == null ||
                          widget.formData['unit'] == '' ||
                          // widget.formData['numPcs'] == null ||
                          // widget.formData['numPcs'] == 0 ||
                          // widget.formData['numBoxes'] == null ||
                          // widget.formData['numBoxes'] == 0 ||
                          widget.formData['serviceModeId'] == null ||
                          widget.formData['serviceModeId'] == 1 ||
                          widget.formData['shipmentTypeId'] == null ||
                          widget.formData['shipmentTypeId'] == 1 ||
                          widget.formData['shipmentDescription'] == null ||
                          widget.formData['shipmentDescription'] == '')
                      ? null
                      : widget.onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode
                        ? const Color(0xFFFF5A00)
                        : const Color(0xFFFF5A00),
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
    int? maxLines,
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

  Widget _buildUnitDropdown({
    required String label,
    required String? value,
    required Function(String?) onChanged,
    required bool isDarkMode,
  }) {
    const units = ['Kg', 'CBM'];

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
        Container(
          decoration: BoxDecoration(
            color:
                isDarkMode ? Colors.grey[800]!.withOpacity(0.5) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
                hint: Text(
                  'Select Unit',
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                items: units.map((String unit) {
                  return DropdownMenuItem<String>(
                    value: unit,
                    child: Text(unit),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
