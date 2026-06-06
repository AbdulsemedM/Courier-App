import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:courier_app/core/theme/app_palette.dart';
import 'package:courier_app/core/utils/image_compression_helper.dart';

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
  int? _customerIdFileSizeBytes;
  bool _isSelf = true;
  final _deliveredToNameController = TextEditingController();
  final _deliveredToPhoneController = TextEditingController();
  bool _isLoading = false;
  bool _isCompressingImage = false;

  @override
  void dispose() {
    _deliveredToNameController.dispose();
    _deliveredToPhoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_isCompressingImage || _isLoading) return;

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 70,
      );
      if (image == null || !mounted) return;

      setState(() {
        _isCompressingImage = true;
        _customerIdFile = null;
        _customerIdFileSizeBytes = null;
      });

      final compressedFile =
          await ImageCompressionHelper.compressForUpload(File(image.path));
      final fileSize = await compressedFile.length();

      if (!mounted) return;
      setState(() {
        _customerIdFile = compressedFile;
        _customerIdFileSizeBytes = fileSize;
        _isCompressingImage = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isCompressingImage = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e is Exception
                ? e.toString().replaceFirst('Exception: ', '')
                : 'Could not prepare the photo. Please try again.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showImageSourceDialog() {
    if (_isCompressingImage || _isLoading) return;
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
            if (_customerIdFileSizeBytes != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Photo ready · ${ImageCompressionHelper.formatFileSize(_customerIdFileSizeBytes!)}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.green.shade700,
                  ),
                ),
              ),
            GestureDetector(
              onTap: _isCompressingImage ? null : _showImageSourceDialog,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: context.palette.surfaceMuted,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.palette.border,
                  ),
                ),
                child: _isCompressingImage
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 28,
                              width: 28,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Compressing photo...',
                              style: TextStyle(
                                color: context.palette.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : _customerIdFile != null
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
                                  _customerIdFileSizeBytes = null;
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
              onPressed: (_isLoading || _isCompressingImage) ? null : _handleSubmit,
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

