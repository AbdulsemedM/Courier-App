import 'dart:async';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:urovo_scanner/urovo_scanner.dart';

enum ScannerType {
  sunmi,
  urovo,
  camera,
}

class ScannerService {
  static final ScannerService _instance = ScannerService._internal();
  factory ScannerService() => _instance;
  ScannerService._internal();

  ScannerType? _scannerType;
  String? _deviceName;
  StreamSubscription<String>? _sunmiSubscription;
  StreamSubscription<String?>? _urovoSubscription;
  static const MethodChannel _sunmiChannel =
      MethodChannel('com.hudhud.courier/sunmi_scanner');
  StreamController<String>? _sunmiStreamController;

  ScannerType? get scannerType => _scannerType;
  String? get deviceName => _deviceName;

  /// Detect device type and determine which scanner to use
  Future<ScannerType> detectScannerType() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final model = androidInfo.model.toUpperCase();
      final manufacturer = androidInfo.manufacturer.toUpperCase();

      _deviceName = '${androidInfo.manufacturer} ${androidInfo.model}';
      print('Device detected: $_deviceName');

      // Check for Sunmi V3 Mix
      if (manufacturer.contains('SUNMI') ||
          model.contains('V3 MIX') ||
          model.contains('V3MIX') ||
          model.contains('SUNMI') ||
          model.contains('V3')) {
        // Check if Sunmi scanner is available via platform channel
        try {
          final isAvailable =
              await _sunmiChannel.invokeMethod<bool>('isScannerAvailable') ??
                  false;
          print('Sunmi device check - isAvailable: $isAvailable');
          if (isAvailable) {
            _scannerType = ScannerType.sunmi;
            print('✅ Sunmi scanner detected and available');
            return ScannerType.sunmi;
          } else {
            // Still use Sunmi scanner even if check fails (scanner might work anyway)
            _scannerType = ScannerType.sunmi;
            print('⚠️ Sunmi device detected, assuming scanner is available');
            return ScannerType.sunmi;
          }
        } catch (e) {
          print('❌ Error checking Sunmi scanner: $e');
          // Still return sunmi if device is Sunmi (scanner might work anyway)
          _scannerType = ScannerType.sunmi;
          print('Assuming Sunmi scanner is available despite error');
          return ScannerType.sunmi;
        }
      }

      // Check for Urovo device
      try {
        final isUrovo = await UrovoScanner.isUrovoDevice ?? false;
        if (isUrovo) {
          _scannerType = ScannerType.urovo;
          _deviceName = await UrovoScanner.deviceName ?? _deviceName;
          print('Urovo scanner detected');
          return ScannerType.urovo;
        }
      } catch (e) {
        print('Error checking Urovo scanner: $e');
      }

      // Default to camera
      _scannerType = ScannerType.camera;
      print('Using camera scanner');
      return ScannerType.camera;
    } catch (e) {
      print('Error detecting scanner type: $e');
      _scannerType = ScannerType.camera;
      return ScannerType.camera;
    }
  }

  /// Initialize the appropriate scanner and return a stream of barcodes
  Stream<String> initializeScanner() {
    switch (_scannerType) {
      case ScannerType.sunmi:
        return _initializeSunmiScanner();
      case ScannerType.urovo:
        return _initializeUrovoScanner();
      case ScannerType.camera:
      case null:
        // Camera scanner is handled by MobileScanner widget
        return const Stream.empty();
    }
  }

  /// Initialize Sunmi scanner
  Stream<String> _initializeSunmiScanner() {
    // Create stream controller if it doesn't exist or is closed
    if (_sunmiStreamController == null || _sunmiStreamController!.isClosed) {
      _sunmiStreamController = StreamController<String>.broadcast();
      print('ScannerService: Created new stream controller');
    } else {
      print('ScannerService: Using existing stream controller');
    }

    // Set up method channel handler for receiving barcode scans
    _sunmiChannel.setMethodCallHandler((call) async {
      print('ScannerService: 📨 Received method call: ${call.method}');
      if (call.method == 'onBarcodeScanned') {
        final barcode = call.arguments as String?;
        print('ScannerService: 📦 Barcode received from native: "$barcode"');
        print(
            'ScannerService: Stream controller exists: ${_sunmiStreamController != null}');
        print(
            'ScannerService: Stream controller is closed: ${_sunmiStreamController?.isClosed ?? true}');

        if (barcode != null && barcode.isNotEmpty) {
          if (_sunmiStreamController != null &&
              !_sunmiStreamController!.isClosed) {
            print('ScannerService: ✅ Adding barcode to stream: "$barcode"');
            try {
              _sunmiStreamController!.add(barcode);
              print('ScannerService: ✅ Barcode added to stream successfully');
            } catch (e) {
              print('ScannerService: ❌ Error adding to stream: $e');
            }
          } else {
            print(
                'ScannerService: ❌ Stream controller is null or closed, recreating...');
            _sunmiStreamController = StreamController<String>.broadcast();
            _sunmiStreamController!.add(barcode);
            print('ScannerService: ✅ Barcode added to new stream');
          }
        } else {
          print('ScannerService: ⚠️ Barcode is null or empty');
        }
      } else {
        print('ScannerService: ❓ Unknown method call: ${call.method}');
      }
    });

    print(
        'ScannerService: Returning stream, has listeners: ${_sunmiStreamController?.hasListener ?? false}');
    return _sunmiStreamController!.stream;
  }

  /// Initialize Urovo scanner
  Stream<String> _initializeUrovoScanner() {
    final controller = StreamController<String>();

    try {
      _urovoSubscription = UrovoScanner.barcodeStream.listen(
        (barcode) {
          if (barcode != null && barcode.isNotEmpty) {
            controller.add(barcode);
          }
        },
        onError: (error) {
          print('Urovo scanner error: $error');
          controller.addError(error);
        },
      );
    } catch (e) {
      print('Error initializing Urovo scanner: $e');
      controller.addError(e);
    }

    return controller.stream;
  }

  /// Start the scanner (for Sunmi devices)
  Future<void> startScanner() async {
    if (_scannerType == ScannerType.sunmi) {
      try {
        print('Attempting to start Sunmi scanner...');
        final result = await _sunmiChannel.invokeMethod('startScan');
        print('Sunmi scanner startScan result: $result');

        // Give it a moment and try again (some devices need multiple attempts)
        await Future.delayed(const Duration(milliseconds: 300));
        await _sunmiChannel.invokeMethod('startScan');
        print('Sunmi scanner started (second attempt)');

        // One more attempt after a delay (some devices need time to initialize)
        await Future.delayed(const Duration(milliseconds: 500));
        await _sunmiChannel.invokeMethod('startScan');
        print('Sunmi scanner started (third attempt)');

        // Keep scanner open - don't let it close after scanning
        await Future.delayed(const Duration(milliseconds: 200));
        await _sunmiChannel.invokeMethod('startScan');
        print('Sunmi scanner kept open for continuous scanning');
      } catch (e) {
        print('Error starting Sunmi scanner: $e');
        // Don't throw - scanner might still work
      }
    }
  }

  /// Stop the scanner (for Sunmi devices)
  Future<void> stopScanner() async {
    if (_scannerType == ScannerType.sunmi) {
      try {
        await _sunmiChannel.invokeMethod('stopScan');
        print('Sunmi scanner stopped');
      } catch (e) {
        print('Error stopping Sunmi scanner: $e');
      }
    }
  }

  /// Dispose resources
  void dispose() {
    _sunmiSubscription?.cancel();
    _urovoSubscription?.cancel();
    _sunmiStreamController?.close();
    _sunmiSubscription = null;
    _urovoSubscription = null;
    _sunmiStreamController = null;
  }
}
