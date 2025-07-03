// import 'package:courier_app/features/home_screen/presentation/screen/home_screen.dart';
import 'package:courier_app/features/add_shipment/bloc/add_shipment_bloc.dart';
import 'package:courier_app/features/add_shipment/presentation/screens/print_shipment_screen.dart';
// import 'package:courier_app/features/add_shipment/bloc/add_shipment_event.dart';
// import 'package:courier_app/features/add_shipment/data/repository/add_shipment_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/theme/theme_provider.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> formData;
  final String trackingNumber;
  final String paymentInfo;
  const PaymentScreen(
      {super.key,
      required this.formData,
      required this.trackingNumber,
      required this.paymentInfo});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Widget _buildInfoRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: highlight ? Colors.deepPurple : Colors.grey[700],
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.deepOrange,
              fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Icon(Icons.arrow_right, color: Colors.deepPurple[700]),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple[700],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Calculate total amount
    final rate = (widget.formData['rate'] as num?)?.toDouble() ?? 0.0;
    final quantity = (widget.formData['quantity'] as num?)?.toDouble() ?? 1.0;
    final totalAmount = (rate * quantity);

    return BlocListener<AddShipmentBloc, AddShipmentState>(
      listener: (context, state) {
        if (state is CheckPaymentStatusSuccess) {
          print(state.message);
          Future.microtask(() {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PrintShipmentScreen(trackingNumber: widget.trackingNumber),
              ),
            );
          });
        }
      },
      child: BlocBuilder<AddShipmentBloc, AddShipmentState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor:
                isDarkMode ? const Color(0xFF0A1931) : Colors.grey[50],
            appBar: AppBar(
              title: const Text(
                'Payment Summary',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.deepPurple,
              elevation: 0,
              actions: [
                Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<AddShipmentBloc>().add(
                                InitiatePaymentEvent(
                                  awb: widget.trackingNumber,
                                  paymentMethod: widget.paymentInfo,
                                  addedBy: 1,
                                ),
                              );
                        },
                        icon:
                            const Icon(Icons.payment, color: Colors.deepPurple),
                        label: state is InitiatePaymentLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Pay Now',
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<AddShipmentBloc>().add(
                                CheckPaymentStatusEvent(
                                  awb: widget.trackingNumber,
                                ),
                              );
                        },
                        icon:
                            const Icon(Icons.refresh, color: Colors.deepPurple),
                        label: state is CheckPaymentStatusLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Check Status',
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            body: BlocListener<AddShipmentBloc, AddShipmentState>(
              listener: (context, state) {
                if (state is InitiatePaymentSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                } else if (state is InitiatePaymentFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage),
                    ),
                  );
                }
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Purple Header Extension
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(bottom: 30.0),
                      decoration: const BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Tracking Number',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.trackingNumber,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // QR Code Card
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  QrImageView(
                                    data: widget.trackingNumber,
                                    version: QrVersions.auto,
                                    size: 200.0,
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.deepPurple,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Scan to track shipment',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Shipment Details Card
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionTitle('Sender Information'),
                                  _buildInfoRow('Name',
                                      widget.formData['senderName'] ?? 'N/A'),
                                  _buildInfoRow('Mobile',
                                      widget.formData['senderMobile'] ?? 'N/A'),
                                  _buildSectionTitle('Receiver Information'),
                                  _buildInfoRow('Name',
                                      widget.formData['receiverName'] ?? 'N/A'),
                                  _buildInfoRow(
                                      'Mobile',
                                      widget.formData['receiverMobile'] ??
                                          'N/A'),
                                  _buildSectionTitle('Shipment Details'),
                                  _buildInfoRow(
                                      'Description',
                                      widget.formData['shipmentDescription'] ??
                                          'N/A'),
                                  _buildInfoRow(
                                      'Quantity',
                                      widget.formData['quantity']?.toString() ??
                                          '1'),
                                  _buildInfoRow(
                                      'Number of Pieces',
                                      widget.formData['numPcs']?.toString() ??
                                          '0'),
                                  _buildInfoRow(
                                      'Number of Boxes',
                                      widget.formData['numBoxes']?.toString() ??
                                          '0'),
                                  _buildSectionTitle('Payment Information'),
                                  _buildInfoRow('Rate',
                                      '${widget.formData['rate']?.toString() ?? '0.00'} ETB'),
                                  const Divider(color: Colors.deepPurple),
                                  _buildInfoRow(
                                      'Total Amount', '$totalAmount ETB',
                                      highlight: true),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
