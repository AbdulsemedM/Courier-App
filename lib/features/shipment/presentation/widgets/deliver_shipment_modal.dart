import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:courier_app/core/theme/app_palette.dart';

class DeliverShipmentModal extends StatefulWidget {
  final String awb;
  final Function({
    required String awb,
    required bool isSelf,
    File? customerIdFile,
    String? deliveredToName,
    String? deliveredToPhone,
  }) onDeliver;

  const DeliverShipmentModal({
    super.key,
    required this.awb,
    required this.onDeliver,
  });

  @override
  State<DeliverShipmentModal> createState() => _DeliverShipmentModalState();
}

class _DeliverShipmentModalState extends State<DeliverShipmentModal> {
  final ImagePicker _imagePicker = ImagePicker();
  File? _customerIdFile;
  bool _isSelf = true;
  final _deliveredToNameController = TextEditingController();
  final _deliveredToPhoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _deliveredToNameController.dispose();
    _deliveredToPhoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _customerIdFile = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (_customerIdFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload customer ID'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_isSelf) {
      if (_deliveredToNameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter delivered to name'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      if (_deliveredToPhoneController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter delivered to phone'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    widget.onDeliver(
      awb: widget.awb,
      isSelf: _isSelf,
      customerIdFile: _customerIdFile,
      deliveredToName: _isSelf ? null : _deliveredToNameController.text.trim(),
      deliveredToPhone: _isSelf ? null : _deliveredToPhoneController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.palette.appBarBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.palette.textSecondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            Text(
              'Deliver Shipment',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: context.palette.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'AWB: ${widget.awb}',
              style: TextStyle(
                fontSize: 16,
                color: context.palette.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            // Customer ID Upload
            Text(
              'Customer ID *',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: context.palette.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _showImageSourceDialog,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: context.palette.surfaceMuted,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.palette.border,
                  ),
                ),
                child: _customerIdFile != null
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _customerIdFile!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _customerIdFile = null;
                                });
                              },
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate,
                              size: 48,
                              color: context.palette.textSecondary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap to upload',
                              style: TextStyle(
                                color: context.palette.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            // Deliver to self checkbox
            CheckboxListTile(
              value: _isSelf,
              onChanged: (value) {
                setState(() {
                  _isSelf = value ?? true;
                });
              },
              title: Text(
                'Deliver to self',
                style: TextStyle(
                  color: context.palette.textPrimary,
                ),
              ),
              activeColor: Colors.green,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 16),
            // Delivered to name and phone (shown when isSelf is false)
            if (!_isSelf) ...[
              TextField(
                controller: _deliveredToNameController,
                style: TextStyle(
                  color: context.palette.textPrimary,
                ),
                decoration: InputDecoration(
                  labelText: 'Delivered to Name *',
                  labelStyle: TextStyle(
                    color: context.palette.textSecondary,
                  ),
                  filled: true,
                  fillColor: context.palette.surfaceMuted,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _deliveredToPhoneController,
                keyboardType: TextInputType.phone,
                style: TextStyle(
                  color: context.palette.textPrimary,
                ),
                decoration: InputDecoration(
                  labelText: 'Delivered to Phone *',
                  labelStyle: TextStyle(
                    color: context.palette.textSecondary,
                  ),
                  filled: true,
                  fillColor: context.palette.surfaceMuted,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
            // Submit button
            ElevatedButton(
              onPressed: _isLoading ? null : _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Deliver',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

