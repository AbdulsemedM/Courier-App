import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    final logo = await imageFromAssetBundle('assets/images/courier.png');
    final qrImage = await QrPainter(
      data: widget.trackingNumber,
      version: QrVersions.auto,
      gapless: false,
    ).toImageData(200);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(40),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header with logo
                pw.Align(
                  alignment: pw.Alignment.topRight,
                  child: pw.Container(
                    height: 60,
                    width: 120,
                    child: pw.Image(logo),
                  ),
                ),
                pw.SizedBox(height: 20),

                // Sender and Receiver section in a row
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Sender section
                    pw.Expanded(
                      child: pw.Container(
                        padding: const pw.EdgeInsets.all(10),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.grey300),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'SENDER:',
                              style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.SizedBox(height: 8),
                            _buildPdfInfoLine(
                                'Name:', shipmentData!['senderName'] ?? ''),
                            _buildPdfInfoLine('Sender Mobile:',
                                shipmentData!['senderMobile'] ?? ''),
                          ],
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 20),
                    // Receiver section
                    pw.Expanded(
                      child: pw.Container(
                        padding: const pw.EdgeInsets.all(10),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.grey300),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'RECEIVER:',
                              style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.SizedBox(height: 8),
                            _buildPdfInfoLine(
                                'Name:', shipmentData!['receiverName'] ?? ''),
                            _buildPdfInfoLine('Receiver Mobile:',
                                shipmentData!['receiverMobile'] ?? ''),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),

                // Shipment Details section
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'SHIPMENT DETAIL:',
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      _buildPdfInfoLine('Shipment Date:',
                          _formatPdfDate(shipmentData!['createdAt'])),
                      _buildPdfInfoLine('Payment Method:',
                          shipmentData!['paymentMethod'] ?? ''),
                      _buildPdfInfoLine('Delivery Type:',
                          shipmentData!['deliveryType'] ?? ''),
                      _buildPdfInfoLine('Description:',
                          shipmentData!['shipmentDescription'] ?? ''),
                      // _buildPdfInfoLine(
                      //     'Quantity:', '${shipmentData!['quantity'] ?? 1}'),
                      // _buildPdfInfoLine('Number of Pieces:',
                      //     '${shipmentData!['numPcs'] ?? 0}'),
                      // _buildPdfInfoLine('Number of Boxes:',
                      //     '${shipmentData!['numBoxes'] ?? 0}'),
                      // _buildPdfInfoLine('Unit:', shipmentData!['unit'] ?? ''),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),

                // Payment Details section
                // pw.Container(
                //   padding: const pw.EdgeInsets.all(10),
                //   decoration: pw.BoxDecoration(
                //     border: pw.Border.all(color: PdfColors.grey300),
                //   ),
                //   child: pw.Column(
                //     crossAxisAlignment: pw.CrossAxisAlignment.start,
                //     children: [
                //       pw.Text(
                //         'PAYMENT DETAIL:',
                //         style: pw.TextStyle(
                //           fontSize: 14,
                //           fontWeight: pw.FontWeight.bold,
                //         ),
                //       ),
                //       pw.SizedBox(height: 8),
                //       _buildPdfInfoLine(
                //           'Rate:', 'ETB ${shipmentData!['rate'] ?? 0}'),
                //       _buildPdfInfoLine('Extra Fee:',
                //           'ETB ${shipmentData!['extraFee'] ?? 0}'),
                //       _buildPdfInfoLine('Extra Fee Description:',
                //           shipmentData!['extraFeeDescription'] ?? ''),
                //       _buildPdfInfoLine('Hudhud Percent:',
                //           '${shipmentData!['hudhudPercent'] ?? 0}%'),
                //       _buildPdfInfoLine('Hudhud Net:',
                //           'ETB ${shipmentData!['hudhudNet'] ?? 0}'),
                //       _buildPdfInfoLine('Total Fee:',
                //           'ETB ${(shipmentData!['rate'] ?? 0) * (shipmentData!['quantity'] ?? 1) + (shipmentData!['extraFee'] ?? 0)}',
                //           isTotal: true),
                //     ],
                //   ),
                // ),
                // pw.SizedBox(height: 30),

                // QR Code section
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Image(
                        pw.MemoryImage(qrImage!.buffer.asUint8List()),
                        width: 150,
                        height: 150,
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        'Scan the QR Code',
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.grey600,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        widget.trackingNumber,
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'shipment_${widget.trackingNumber}.pdf',
    );
  }

  String _formatPdfDate(dynamic dateValue) {
    try {
      if (dateValue == null || dateValue.toString().isEmpty) {
        return 'N/A';
      }
      final dateString = dateValue.toString();
      final dateTime = DateTime.parse(dateString);
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } catch (e) {
      print('[PrintShipmentScreen] Error formatting PDF date: ${e.toString()}');
      return dateValue?.toString() ?? 'N/A';
    }
  }

  pw.Widget _buildPdfInfoLine(String label, String value,
      {bool isTotal = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '$label ',
            style: pw.TextStyle(
              color: PdfColors.grey700,
              fontSize: 12,
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: const pw.TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
