import 'package:courier_app/app/utils/dialog_utils.dart';
import 'package:courier_app/configuration/auth_service.dart';
import 'package:courier_app/core/theme/app_palette.dart';
import 'package:courier_app/features/barcode_reader/presentation/widgets/barcode_reader_widget.dart';
import 'package:courier_app/features/manifest/bloc/manifest_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CreateManifestScreen extends StatefulWidget {
  final int branchId;
  final DateTime selectedDate;

  const CreateManifestScreen({
    super.key,
    required this.branchId,
    required this.selectedDate,
  });

  @override
  State<CreateManifestScreen> createState() => _CreateManifestScreenState();
}

class _CreateManifestScreenState extends State<CreateManifestScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _awbController = TextEditingController();

  final List<String> _awbs = [];
  String _fileType = 'EXCEL';
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    final date = DateFormat('yyyy-MM-dd').format(widget.selectedDate);
    context.read<ManifestBloc>().add(
          FetchManifests(branchId: widget.branchId, date: date),
        );
  }

  @override
  void dispose() {
    _awbController.dispose();
    super.dispose();
  }

  void _addAwb(String raw) {
    final awb = raw.replaceAll(' ', '').toUpperCase();
    if (awb.isEmpty) return;

    if (_awbs.contains(awb)) {
      displaySnack(context, 'AWB already added', Colors.orange);
      return;
    }

    setState(() {
      _awbs.add(awb);
      _awbController.clear();
    });
  }

  void _removeAwb(String awb) {
    setState(() => _awbs.remove(awb));
  }

  Future<void> _submit() async {
    if (_awbs.isEmpty) {
      displaySnack(context, 'Add at least one AWB', Colors.red);
      return;
    }

    final userIdRaw = await _authService.getUserId();
    final userId = int.tryParse(userIdRaw ?? '');
    if (!mounted) return;
    if (userId == null) {
      displaySnack(context, 'User not found. Please log in again.', Colors.red);
      return;
    }
    context.read<ManifestBloc>().add(
          CreateManifest(
            awbs: List<String>.from(_awbs),
            fileType: _fileType,
            userId: userId,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDarkMode = context.isDarkMode;

    return BlocListener<ManifestBloc, ManifestState>(
      listenWhen: (previous, current) =>
          current is CreateManifestSuccess ||
          current is CreateManifestFailure,
      listener: (context, state) {
        if (state is CreateManifestSuccess) {
          displaySnack(
            context,
            state.message,
            Colors.green,
          );
          Navigator.pop(context, true);
        } else if (state is CreateManifestFailure) {
          displaySnack(context, state.message, Colors.red);
        }
      },
      child: Scaffold(
        backgroundColor: palette.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: palette.appBarBackground,
          surfaceTintColor: Colors.transparent,
          title: Text(
            'Create Manifest',
            style: TextStyle(
              color: palette.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocBuilder<ManifestBloc, ManifestState>(
          builder: (context, state) {
            final isSubmitting = state is CreateManifestLoading;

            return AbsorbPointer(
              absorbing: isSubmitting,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Add AWBs',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _awbController,
                            textCapitalization: TextCapitalization.characters,
                            style: TextStyle(color: palette.textPrimary),
                            decoration: InputDecoration(
                              hintText: 'Enter AWB',
                              hintStyle:
                                  TextStyle(color: palette.textSecondary),
                              filled: true,
                              fillColor: palette.surface,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onSubmitted: _addAwb,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filled(
                          onPressed: () => _addAwb(_awbController.text),
                          icon: const Icon(Icons.add),
                        ),
                        IconButton.filled(
                          onPressed: () =>
                              setState(() => _isScanning = !_isScanning),
                          icon: Icon(
                            _isScanning ? Icons.keyboard : Icons.qr_code_scanner,
                          ),
                        ),
                      ],
                    ),
                    if (_isScanning) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 260,
                        child: BarcodeReaderWidgets.buildScanner(
                          isDarkMode: isDarkMode,
                          onBarcodeDetected: _addAwb,
                        ),
                      ),
                    ],
                    if (_awbs.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _awbs
                            .map(
                              (awb) => Chip(
                                label: Text(awb),
                                deleteIcon: const Icon(Icons.close, size: 16),
                                onDeleted: () => _removeAwb(awb),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                    const SizedBox(height: 24),
                    DropdownButtonFormField<String>(
                      value: _fileType,
                      decoration: InputDecoration(
                        labelText: 'File Type',
                        filled: true,
                        fillColor: palette.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      dropdownColor: palette.surface,
                      style: TextStyle(color: palette.textPrimary),
                      items: const [
                        DropdownMenuItem(
                          value: 'EXCEL',
                          child: Text('EXCEL'),
                        ),
                        DropdownMenuItem(
                          value: 'XML',
                          child: Text('XML'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _fileType = value);
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: palette.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Create Manifest'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
