import 'dart:async';

import 'package:courier_app/core/services/scanner_service.dart';
import 'package:courier_app/core/theme/theme_provider.dart';
import 'package:courier_app/features/track_order/presentation/widgets/track_order_widget.dart';
import 'package:courier_app/features/track_shipment/bloc/track_shipment_bloc.dart';
import 'package:courier_app/features/track_shipment/presentation/widgets/track_shipment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class TrackShipmentScreen extends StatefulWidget {
  const TrackShipmentScreen({super.key});

  @override
  State<TrackShipmentScreen> createState() => _TrackShipmentScreenState();
}

class _TrackShipmentScreenState extends State<TrackShipmentScreen> {
  final _searchController = TextEditingController();
  final FocusNode _textFieldFocusNode = FocusNode();
  final FocusNode _keyboardFocusNode = FocusNode();
  final ScannerService _scannerService = ScannerService();
  StreamSubscription<String>? _barcodeStreamSubscription;
  ScannerType? _scannerType;
  bool _isHardwareScanner = false;
  bool _hasCameraPermission = false;
  String _scannerBuffer = '';
  DateTime? _lastScannerInput;

  @override
  void initState() {
    super.initState();
    _initializeScanner();
    _requestCameraPermission();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensure scanner is activated when screen becomes visible
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && _scannerType == ScannerType.sunmi) {
        _scannerService.startScanner();
      }
      // Request focus for keyboard input (Sunmi HID mode)
      if (mounted && _scannerType == ScannerType.sunmi) {
        _keyboardFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _textFieldFocusNode.dispose();
    _keyboardFocusNode.dispose();
    _barcodeStreamSubscription?.cancel();
    _scannerService.dispose();
    super.dispose();
  }

  Future<void> _initializeScanner() async {
    try {
      // Detect scanner type (Sunmi, Urovo, or Camera)
      _scannerType = await _scannerService.detectScannerType();

      setState(() {
        _isHardwareScanner = _scannerType == ScannerType.sunmi ||
            _scannerType == ScannerType.urovo;
      });

      if (_scannerType == ScannerType.sunmi ||
          _scannerType == ScannerType.urovo) {
        // Initialize hardware scanner (Sunmi or Urovo)
        final stream = _scannerService.initializeScanner();

        // Set up listener for barcode scans
        _barcodeStreamSubscription = stream.listen(
          (barcode) {
            if (barcode.isNotEmpty && mounted) {
              _onBarcodeDetected(barcode);
            }
          },
          onError: (error) {
            print('Scanner error: $error');
          },
          cancelOnError: false,
        );

        // Start Sunmi scanner if applicable
        if (_scannerType == ScannerType.sunmi) {
          await _scannerService.startScanner();
          _keepScannerActive();
        }
      }
    } catch (e) {
      print('Error initializing scanner: $e');
      setState(() {
        _scannerType = ScannerType.camera;
        _isHardwareScanner = false;
      });
    }
  }

  void _onBarcodeDetected(String barcode) {
    if (barcode.isEmpty) return;

    // Trim whitespace
    barcode = barcode.trim();

    // Set the barcode to the search field
    setState(() {
      _searchController.text = barcode;
    });

    // Automatically trigger search
    _onSearch();
  }

  // Keep scanner active by periodically reactivating it (for Sunmi)
  void _keepScannerActive() {
    if (_scannerType == ScannerType.sunmi) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted && _scannerType == ScannerType.sunmi) {
          _scannerService.startScanner();
          _keepScannerActive(); // Schedule next activation
        }
      });
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.status;

    if (status == PermissionStatus.granted) {
      setState(() {
        _hasCameraPermission = true;
      });
    } else {
      final permission = await Permission.camera.request();
      if (permission == PermissionStatus.granted) {
        setState(() {
          _hasCameraPermission = true;
        });
      }
    }
  }

  void _showCameraScanner() {
    if (!_hasCameraPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Camera permission is required to scan barcodes'),
          backgroundColor: Colors.red,
        ),
      );
      _requestCameraPermission();
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _CameraScannerDialog(
        isDarkMode:
            Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
        onBarcodeDetected: (barcode) {
          Navigator.pop(context);
          _onBarcodeDetected(barcode);
        },
      ),
    );
  }

  void _onSearch() {
    final awb = _searchController.text.trim();
    if (awb.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an AWB number'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<TrackShipmentBloc>().add(TrackShipment(awb));
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF5b3895) : const Color(0xFF5b3895),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkMode
            ? const Color.fromARGB(255, 75, 23, 160)
            : const Color.fromARGB(255, 75, 23, 160),
        title: Text(
          'Track Shipment',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: KeyboardListener(
        focusNode: _keyboardFocusNode,
        onKeyEvent: (event) {
          // Capture keyboard input from scanner (HID mode for Sunmi)
          if (event is KeyDownEvent && _scannerType == ScannerType.sunmi) {
            final keyLabel = event.logicalKey.keyLabel;

            // If it's a printable character, add to buffer
            if (keyLabel.length == 1 && event.character != null) {
              final now = DateTime.now();
              if (_lastScannerInput != null) {
                final timeDiff = now.difference(_lastScannerInput!);
                // If more than 100ms passed, assume new scan started
                if (timeDiff.inMilliseconds > 100) {
                  _scannerBuffer = '';
                }
              }
              _scannerBuffer += event.character!;
              _lastScannerInput = now;
            } else if (event.logicalKey == LogicalKeyboardKey.enter) {
              // Enter key indicates end of barcode
              if (_scannerBuffer.isNotEmpty) {
                _onBarcodeDetected(_scannerBuffer.trim());
                _scannerBuffer = '';
                _lastScannerInput = null;
              }
            }
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF152642) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _textFieldFocusNode,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter AWB Number or Scan',
                    hintStyle: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_isHardwareScanner)
                          IconButton(
                            icon: Icon(
                              _scannerType == ScannerType.sunmi
                                  ? Icons.qr_code_scanner
                                  : Icons.scanner,
                              color: isDarkMode
                                  ? Colors.blue[300]
                                  : Colors.blue[700],
                            ),
                            onPressed: () {
                              // Scanner is always active for hardware scanners
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    _scannerType == ScannerType.sunmi
                                        ? 'Sunmi Scanner Active - Press scan button'
                                        : 'Urovo Scanner Active - Press scan button',
                                  ),
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: Colors.blue,
                                ),
                              );
                            },
                            tooltip: 'Hardware Scanner Active',
                          ),
                        if (!_isHardwareScanner &&
                            _scannerType == ScannerType.camera)
                          IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              color: isDarkMode
                                  ? Colors.green[300]
                                  : Colors.green[700],
                            ),
                            onPressed: _showCameraScanner,
                            tooltip: 'Scan with Camera',
                          ),
                        IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                          ),
                          onPressed: () {
                            _searchController.clear();
                          },
                        ),
                      ],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor:
                        isDarkMode ? const Color(0xFF152642) : Colors.white,
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _onSearch(),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<TrackShipmentBloc, TrackShipmentState>(
                builder: (context, state) {
                  if (state is TrackShipmentLoading) {
                    return TrackOrderWidgets.buildShimmerEffect(isDarkMode);
                  }

                  if (state is TrackShipmentSuccess) {
                    return TrackShipmentWidgets.buildTrackingDetails(
                      isDarkMode: isDarkMode,
                      shipments: state.trackShipmentModel,
                      branches:
                          null, // Branches can be fetched and passed here if needed
                    );
                  }

                  if (state is TrackShipmentFailure) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: isDarkMode ? Colors.red[300] : Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error tracking shipment',
                            style: TextStyle(
                              fontSize: 18,
                              color: isDarkMode ? Colors.red[300] : Colors.red,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            style: TextStyle(
                              color: isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_shipping_outlined,
                          size: 64,
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Enter AWB number to track shipment',
                          style: TextStyle(
                            fontSize: 18,
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CameraScannerDialog extends StatefulWidget {
  final bool isDarkMode;
  final Function(String) onBarcodeDetected;

  const _CameraScannerDialog({
    required this.isDarkMode,
    required this.onBarcodeDetected,
  });

  @override
  State<_CameraScannerDialog> createState() => _CameraScannerDialogState();
}

class _CameraScannerDialogState extends State<_CameraScannerDialog> {
  final MobileScannerController _controller = MobileScannerController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: widget.isDarkMode ? const Color(0xFF1E2837) : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.isDarkMode ? Colors.grey[800] : Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Scan Barcode',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: widget.isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: widget.isDarkMode
                          ? Colors.grey[400]
                          : Colors.grey[600],
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // Scanner
            Container(
              height: 400,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.isDarkMode
                      ? Colors.blue.shade700
                      : Colors.blue.shade200,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: MobileScanner(
                  controller: _controller,
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    if (barcodes.isNotEmpty && barcodes[0].rawValue != null) {
                      widget.onBarcodeDetected(barcodes[0].rawValue!);
                    }
                  },
                ),
              ),
            ),
            // Instructions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Align barcode within the frame',
                style: TextStyle(
                  color:
                      widget.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
