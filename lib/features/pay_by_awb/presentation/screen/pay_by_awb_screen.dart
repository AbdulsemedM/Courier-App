import 'package:courier_app/configuration/auth_service.dart';
import 'package:courier_app/features/add_shipment/bloc/add_shipment_bloc.dart';
import 'package:courier_app/features/add_shipment/presentation/screens/print_shipment_screen.dart';
import 'package:courier_app/features/add_shipment/model/payment_invoice_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_provider.dart';

class PayByAwbScreen extends StatefulWidget {
  const PayByAwbScreen({super.key});

  @override
  State<PayByAwbScreen> createState() => _PayByAwbScreenState();
}

class _PayByAwbScreenState extends State<PayByAwbScreen> {
  final TextEditingController _awbController = TextEditingController();
  bool _hasSearched = false;
  PaymentInvoiceModel? _lastFetchedDetails;

  @override
  void dispose() {
    _awbController.dispose();
    super.dispose();
  }

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
    final authService = AuthService();
    return MultiBlocListener(
      listeners: [
        BlocListener<AddShipmentBloc, AddShipmentState>(
          listenWhen: (previous, current) =>
              current is CheckPaymentStatusSuccess ||
              current is InitiatePaymentSuccess ||
              current is InitiatePaymentFailure,
          listener: (context, state) {
            if (state is CheckPaymentStatusSuccess) {
              Future.microtask(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrintShipmentScreen(
                        trackingNumber: _awbController.text),
                  ),
                );
              });
            } else if (state is InitiatePaymentSuccess ||
                state is InitiatePaymentFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state is InitiatePaymentSuccess
                      ? state.message
                      : (state as InitiatePaymentFailure).errorMessage),
                ),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<AddShipmentBloc, AddShipmentState>(
        buildWhen: (previous, current) =>
            current is ShipmentDetailsFetched ||
            current is FetchShipmentDetailsLoading ||
            current is ShipmentDetailsFetchError ||
            current is InitiatePaymentLoading ||
            current is CheckPaymentStatusLoading,
        builder: (context, state) {
          // Store shipment details when we receive them
          if (state is ShipmentDetailsFetched) {
            _lastFetchedDetails = state.shipmentDetails;
          }

          return Scaffold(
            backgroundColor:
                isDarkMode ? const Color(0xFF0A1931) : Colors.grey[50],
            appBar: AppBar(
              title: const Text(
                'Payment Details',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.deepPurple,
              elevation: 0,
              actions: _lastFetchedDetails != null
                  ? [
                      Container(
                        margin: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                context.read<AddShipmentBloc>().add(
                                      InitiatePaymentEvent(
                                        awb: _awbController.text,
                                        paymentMethod:
                                            _lastFetchedDetails!.paymentMethod!,
                                        payerAccount: _lastFetchedDetails!.senderMobile!
                                            , // Default payer account
                                        addedBy: int.parse(
                                            await authService.getUserId() ??
                                                '0'),
                                      ),
                                    );
                              },
                              icon: const Icon(Icons.payment,
                                  color: Colors.deepPurple),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
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
                                        awb: _awbController.text,
                                      ),
                                    );
                              },
                              icon: const Icon(Icons.refresh,
                                  color: Colors.deepPurple),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]
                  : null,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // Search Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
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
                          'Enter Tracking Number',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _awbController,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter AWB number',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 14),
                                  ),
                                  onSubmitted: (value) {
                                    if (value.isNotEmpty) {
                                      setState(() => _hasSearched = true);
                                      context.read<AddShipmentBloc>().add(
                                            FetchShipmentDetailsEvent(
                                                trackingNumber: value),
                                          );
                                    }
                                  },
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.search,
                                    color: Colors.deepPurple),
                                onPressed: () {
                                  if (_awbController.text.isNotEmpty) {
                                    setState(() => _hasSearched = true);
                                    context.read<AddShipmentBloc>().add(
                                          FetchShipmentDetailsEvent(
                                              trackingNumber:
                                                  _awbController.text),
                                        );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Results Section
                  if (_hasSearched)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: state is FetchShipmentDetailsLoading
                          ? const Center(child: CircularProgressIndicator())
                          : state is ShipmentDetailsFetchError
                              ? Center(
                                  child: Text(
                                    state.error,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                )
                              : _lastFetchedDetails != null
                                  ? Card(
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _buildSectionTitle(
                                                'Sender Information'),
                                            _buildInfoRow(
                                                'Name',
                                                _lastFetchedDetails!
                                                        .senderName ??
                                                    'N/A'),
                                            _buildInfoRow(
                                                'Mobile',
                                                _lastFetchedDetails!
                                                        .senderMobile ??
                                                    'N/A'),
                                            _buildInfoRow(
                                                'Branch',
                                                _lastFetchedDetails!
                                                        .senderBranch ??
                                                    'N/A'),
                                            _buildInfoRow(
                                                'Branch Phone',
                                                _lastFetchedDetails!
                                                        .senderBranchPhone ??
                                                    'N/A'),
                                            _buildSectionTitle(
                                                'Receiver Information'),
                                            _buildInfoRow(
                                                'Name',
                                                _lastFetchedDetails!
                                                        .receiverName ??
                                                    'N/A'),
                                            _buildInfoRow(
                                                'Mobile',
                                                _lastFetchedDetails!
                                                        .receiverMobile ??
                                                    'N/A'),
                                            _buildInfoRow(
                                                'Branch',
                                                _lastFetchedDetails!
                                                        .receiverBranch ??
                                                    'N/A'),
                                            _buildInfoRow(
                                                'Branch Phone',
                                                _lastFetchedDetails!
                                                        .receiverBranchPhone ??
                                                    'N/A'),
                                            _buildSectionTitle(
                                                'Shipment Details'),
                                            _buildInfoRow(
                                                'Description',
                                                _lastFetchedDetails!
                                                        .shipmentDescription ??
                                                    'N/A'),
                                            _buildInfoRow(
                                                'Delivery Type',
                                                _lastFetchedDetails!
                                                        .deliveryType ??
                                                    'N/A'),
                                            _buildSectionTitle(
                                                'Payment Information'),
                                            _buildInfoRow(
                                                'Payment Method',
                                                _lastFetchedDetails!
                                                        .paymentMethod ??
                                                    'N/A'),
                                            _buildInfoRow(
                                                'Payment Mode',
                                                _lastFetchedDetails!
                                                        .paymentMode ??
                                                    'N/A'),
                                            _buildInfoRow(
                                                'Payment Status',
                                                _lastFetchedDetails!
                                                        .paymentStatus ??
                                                    'N/A',
                                                highlight: true),
                                            if (_lastFetchedDetails!
                                                    .paymentReference !=
                                                null)
                                              _buildInfoRow(
                                                  'Payment Reference',
                                                  _lastFetchedDetails!
                                                      .paymentReference!,
                                                  highlight: true),
                                          ],
                                        ),
                                      ),
                                    )
                                  : const Center(
                                      child:
                                          Text('No shipment details available'),
                                    ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
