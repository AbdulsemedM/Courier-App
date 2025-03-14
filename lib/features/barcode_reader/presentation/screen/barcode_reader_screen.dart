import 'package:courier_app/features/barcode_reader/bloc/barcode_reader_bloc.dart';
import 'package:courier_app/features/track_order/bloc/track_order_bloc.dart';
import 'package:courier_app/features/track_order/model/statuses_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/theme/theme_provider.dart';
import '../widgets/barcode_reader_widget.dart';

class BarcodeReaderScreen extends StatefulWidget {
  const BarcodeReaderScreen({super.key});

  @override
  State<BarcodeReaderScreen> createState() => _BarcodeReaderScreenState();
}

class _BarcodeReaderScreenState extends State<BarcodeReaderScreen> {
  bool _isScanning = true;
  bool _hasCameraPermission = false;
  final _trackingController = TextEditingController();
  String? _error;
  final Set<String> _scannedBarcodes = {}; // Using Set to ensure uniqueness
  bool _isPaused = false;
  List<StatusModel> statuses = [];
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
    context.read<TrackOrderBloc>().add(FetchStatuses());
  }

  @override
  void dispose() {
    _trackingController.dispose();
    super.dispose();
  }

  Future<void> _checkCameraPermission() async {
    final status = await Permission.camera.status;
    setState(() {
      _hasCameraPermission = status.isGranted;
    });

    if (!status.isGranted) {
      final result = await Permission.camera.request();
      setState(() {
        _hasCameraPermission = result.isGranted;
      });
    }
  }

  Widget _buildCameraPermissionDenied(bool isDarkMode) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 64,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              'Camera Permission Required',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please grant camera permission to scan barcodes',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await openAppSettings();
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
              child: const Text('Open Settings'),
            ),
          ],
        ),
      ),
    );
  }

  void _onBarcodeDetected(String barcode) async {
    if (_isPaused) return; // Ignore if scanning is paused

    if (barcode.isEmpty) {
      setState(() {
        _error = 'Invalid barcode detected';
      });
      return;
    }

    if (_scannedBarcodes.contains(barcode)) {
      setState(() {
        _error = 'This barcode has already been scanned';
      });
      return;
    }

    setState(() => _isPaused = true); // Pause scanning

    final bool? shouldStore = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildBarcodeDialog(barcode),
    );

    if (shouldStore == true) {
      setState(() {
        _scannedBarcodes.add(barcode);
        _error = null;
      });
    }

    setState(() => _isPaused = false); // Resume scanning
  }

  Widget _buildBarcodeDialog(String barcode) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;

    return AlertDialog(
      backgroundColor: isDarkMode ? const Color(0xFF1E2837) : Colors.white,
      title: Text(
        'Barcode Detected',
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Value: $barcode',
            style: TextStyle(
              color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Total scanned: ${_scannedBarcodes.length}',
            style: TextStyle(
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            'Skip',
            style: TextStyle(
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: isDarkMode ? Colors.blue[700] : Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: const Text('Store & Continue'),
        ),
      ],
    );
  }

  Widget _buildScannedList(bool isDarkMode) {
    if (_scannedBarcodes.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            isDarkMode ? Colors.grey[900]!.withOpacity(0.5) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Scanned Barcodes (${_scannedBarcodes.length})',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.clear_all),
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                onPressed: () {
                  setState(() => _scannedBarcodes.clear());
                },
                tooltip: 'Clear all',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _scannedBarcodes
                .map((barcode) => Chip(
                      label: Text(
                        barcode,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      backgroundColor: isDarkMode
                          ? Colors.blue[900]!.withOpacity(0.3)
                          : Colors.blue[100],
                      deleteIcon: Icon(
                        Icons.close,
                        size: 16,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                      onDeleted: () {
                        setState(() => _scannedBarcodes.remove(barcode));
                      },
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown(bool isDarkMode) {
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
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onManualSubmit(dynamic value) {
    if (value == null || (value is List && value.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter tracking number(s)'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a status'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Now we can be sure value is a List<String>
    context.read<BarcodeReaderBloc>().add(
          BarcodeReaderChangeStatusEvent(
            shipmentIds: value,
            status: selectedStatus!,
          ),
        );
  }

  void _toggleScanMode() {
    setState(() {
      _isScanning = !_isScanning;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return MultiBlocListener(
      listeners: [
        BlocListener<TrackOrderBloc, TrackOrderState>(
          listenWhen: (previous, current) => current is FetchStatusSuccess,
          listener: (context, state) {
            if (state is FetchStatusSuccess) {
              setState(() {
                statuses = state.statuses;
              });
            }
          },
        ),
        BlocListener<BarcodeReaderBloc, BarcodeReaderState>(
          listener: (context, state) {
            if (state is BarcodeReaderSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              _trackingController.clear();
              setState(() {
                selectedStatus = null;
              });
            }
            if (state is BarcodeReaderError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor:
            isDarkMode ? const Color(0xFF0A1931) : Colors.grey[100],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            'Track Shipment',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          children: [
            if (_error != null)
              BarcodeReaderWidgets.buildErrorMessage(_error!, isDarkMode),
            if (_scannedBarcodes.isNotEmpty) _buildScannedList(isDarkMode),
            Expanded(
              child: _isScanning
                  ? _hasCameraPermission
                      ? BarcodeReaderWidgets.buildScanner(
                          isDarkMode: isDarkMode,
                          onBarcodeDetected: _onBarcodeDetected,
                        )
                      : _buildCameraPermissionDenied(isDarkMode)
                  : Column(
                      children: [
                        _buildStatusDropdown(isDarkMode),
                        Expanded(
                          child: BarcodeReaderWidgets.buildManualEntry(
                            isDarkMode: isDarkMode,
                            controller: _trackingController,
                            onSubmit: _onManualSubmit,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
        floatingActionButton: BarcodeReaderWidgets.buildToggleButton(
          isDarkMode: isDarkMode,
          isScanning: _isScanning,
          onToggle: _toggleScanMode,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
