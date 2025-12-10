import 'dart:async';

import 'package:courier_app/features/barcode_reader/bloc/barcode_reader_bloc.dart';
import 'package:courier_app/features/track_order/bloc/track_order_bloc.dart';
import 'package:courier_app/features/track_order/model/statuses_model.dart';
import 'package:courier_app/features/track_order/presentation/screens/track_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/services/scanner_service.dart';
import '../widgets/barcode_reader_widget.dart';
import 'package:flutter/services.dart';

class BarcodeReaderScreen extends StatefulWidget {
  const BarcodeReaderScreen({super.key});

  @override
  State<BarcodeReaderScreen> createState() => _BarcodeReaderScreenState();
}

class _BarcodeReaderScreenState extends State<BarcodeReaderScreen> {
  bool _isScanning = true;
  bool _hasCameraPermission = false;
  bool _isHardwareScanner = false; // True for Sunmi or Urovo
  String _deviceName = 'Unknown';
  final _trackingController = TextEditingController();
  String? _error;
  final Set<String> _scannedBarcodes = {}; // Using Set to ensure uniqueness
  List<String> _scannedBarcodesList = []; // List for UI updates
  bool _isPaused = false;
  final FocusNode _focusNode = FocusNode(); // For capturing scanner input
  String _scannerBuffer = ''; // Buffer for scanner input
  DateTime? _lastScannerInput; // Track timing of scanner input
  List<StatusModel> statuses = [];
  String? selectedStatus;
  StreamSubscription<String>? _barcodeStreamSubscription;
  final ScannerService _scannerService = ScannerService();
  ScannerType? _scannerType;

  @override
  void initState() {
    super.initState();
    _initializeScanner();
    _requestCameraPermission();
    context.read<TrackOrderBloc>().add(FetchStatuses());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensure scanner is activated when screen becomes visible
    // Wait a bit for initialization to complete
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && _scannerType == ScannerType.sunmi) {
        _scannerService.startScanner();
      }
    });
  }

  @override
  void dispose() {
    _trackingController.dispose();
    _focusNode.dispose();
    _barcodeStreamSubscription?.cancel();
    _scannerService.dispose();
    super.dispose();
  }

  Future<void> _initializeScanner() async {
    try {
      // Detect scanner type (Sunmi, Urovo, or Camera)
      _scannerType = await _scannerService.detectScannerType();
      _deviceName = _scannerService.deviceName ?? 'Unknown device';

      print('Scanner type detected: $_scannerType');
      print('Device name: $_deviceName');

      setState(() {
        _deviceName = _deviceName;
        _isHardwareScanner = _scannerType == ScannerType.sunmi ||
            _scannerType == ScannerType.urovo;
      });

      print('Hardware scanner flag set to: $_isHardwareScanner');

      if (_scannerType == ScannerType.sunmi ||
          _scannerType == ScannerType.urovo) {
        // Initialize hardware scanner (Sunmi or Urovo)
        print('BarcodeReaderScreen: Initializing scanner stream...');
        final stream = _scannerService.initializeScanner();
        print('BarcodeReaderScreen: Stream obtained, setting up listener...');

        // Set up listener FIRST before starting scanner
        _barcodeStreamSubscription = stream.listen(
          (barcode) {
            print(
                'BarcodeReaderScreen: ✅✅✅ Received barcode from stream: "$barcode"');
            print('BarcodeReaderScreen: Barcode length: ${barcode.length}');
            print('BarcodeReaderScreen: Widget mounted: $mounted');
            print(
                'BarcodeReaderScreen: Current list length: ${_scannedBarcodesList.length}');

            if (barcode.isNotEmpty) {
              print('BarcodeReaderScreen: Processing barcode: $barcode');
              // Call directly first
              if (mounted) {
                print(
                    'BarcodeReaderScreen: Calling _onBarcodeDetected directly');
                _onBarcodeDetected(barcode);
              }

              // Also call in postFrameCallback as backup
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  print(
                      'BarcodeReaderScreen: Calling _onBarcodeDetected in postFrameCallback (backup)');
                  // Only call if barcode wasn't already added (check by length)
                  if (!_scannedBarcodesList.contains(barcode)) {
                    _onBarcodeDetected(barcode);
                  } else {
                    print(
                        'BarcodeReaderScreen: Barcode already in list, skipping duplicate');
                  }
                } else {
                  print(
                      'BarcodeReaderScreen: Widget not mounted in postFrameCallback');
                }
              });
            } else {
              print('BarcodeReaderScreen: ⚠️ Received empty barcode');
            }
          },
          onError: (error) {
            print('BarcodeReaderScreen: ❌ Scanner error: $error');
            if (mounted) {
              setState(() {
                _error = 'Scanner error: $error';
              });
            }
          },
          cancelOnError: false, // Keep listening even on error
        );
        print(
            'BarcodeReaderScreen: ✅ Scanner stream subscription created and listening');

        // Wait a moment to ensure listener is ready, then start scanner
        await Future.delayed(const Duration(milliseconds: 100));

        // Start Sunmi scanner if applicable - keep it active
        if (_scannerType == ScannerType.sunmi) {
          print('BarcodeReaderScreen: Starting Sunmi scanner...');
          await _scannerService.startScanner();
          print('BarcodeReaderScreen: Sunmi scanner started');

          // Request focus to capture keyboard input (scanner may send as HID keyboard)
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _focusNode.requestFocus();
              print('BarcodeReaderScreen: Requested focus for keyboard input');
            }
          });

          // Keep scanner active - retry periodically
          _keepScannerActive();
        }
      } else {
        // Initialize regular camera scanner
        _requestCameraPermission();
      }
    } on PlatformException catch (e) {
      print('Error initializing scanner: ${e.message}');
      // Fallback to regular camera scanner
      setState(() {
        _scannerType = ScannerType.camera;
        _isHardwareScanner = false;
      });
      _requestCameraPermission();
    } catch (e) {
      print('Unexpected error initializing scanner: $e');
      setState(() {
        _scannerType = ScannerType.camera;
        _isHardwareScanner = false;
      });
      _requestCameraPermission();
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.status;

    if (status == PermissionStatus.granted) {
      setState(() {
        _hasCameraPermission = true;
      });
      // Permission is already granted
      print('Camera permission is already granted');
      // Use the camera
    } else {
      // Request permission
      final permission = await Permission.camera.request();
      if (permission == PermissionStatus.granted) {
        print('Camera permission granted');
        setState(() {
          _hasCameraPermission = true;
        });
        // Use the camera
      } else {
        final permission = await Permission.camera.request();
        if (permission == PermissionStatus.granted) {
          print('Camera permission granted');
          setState(() {
            _hasCameraPermission = true;
          });
          // Use the camera
        }
        // _showSettingsRedirectDialog();
        // Handle the case where permission is denied
      }
    }
  }

  // Future<void> _requestCameraPermission() async {
  //   final status = await Permission.camera.status;

  //   if (status.isDenied || status.isRestricted) {
  //     final result = await Permission.camera.request();
  //     setState(() {
  //       _hasCameraPermission = result.isGranted;
  //     });

  //     // _showPermissionExplanationDialog();
  //   } else if (status.isGranted) {
  //     setState(() {
  //       _hasCameraPermission = true;
  //     });
  //   } else if (status.isPermanentlyDenied) {
  //     // Inform the user that they need to enable the permission in settings
  //     _showSettingsRedirectDialog();
  //   }
  // }

  void _showPermissionExplanationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Camera Permission Required'),
        content: const Text(
          'This app requires camera access to scan barcodes. Please grant camera permission to continue.',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final result = await Permission.camera.request();
              setState(() {
                _hasCameraPermission = result.isGranted;
              });
            },
            child: const Text('Allow'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Deny'),
          ),
        ],
      ),
    );
  }

  void _showSettingsRedirectDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'Camera permission is permanently denied. Please enable it in settings to use the barcode scanner.',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _onBarcodeDetected(String barcode) async {
    print('_onBarcodeDetected called with: $barcode');

    if (_isPaused) {
      print('Scanner is paused, ignoring barcode');
      return; // Ignore if scanning is paused
    }

    if (barcode.isEmpty) {
      print('Empty barcode detected');
      setState(() {
        _error = 'Invalid barcode detected';
      });
      return;
    }

    // Trim whitespace
    barcode = barcode.trim();
    print('Processing barcode: $barcode');

    // Check for duplicates
    if (_scannedBarcodes.contains(barcode)) {
      print('Duplicate barcode detected: $barcode');
      setState(() {
        _error = 'This barcode has already been scanned';
      });
      return;
    }

    // Add to list and update UI
    print('Adding barcode to list: $barcode');
    print('Current scanned count before add: ${_scannedBarcodes.length}');

    // Add to set for uniqueness check
    _scannedBarcodes.add(barcode);

    // Create a new list to ensure Flutter detects the change
    final newList = List<String>.from(_scannedBarcodes);

    print(
        'Before setState - List length: ${_scannedBarcodesList.length}, New list length: ${newList.length}');

    // Update list for UI (Flutter detects List changes better than Set)
    setState(() {
      _scannedBarcodesList = newList;
      _error = null;
    });

    print('After setState - List length: ${_scannedBarcodesList.length}');
    print('Barcode added. Total scanned: ${_scannedBarcodes.length}');
    print('Scanned barcodes list: $_scannedBarcodesList');
    print('setState called, UI should update now');

    // Force a rebuild by calling setState again after a tiny delay
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        setState(() {
          // Just trigger a rebuild
        });
        print('Forced rebuild triggered');
      }
    });

    // Optional: Add a brief pause to prevent multiple rapid scans
    setState(() => _isPaused = true);
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _isPaused = false);
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
            'Total scanned: ${_scannedBarcodesList.length}',
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
    if (_scannedBarcodesList.isEmpty) return const SizedBox.shrink();

    print(
        '_buildScannedList called with ${_scannedBarcodesList.length} barcodes');
    print('Barcodes: $_scannedBarcodesList');

    return Container(
      key: ValueKey('scanned_list_${_scannedBarcodesList.length}'),
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
                'Scanned Barcodes (${_scannedBarcodesList.length})',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              Row(
                children: [
                  if (_scannedBarcodesList.isNotEmpty)
                    ElevatedButton.icon(
                      onPressed: () {
                        if (selectedStatus == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a status first'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        context.read<BarcodeReaderBloc>().add(
                              BarcodeReaderChangeStatusEvent(
                                shipmentIds: _scannedBarcodesList,
                                status: selectedStatus!,
                              ),
                            );
                      },
                      icon: const Icon(Icons.update, size: 18),
                      label: const Text('Update'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isDarkMode ? Colors.blue[700] : Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.clear_all),
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    onPressed: () {
                      setState(() {
                        _scannedBarcodes.clear();
                        _scannedBarcodesList.clear();
                      });
                    },
                    tooltip: 'Clear all',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _scannedBarcodesList
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
                        setState(() {
                          _scannedBarcodes.remove(barcode);
                          _scannedBarcodesList =
                              List<String>.from(_scannedBarcodes);
                        });
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

    // If switching to scanning mode and it's Sunmi, ensure scanner is active
    if (_isScanning && _scannerType == ScannerType.sunmi) {
      _scannerService.startScanner();
    }
  }

  // Keep scanner active by periodically reactivating it
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
                // Clear all scanned barcodes from UI
                _scannedBarcodes.clear();
                _scannedBarcodesList.clear();
              });
              // Clear shipments from store
              context.read<TrackOrderBloc>().add(ClearShipments());
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
      child: KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: (event) {
          // Capture keyboard input from scanner (HID mode)
          if (event is KeyDownEvent && _scannerType == ScannerType.sunmi) {
            final keyLabel = event.logicalKey.keyLabel;
            print('🔍 Key pressed: $keyLabel (${event.logicalKey.keyId})');

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
              print('🔍 Scanner buffer: $_scannerBuffer');
            } else if (event.logicalKey == LogicalKeyboardKey.enter) {
              // Enter key indicates end of barcode
              if (_scannerBuffer.isNotEmpty) {
                print('🔍✅ Complete barcode from keyboard: $_scannerBuffer');
                _onBarcodeDetected(_scannerBuffer.trim());
                _scannerBuffer = '';
                _lastScannerInput = null;
              }
            }
          }
        },
        child: Scaffold(
          backgroundColor:
              isDarkMode ? const Color(0xFF5b3895) : const Color(0xFF5b3895),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color.fromARGB(255, 75, 23, 160),
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
              BarcodeReaderWidgets.buildStatusDropdown(
                isDarkMode: isDarkMode,
                selectedStatus: selectedStatus,
                statuses: statuses,
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value;
                  });
                },
              ),
              if (_error != null)
                BarcodeReaderWidgets.buildErrorMessage(_error!, isDarkMode),
              // Always show the scanned list if there are barcodes
              if (_scannedBarcodesList.isNotEmpty)
                _buildScannedList(isDarkMode),
              Expanded(
                child: _isScanning
                    ? _isHardwareScanner
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _scannerType == ScannerType.sunmi
                                      ? Icons.qr_code_scanner
                                      : Icons.scanner,
                                  size: 64,
                                  color: isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _scannerType == ScannerType.sunmi
                                      ? 'Sunmi Scanner Active'
                                      : 'Urovo Scanner Active',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black87,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Device: $_deviceName',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Press the scan button on your device',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : _hasCameraPermission
                            ? BarcodeReaderWidgets.buildScanner(
                                isDarkMode: isDarkMode,
                                onBarcodeDetected: _onBarcodeDetected,
                              )
                            : const Text('Camera permission is required.')
                    : BarcodeReaderWidgets.buildManualEntry(
                        isDarkMode: isDarkMode,
                        controller: _trackingController,
                        onSubmit: _onManualSubmit,
                      ),
              ),
            ],
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BarcodeReaderWidgets.buildToggleButton(
                isDarkMode: isDarkMode,
                isScanning: _isScanning,
                onToggle: _toggleScanMode,
              ),
              const SizedBox(width: 16),
              FloatingActionButton(
                backgroundColor: const Color(0xFFFF5A00),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TrackOrderScreen()),
                  );
                },
                child: const Icon(
                  Icons.radar_rounded,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      ),
    );
  }
}
