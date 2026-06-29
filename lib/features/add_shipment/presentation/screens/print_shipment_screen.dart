import 'dart:typed_data';
import 'package:courier_app/app/utils/responsive_helper.dart';
import 'package:courier_app/features/branches/bloc/branches_bloc.dart';
import 'package:courier_app/features/branches/model/branches_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import '../../bloc/add_shipment_bloc.dart' hide FetchBranches;
import 'package:courier_app/core/services/sunmi_invoice_printer.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';
import 'package:sunmi_printer_plus/enums.dart';

class PrintShipmentScreen extends StatefulWidget {
  final String trackingNumber;

  const PrintShipmentScreen({Key? key, required this.trackingNumber})
      : super(key: key);

  @override
  State<PrintShipmentScreen> createState() => _PrintShipmentScreenState();
}

class _PrintShipmentScreenState extends State<PrintShipmentScreen> {
  Map<String, dynamic>? shipmentData;
  bool _isSunmiDevice = false;
  List<BranchesModel> _branches = [];

  @override
  void initState() {
    super.initState();
    print(
        '[PrintShipmentScreen] initState called with trackingNumber: ${widget.trackingNumber}');
    _checkIfSunmiDevice();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<BranchesBloc>().add(FetchBranches());
      try {
        context.read<AddShipmentBloc>().add(
              FetchShipmentDetailsEvent(trackingNumber: widget.trackingNumber),
            );
        print('[PrintShipmentScreen] FetchShipmentDetailsEvent dispatched');
      } catch (e) {
        print('[PrintShipmentScreen] Error in initState: ${e.toString()}');
        print('[PrintShipmentScreen] Error stack trace: ${StackTrace.current}');
      }
    });
  }

  Future<void> _checkIfSunmiDevice() async {
    try {
      final isSunmi = await SunmiInvoicePrinter.isSunmiDevice();

      setState(() {
        _isSunmiDevice = isSunmi;
      });

      print('[PrintShipmentScreen] IsSunmi: $isSunmi');
    } catch (e) {
      print('[PrintShipmentScreen] Error checking device: ${e.toString()}');
      setState(() {
        _isSunmiDevice = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BranchesBloc, BranchesState>(
      listener: (context, state) {
        if (state is FetchBranchesLoaded) {
          setState(() => _branches = state.branches);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shipment Details'),
        ),
        body: BlocConsumer<AddShipmentBloc, AddShipmentState>(
        listener: (context, state) {
          print(
              '[PrintShipmentScreen] BlocConsumer listener - state: ${state.runtimeType}');
          if (state is ShipmentDetailsFetched) {
            print('[PrintShipmentScreen] ShipmentDetailsFetched received');
            try {
              setState(() {
                shipmentData = state.shipmentDetails.toMap();
                // Also store raw data for nested objects that might not be in toMap()
                // This allows access to serviceMode, branches, etc. from the original response
              });
              print('[PrintShipmentScreen] shipmentData set: $shipmentData');
            } catch (e) {
              print(
                  '[PrintShipmentScreen] Error setting shipmentData: ${e.toString()}');
              print(
                  '[PrintShipmentScreen] Error stack trace: ${StackTrace.current}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'Error displaying shipment details: ${e.toString()}')),
              );
            }
          } else if (state is ShipmentDetailsFetchError) {
            print(
                '[PrintShipmentScreen] ShipmentDetailsFetchError received: ${state.error}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          print(
              '[PrintShipmentScreen] BlocConsumer builder - state: ${state.runtimeType}');
          if (state is FetchShipmentDetailsLoading ||
              state is AddShipmentLoading) {
            print('[PrintShipmentScreen] Showing loading indicator');
            return const Center(child: CircularProgressIndicator());
          }

          if (shipmentData == null) {
            print(
                '[PrintShipmentScreen] shipmentData is null, showing message');
            return const Center(child: Text('No shipment details available'));
          }

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ResponsiveHelper.getMaxContentWidth(context),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: ResponsiveHelper.getResponsivePadding(
                        context,
                        mobile: const EdgeInsets.all(16),
                        tablet: const EdgeInsets.all(24),
                        desktop: const EdgeInsets.all(32),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSection('SENDER:', {
                            'Name': shipmentData!['senderName'] ?? '',
                            'Mobile': shipmentData!['senderMobile'] ?? '',
                          }),
                          const Divider(),
                          _buildSection('RECEIVER:', {
                            'Name': shipmentData!['receiverName'] ?? '',
                            'Mobile': shipmentData!['receiverMobile'] ?? '',
                          }),
                          const Divider(),
                          _buildSection('SHIPMENT DETAIL:', {
                            'Shipment Date':
                                _formatDate(shipmentData!['createdAt']),
                            'Payment Method':
                                _formatPaymentDisplayLabel(shipmentData!),
                            'Delivery Type':
                                shipmentData!['deliveryType'] ?? '',
                            'Description':
                                shipmentData!['shipmentDescription'] ?? '',
                            // 'Quantity': '${shipmentData!['quantity'] ?? 1}',
                            // 'Number of Pieces': '${shipmentData!['numPcs'] ?? 0}',
                            // 'Number of Boxes': '${shipmentData!['numBoxes'] ?? 0}',
                            // 'Unit': shipmentData!['unit'] ?? '',
                          }),
                          // const Divider(),
                          // _buildSection('PAYMENT DETAIL:', {
                          //   'Rate': 'ETB ${shipmentData!['rate'] ?? 0}',
                          //   'Extra Fee': 'ETB ${shipmentData!['extraFee'] ?? 0}',
                          //   'Extra Fee Description':
                          //       shipmentData!['extraFeeDescription'] ?? '',
                          //   'Hudhud Percent':
                          //       '${shipmentData!['hudhudPercent'] ?? 0}%',
                          //   'Hudhud Net': 'ETB ${shipmentData!['hudhudNet'] ?? 0}',
                          //   'Total Fee':
                          //       'ETB ${(shipmentData!['rate'] ?? 0) * (shipmentData!['quantity'] ?? 1) + (shipmentData!['extraFee'] ?? 0)}',
                          // }),
                          const SizedBox(height: 20),
                          Center(
                            child: QrImageView(
                              data: widget.trackingNumber,
                              version: QrVersions.auto,
                              size: 200.0,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Text(
                              widget.trackingNumber,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: ResponsiveHelper.getResponsivePadding(
                      context,
                      mobile: const EdgeInsets.all(16.0),
                      tablet: const EdgeInsets.all(24.0),
                      desktop: const EdgeInsets.all(32.0),
                    ),
                    child: Column(
                      children: [
                        if (_isSunmiDevice)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: ElevatedButton.icon(
                              onPressed: () => _printPdf(context),
                              icon: const Icon(Icons.print),
                              label: const Text('Print PDF'),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50),
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ElevatedButton(
                          onPressed: () => _generatePdf(context),
                          child: const Text('Download PDF'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                          ),
                        ),
                      ],
                    ),
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

  String? _branchCodeFromAwb(String awb) {
    final match = RegExp(r'^ET([A-Z]{2})').firstMatch(awb.toUpperCase());
    return match?.group(1);
  }

  String _resolveBranchName({
    String? name,
    int? branchId,
    required List<BranchesModel> branches,
    String? awb,
  }) {
    if (name != null && name.trim().isNotEmpty) {
      return name.trim().toUpperCase();
    }
    if (branchId != null) {
      for (final branch in branches) {
        if (branch.id == branchId) {
          return branch.name.toUpperCase();
        }
      }
    }
    final code = awb != null ? _branchCodeFromAwb(awb) : null;
    if (code != null) {
      for (final branch in branches) {
        if (branch.code.toUpperCase() == code) {
          return branch.name.toUpperCase();
        }
      }
    }
    return '';
  }

  List<BranchesModel> _branchesForPrint(BuildContext context) {
    if (_branches.isNotEmpty) return _branches;
    final state = context.read<BranchesBloc>().state;
    if (state is FetchBranchesLoaded) return state.branches;
    return const [];
  }

  String? _resolvePaymentField(dynamic value) {
    if (value == null) return null;
    if (value is Map) {
      final field = value['method'] ?? value['code'];
      if (field != null && field.toString().trim().isNotEmpty) {
        return field.toString().trim();
      }
      return null;
    }
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  String? _resolvePaymentModeField(dynamic value) {
    if (value == null) return null;
    if (value is Map) {
      final field = value['code'] ?? value['method'];
      if (field != null && field.toString().trim().isNotEmpty) {
        return field.toString().trim();
      }
      return null;
    }
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  bool _isCodPayment(String? value) {
    if (value == null || value.trim().isEmpty) return false;
    final normalized = value.trim().toUpperCase();
    return normalized == 'COD' || normalized == 'CASH ON DELIVERY';
  }

  String _formatPaymentDisplayLabel(Map<String, dynamic> data) {
    final paymentMode = _resolvePaymentModeField(data['paymentMode']);
    final paymentMethod = _resolvePaymentField(data['paymentMethod']);

    if (paymentMethod != null && paymentMethod.isNotEmpty) {
      if (paymentMode != null &&
          paymentMode.isNotEmpty &&
          paymentMode.toUpperCase() != paymentMethod.toUpperCase()) {
        return '$paymentMethod ($paymentMode)';
      }
      return paymentMethod;
    }

    return paymentMode ?? '';
  }

  String _formatPaymentBillLine(Map<String, dynamic> data) {
    final paymentMode =
        _resolvePaymentModeField(data['paymentMode'])?.toUpperCase();
    final paymentMethod =
        _resolvePaymentField(data['paymentMethod'])?.toUpperCase();
    final label = _formatPaymentDisplayLabel(data);

    if (label.isEmpty) return '';

    // Payment method is the actual tender used; prefer it over payment mode.
    if (_isCodPayment(paymentMethod) && paymentMethod != 'CASH') {
      return 'BILL CASH ON DELIVERY';
    }

    if (paymentMethod == 'CASH') {
      if (paymentMode != null &&
          paymentMode.isNotEmpty &&
          paymentMode != paymentMethod) {
        return 'BILL ${label.toUpperCase()}';
      }
      return 'BILL CASH';
    }

    if (paymentMethod != null && paymentMethod.isNotEmpty) {
      return 'PAY: $paymentMethod';
    }

    if (_isCodPayment(paymentMode)) {
      return 'BILL CASH ON DELIVERY';
    }

    if (paymentMode == 'CASH') {
      return 'BILL CASH';
    }

    if (paymentMode != null && paymentMode.isNotEmpty) {
      return 'PAY: $paymentMode';
    }

    return '';
  }

  String _formatDate(dynamic dateValue) {
    try {
      if (dateValue == null || dateValue.toString().isEmpty) {
        print('[PrintShipmentScreen] Date value is null or empty');
        return 'N/A';
      }
      print(
          '[PrintShipmentScreen] Formatting date: $dateValue (type: ${dateValue.runtimeType})');
      final dateString = dateValue.toString();
      final dateTime = DateTime.parse(dateString);
      return DateFormat('dd-MM-yyyy HH:mm:ss').format(dateTime);
    } catch (e) {
      print('[PrintShipmentScreen] Error formatting date: ${e.toString()}');
      print('[PrintShipmentScreen] Date value: $dateValue');
      return dateValue?.toString() ?? 'N/A';
    }
  }

  Widget _buildSection(String title, Map<String, String> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...data.entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${entry.key}: ',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      entry.value,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Future<void> _printPdf(BuildContext context) async {
    try {
      // If on Sunmi device, try to use Sunmi printer directly
      if (_isSunmiDevice) {
        final success = await _printWithSunmiPrinter(context);
        if (success) {
          return; // Successfully printed with Sunmi printer
        }
        // If Sunmi printer fails, fall back to standard printing
        print(
            '[PrintShipmentScreen] Sunmi printer failed, falling back to standard printing');
      }

      // Generate PDF first
      final pdf = await _generatePdfDocument();

      // Print directly to printer using standard printing package
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isSunmiDevice
              ? 'Printed successfully'
              : 'Printing to printer...'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('[PrintShipmentScreen] Error printing PDF: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error printing: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<bool> _printWithSunmiPrinter(BuildContext context) async {
    try {
      final bool? binded = await SunmiPrinter.bindingPrinter();
      if (binded != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to connect to printer.'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }

      await SunmiPrinter.initPrinter();
      await SunmiPrinter.startTransactionPrint(true);

      final branches = _branchesForPrint(context);
      final senderName =
          (shipmentData!['senderName'] ?? '').toString().toUpperCase();
      final senderBranch = (shipmentData!['senderBranch'] ?? '').toString();
      final senderBranchId = shipmentData!['senderBranchId'] as int?;

      final receiverName =
          (shipmentData!['receiverName'] ?? '').toString().toUpperCase();
      final receiverBranch = (shipmentData!['receiverBranch'] ?? '').toString();
      final receiverBranchId = shipmentData!['receiverBranchId'] as int?;

      final shipDate = _formatShipDate(shipmentData!['createdAt']);
      final weight =
          '${shipmentData!['qty'] ?? 1} ${(shipmentData!['unit'] ?? 'kg').toString().toUpperCase()}';
      final account = (shipmentData!['transactionReference'] ?? '').toString();
      final billText = _formatPaymentBillLine(shipmentData!);

      final refNumber =
          (shipmentData!['transactionReference'] ?? '').toString();
      final refShort = refNumber.length > 6
          ? refNumber.substring(refNumber.length - 6)
          : refNumber;

      final dateTime = _formatDateTime(shipmentData!['createdAt']);

      final resolvedOrigin = _resolveBranchName(
        name: senderBranch.isNotEmpty ? senderBranch : null,
        branchId: senderBranchId,
        branches: branches,
      );
      final originLocation =
          resolvedOrigin.isNotEmpty ? resolvedOrigin : 'ADDIS ABABA';

      final destination = _resolveBranchName(
        name: receiverBranch.isNotEmpty ? receiverBranch : null,
        branchId: receiverBranchId,
        branches: branches,
        awb: widget.trackingNumber,
      );

      String courierText = 'COURIER';
      if (shipmentData!.containsKey('serviceMode')) {
        final serviceMode = shipmentData!['serviceMode'];
        if (serviceMode is Map) {
          courierText =
              (serviceMode['description'] ?? serviceMode['code'] ?? 'COURIER')
                  .toString()
                  .toUpperCase();
        } else {
          courierText = serviceMode.toString().toUpperCase();
        }
      }

      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.printText(
        'HudHud Express',
        style: SunmiStyle(
          bold: true,
          fontSize: SunmiFontSize.MD,
        ),
      );
      await SunmiPrinter.lineWrap(1);
      await SunmiPrinter.printText(
        'TRK# ${widget.trackingNumber}',
        style: SunmiStyle(
          bold: true,
          fontSize: SunmiFontSize.LG,
        ),
      );
      await SunmiPrinter.lineWrap(1);
      await SunmiPrinter.line();
      await SunmiPrinter.lineWrap(1);

      await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT);
      await SunmiPrinter.printText(
        'ORIGIN: $originLocation',
        style: SunmiStyle(bold: true, fontSize: SunmiFontSize.SM),
      );
      await SunmiPrinter.lineWrap(1);

      if (senderName.isNotEmpty) {
        await SunmiPrinter.printText(
          senderName,
          style: SunmiStyle(bold: true, fontSize: SunmiFontSize.SM),
        );
        await SunmiPrinter.lineWrap(1);
      }

      await SunmiPrinter.printText(
        'SHIP DATE: $shipDate | WT: $weight',
        style: SunmiStyle(bold: true, fontSize: SunmiFontSize.SM),
      );
      await SunmiPrinter.lineWrap(1);

      final metaLine2 = [
        if (account.isNotEmpty) 'ACCT: $account',
        if (billText.isNotEmpty) billText,
      ].join(' | ');
      if (metaLine2.isNotEmpty) {
        await SunmiPrinter.printText(
          metaLine2,
          style: SunmiStyle(bold: true, fontSize: SunmiFontSize.SM),
        );
        await SunmiPrinter.lineWrap(1);
      }

      await SunmiPrinter.printText(
        'TO:',
        style: SunmiStyle(bold: true),
      );
      await SunmiPrinter.lineWrap(1);

      if (destination.isNotEmpty) {
        await SunmiPrinter.printText(
          'DESTINATION: $destination',
          style: SunmiStyle(bold: true, fontSize: SunmiFontSize.SM),
        );
        await SunmiPrinter.lineWrap(1);
      }

      if (receiverName.isNotEmpty) {
        await SunmiPrinter.printText(
          receiverName,
          style: SunmiStyle(bold: true, fontSize: SunmiFontSize.SM),
        );
        await SunmiPrinter.lineWrap(1);
      }

      await SunmiPrinter.printText(
        'REF: $refNumber',
        style: SunmiStyle(bold: true, fontSize: SunmiFontSize.SM),
      );
      await SunmiPrinter.lineWrap(1);

      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);

      final barcodeUrl = shipmentData!['barcodeUrl'] as String?;
      if (barcodeUrl != null && barcodeUrl.isNotEmpty) {
        try {
          final barcodeImageBytes = await _downloadImage(barcodeUrl);
          if (barcodeImageBytes != null) {
            final scaledBytes =
                _scaleBarcodeForPrint(barcodeImageBytes, targetWidth: 460);
            await SunmiPrinter.printImage(scaledBytes);
            await SunmiPrinter.lineWrap(1);
          }
        } catch (e) {
          print('[PrintShipmentScreen] Error printing barcode: $e');
        }
      }

      final qrCodeUrl =
          'https://hudhudexpress.com/order?awb=${widget.trackingNumber}';
      await SunmiPrinter.printQRCode(
        qrCodeUrl,
        size: 4,
        errorLevel: SunmiQrcodeLevel.LEVEL_H,
      );
      await SunmiPrinter.lineWrap(1);

      await SunmiPrinter.line();
      await SunmiPrinter.printText(
        '$courierText | REF# $refShort | $dateTime',
        style: SunmiStyle(fontSize: SunmiFontSize.SM),
      );
      await SunmiPrinter.lineWrap(1);

      await SunmiPrinter.exitTransactionPrint(true);
      await SunmiPrinter.cut();

      if (!context.mounted) return true;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Printed successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      return true;
    } catch (e) {
      print('[PrintShipmentScreen] Error printing with Sunmi printer: $e');
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }

  Future<pw.Document> _generatePdfDocument() async {
    final pdf = pw.Document();

    // Load logo and barcode images
    final logo = await imageFromAssetBundle('assets/images/courier.png');

    // Download barcode image from URL
    Uint8List? barcodeImageBytes;
    pw.ImageProvider? mainBarcodeImage;
    pw.ImageProvider? smallBarcodeImage;

    final barcodeUrl = shipmentData!['barcodeUrl'] as String?;
    if (barcodeUrl != null && barcodeUrl.isNotEmpty) {
      barcodeImageBytes = await _downloadImage(barcodeUrl);
      if (barcodeImageBytes != null) {
        mainBarcodeImage = pw.MemoryImage(barcodeImageBytes);
        smallBarcodeImage = pw.MemoryImage(barcodeImageBytes);
      }
    }

    // Parse AWB to get prefix and suffix
    final awbParts = _parseAwb(widget.trackingNumber);
    final awbPrefix = awbParts['prefix'] ?? '';
    final awbSuffix = awbParts['suffix'] ?? '';

    // Extract data
    final senderName =
        (shipmentData!['senderName'] ?? '').toString().toUpperCase();
    final senderMobile = (shipmentData!['senderMobile'] ?? '').toString();
    final senderBranch = (shipmentData!['senderBranch'] ?? '').toString();

    final receiverName =
        (shipmentData!['receiverName'] ?? '').toString().toUpperCase();
    final receiverMobile = (shipmentData!['receiverMobile'] ?? '').toString();
    final receiverBranch = (shipmentData!['receiverBranch'] ?? '').toString();

    final shipDate = _formatShipDate(shipmentData!['createdAt']);
    final weight =
        '${shipmentData!['qty'] ?? 1} ${(shipmentData!['unit'] ?? 'kg').toString().toUpperCase()}';
    final account = (shipmentData!['transactionReference'] ?? '').toString();
    final billText = _formatPaymentBillLine(shipmentData!);

    final refNumber = (shipmentData!['transactionReference'] ?? '').toString();
    final refShort = refNumber.length > 6
        ? refNumber.substring(refNumber.length - 6)
        : refNumber;

    final dateTime = _formatDateTime(shipmentData!['createdAt']);
    // Try to get serviceMode description, default to COURIER
    String courierText = 'COURIER';
    if (shipmentData!.containsKey('serviceMode')) {
      final serviceMode = shipmentData!['serviceMode'];
      if (serviceMode is Map) {
        courierText =
            (serviceMode['description'] ?? serviceMode['code'] ?? 'COURIER')
                .toString()
                .toUpperCase();
      } else {
        courierText = serviceMode.toString().toUpperCase();
      }
    }

    // Get origin location (from sender branch or use default)
    final originLocation =
        senderBranch.isNotEmpty ? senderBranch.toUpperCase() : 'ADDIS ABABA';

    // A4 page dimensions: 595x842 points (at 72 DPI)
    const pageWidth = 595.0;
    const margin = 15.0;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(0),
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              // Top Left - ORIGIN ID and sender info in compact row
              pw.Positioned(
                left: margin,
                top: margin,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Text(
                          'ORIGIN: ',
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          '$originLocation | ',
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          senderName,
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        if (senderMobile.isNotEmpty)
                          pw.Text(
                            ' | $senderMobile',
                            style: const pw.TextStyle(
                              fontSize: 9,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Top Right - SHIP DATE, WT, ACCT in one row with small barcode
              pw.Positioned(
                right: margin,
                top: margin,
                child: pw.Row(
                  mainAxisSize: pw.MainAxisSize.min,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Text(
                          'DATE: $shipDate | WT: $weight | ACCT: $account',
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        if (billText.isNotEmpty)
                          pw.Text(
                            billText,
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                    if (smallBarcodeImage != null) ...[
                      pw.SizedBox(width: 6),
                      pw.Container(
                        width: 30,
                        height: 45,
                        child: pw.Image(smallBarcodeImage),
                      ),
                    ],
                  ],
                ),
              ),

              // Logo - Centered, moved up
              pw.Positioned(
                left: (pageWidth - 120) / 2,
                top: 50,
                child: pw.Container(
                  height: 40,
                  width: 120,
                  child: pw.Image(logo),
                ),
              ),

              // TO Section - Left side, compact
              pw.Positioned(
                left: margin,
                top: 100,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Text(
                          'TO: ',
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          receiverName,
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        if (receiverMobile.isNotEmpty)
                          pw.Text(
                            ' | $receiverMobile',
                            style: const pw.TextStyle(
                              fontSize: 9,
                            ),
                          ),
                        if (receiverBranch.isNotEmpty)
                          pw.Text(
                            ' | BRANCH: $receiverBranch',
                            style: const pw.TextStyle(
                              fontSize: 9,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Reference Bar - Compact row
              pw.Positioned(
                left: margin,
                top: 125,
                child: pw.Row(
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    pw.Container(
                      width: 150,
                      height: 18,
                      decoration: pw.BoxDecoration(
                        color: PdfColors.black,
                        borderRadius: pw.BorderRadius.circular(3),
                      ),
                      child: pw.Center(
                        child: pw.Text(
                          'ksjf fk',
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 8,
                          ),
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 6),
                    pw.Text(
                      'REF: $refNumber',
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Main Barcode - Centered, moved up
              if (mainBarcodeImage != null)
                pw.Positioned(
                  left: (pageWidth - 250) / 2,
                  top: 155,
                  child: pw.Container(
                    width: 250,
                    height: 80,
                    child: pw.Image(mainBarcodeImage),
                  ),
                ),

              // Bottom Left - HudHud Express, E square, TRK# in compact row
              pw.Positioned(
                left: margin,
                bottom: 100,
                child: pw.Row(
                  mainAxisSize: pw.MainAxisSize.min,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      'HudHud Express',
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColor.fromHex('#8B5CF6'),
                        fontWeight: pw.FontWeight.normal,
                      ),
                    ),
                    pw.SizedBox(width: 6),
                    pw.Container(
                      width: 16,
                      height: 16,
                      decoration: pw.BoxDecoration(
                        color: PdfColors.white,
                        border:
                            pw.Border.all(color: PdfColors.black, width: 1.5),
                      ),
                      child: pw.Center(
                        child: pw.Text(
                          'E',
                          style: pw.TextStyle(
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 6),
                    pw.Text(
                      'TRK# ${widget.trackingNumber}',
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Right - REF# and date/time in one row
              pw.Positioned(
                right: margin,
                bottom: 100,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    pw.Text(
                      'REF# $refShort | $dateTime',
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // COURIER text - Centered, moved up
              pw.Positioned(
                left: (pageWidth - 100) / 2,
                bottom: 80,
                child: pw.Text(
                  courierText,
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),

              // Large ETAA prefix - Bottom left
              pw.Positioned(
                left: margin,
                bottom: margin,
                child: pw.Text(
                  awbPrefix,
                  style: pw.TextStyle(
                    fontSize: 48,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),

              // Large numeric suffix - Bottom right, aligned with ETAA
              pw.Positioned(
                right: margin,
                bottom: margin,
                child: pw.Text(
                  awbSuffix,
                  style: pw.TextStyle(
                    fontSize: 48,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  Future<void> _generatePdf(BuildContext context) async {
    try {
      final pdf = await _generatePdfDocument();

      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'shipment_${widget.trackingNumber}.pdf',
      );
    } catch (e) {
      print('[PrintShipmentScreen] Error generating PDF: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating PDF: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Parse AWB to extract prefix (ETAA, ETJJ, ETJM, etc.) and numeric suffix
  Map<String, String> _parseAwb(String awb) {
    final prefixMatch = RegExp(r'^([A-Z]+)').firstMatch(awb);
    final numberMatch = RegExp(r'(\d+)$').firstMatch(awb);
    return {
      'prefix': prefixMatch?.group(1) ?? '',
      'suffix': numberMatch?.group(1) ?? '',
    };
  }

  // Format date as "DD MMM YY" (e.g., "10 NOV 25")
  String _formatShipDate(dynamic dateValue) {
    try {
      if (dateValue == null || dateValue.toString().isEmpty) {
        return 'N/A';
      }
      final dateString = dateValue.toString();
      final dateTime = DateTime.parse(dateString);
      return DateFormat('dd MMM yy').format(dateTime).toUpperCase();
    } catch (e) {
      print(
          '[PrintShipmentScreen] Error formatting ship date: ${e.toString()}');
      return 'N/A';
    }
  }

  // Format date/time as "DD MMM YY HH:MM AM/PM" (e.g., "10 NOV 25 11:05 AM")
  String _formatDateTime(dynamic dateValue) {
    try {
      if (dateValue == null || dateValue.toString().isEmpty) {
        return 'N/A';
      }
      final dateString = dateValue.toString();
      final dateTime = DateTime.parse(dateString);
      final datePart = DateFormat('dd MMM yy').format(dateTime).toUpperCase();
      final timePart = DateFormat('hh:mm a').format(dateTime).toUpperCase();
      return '$datePart $timePart';
    } catch (e) {
      print(
          '[PrintShipmentScreen] Error formatting date/time: ${e.toString()}');
      return 'N/A';
    }
  }

  Uint8List _scaleBarcodeForPrint(Uint8List bytes, {int targetWidth = 384}) {
    final decoded = img.decodeImage(bytes);
    if (decoded == null) return bytes;
    final resized = img.copyResize(decoded, width: targetWidth);
    return Uint8List.fromList(img.encodePng(resized));
  }

  // Download image from URL
  Future<Uint8List?> _downloadImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
      return null;
    } catch (e) {
      print('[PrintShipmentScreen] Error downloading image: ${e.toString()}');
      return null;
    }
  }
}
