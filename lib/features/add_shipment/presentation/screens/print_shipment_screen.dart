import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../bloc/add_shipment_bloc.dart';

class PrintShipmentScreen extends StatefulWidget {
  final String trackingNumber;

  const PrintShipmentScreen({Key? key, required this.trackingNumber})
      : super(key: key);

  @override
  State<PrintShipmentScreen> createState() => _PrintShipmentScreenState();
}

class _PrintShipmentScreenState extends State<PrintShipmentScreen> {
  Map<String, dynamic>? shipmentData;

  @override
  void initState() {
    super.initState();
    print(
        '[PrintShipmentScreen] initState called with trackingNumber: ${widget.trackingNumber}');
    try {
      context.read<AddShipmentBloc>().add(
            FetchShipmentDetailsEvent(trackingNumber: widget.trackingNumber),
          );
      print('[PrintShipmentScreen] FetchShipmentDetailsEvent dispatched');
    } catch (e) {
      print('[PrintShipmentScreen] Error in initState: ${e.toString()}');
      print('[PrintShipmentScreen] Error stack trace: ${StackTrace.current}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
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
                        'Payment Method': shipmentData!['paymentMethod'] ?? '',
                        'Delivery Type': shipmentData!['deliveryType'] ?? '',
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
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () => _generatePdf(context),
                  child: const Text('Download PDF'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
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
                children: [
                  Text(
                    '${entry.key}: ',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(entry.value),
                ],
              ),
            )),
      ],
    );
  }

  Future<void> _generatePdf(BuildContext context) async {
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
    final paymentMode = (shipmentData!['paymentMode'] ?? '').toString();
    final billText = paymentMode == 'CASH' ? 'BILL CASH ON DELIVERY' : '';

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
    const margin = 20.0;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(0),
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              // Top Left - ORIGIN ID, sender name, and mobile
              pw.Positioned(
                left: margin,
                top: margin,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'ORIGIN ID: $originLocation',
                      style: pw.TextStyle(
                        fontSize: 11,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      senderName,
                      style: pw.TextStyle(
                        fontSize: 11,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    if (senderMobile.isNotEmpty) ...[
                      pw.SizedBox(height: 2),
                      pw.Text(
                        senderMobile,
                        style: const pw.TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Top Right - SHIP DATE, WT, ACCT with small barcode on same row
              pw.Positioned(
                right: margin,
                top: margin,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    // Row with text and barcode
                    pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text(
                              'SHIP DATE: $shipDate',
                              style: pw.TextStyle(
                                fontSize: 9,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.SizedBox(height: 2),
                            pw.Text(
                              'WT: $weight',
                              style: pw.TextStyle(
                                fontSize: 9,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.SizedBox(height: 2),
                            pw.Text(
                              'ACCT: $account',
                              style: pw.TextStyle(
                                fontSize: 9,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            if (billText.isNotEmpty) ...[
                              pw.SizedBox(height: 4),
                              pw.Text(
                                billText,
                                style: pw.TextStyle(
                                  fontSize: 9,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (smallBarcodeImage != null) ...[
                          pw.SizedBox(width: 8),
                          pw.Container(
                            width: 35,
                            height: 55,
                            child: pw.Image(smallBarcodeImage),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Logo - Centered, slightly above middle of top half
              pw.Positioned(
                left: (pageWidth - 150) / 2,
                top: 180,
                child: pw.Container(
                  height: 50,
                  width: 150,
                  child: pw.Image(logo),
                ),
              ),

              // TO Section - Left side, below logo
              pw.Positioned(
                left: margin,
                top: 250,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'TO:',
                      style: pw.TextStyle(
                        fontSize: 11,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      receiverName,
                      style: pw.TextStyle(
                        fontSize: 11,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    if (receiverMobile.isNotEmpty) ...[
                      pw.SizedBox(height: 2),
                      pw.Text(
                        receiverMobile,
                        style: const pw.TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ],
                    if (receiverBranch.isNotEmpty) ...[
                      pw.SizedBox(height: 2),
                      pw.Text(
                        'BRANCH $receiverBranch',
                        style: const pw.TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Reference Bar - Middle left
              pw.Positioned(
                left: margin,
                top: 320,
                child: pw.Row(
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    pw.Container(
                      width: 180,
                      height: 22,
                      decoration: pw.BoxDecoration(
                        color: PdfColors.black,
                        borderRadius: pw.BorderRadius.circular(3),
                      ),
                      child: pw.Center(
                        child: pw.Text(
                          'ksjf fk',
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 8),
                    pw.Text(
                      'REF: $refNumber',
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Main Barcode - Centered horizontally
              if (mainBarcodeImage != null)
                pw.Positioned(
                  left: (pageWidth - 280) / 2,
                  top: 370,
                  child: pw.Container(
                    width: 280,
                    height: 90,
                    child: pw.Image(mainBarcodeImage),
                  ),
                ),

              // Bottom Left - HudHud Express, E square, TRK#
              pw.Positioned(
                left: margin,
                bottom: 120,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'HudHud Express',
                      style: pw.TextStyle(
                        fontSize: 11,
                        color: PdfColor.fromHex('#8B5CF6'),
                        fontWeight: pw.FontWeight.normal,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Container(
                      width: 18,
                      height: 18,
                      decoration: pw.BoxDecoration(
                        color: PdfColors.white,
                        border: pw.Border.all(color: PdfColors.black, width: 2),
                      ),
                      child: pw.Center(
                        child: pw.Text(
                          'E',
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 4),
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

              // Bottom Right - REF# and date/time
              pw.Positioned(
                right: margin,
                bottom: 120,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'REF# $refShort',
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      dateTime,
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // COURIER text - Centered
              pw.Positioned(
                left: (pageWidth - 100) / 2,
                bottom: 100,
                child: pw.Text(
                  courierText,
                  style: pw.TextStyle(
                    fontSize: 11,
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
                    fontSize: 52,
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
                    fontSize: 52,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'shipment_${widget.trackingNumber}.pdf',
    );
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
