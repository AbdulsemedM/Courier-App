import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../bloc/add_shipment_bloc.dart';
import '../../model/payment_invoice_model.dart';
import '../../model/branch_model.dart';
import 'print_shipment_screen.dart';
import '../../../../core/theme/theme_provider.dart';

class PaymentWaitingScreen extends StatefulWidget {
  final String trackingNumber;
  final List<BranchModel> branches;
  final String paymentMethod;
  final String payerAccount;
  final int addedBy;

  const PaymentWaitingScreen({
    super.key,
    required this.trackingNumber,
    required this.branches,
    required this.paymentMethod,
    required this.payerAccount,
    required this.addedBy,
  });

  @override
  State<PaymentWaitingScreen> createState() => _PaymentWaitingScreenState();
}

class _PaymentWaitingScreenState extends State<PaymentWaitingScreen> {
  Timer? _pollingTimer;
  PaymentInvoiceModel? _shipmentDetails;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startPolling();
    // Automatically initiate payment when screen loads
    _initiatePayment();
  }

  void _initiatePayment() async {
    // Small delay to ensure the screen is fully loaded
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    context.read<AddShipmentBloc>().add(
          InitiatePaymentEvent(
            awb: widget.trackingNumber,
            paymentMethod: widget.paymentMethod,
            payerAccount: widget.payerAccount,
            addedBy: widget.addedBy,
          ),
        );
  }

  void _startPolling() {
    // Fetch immediately
    _fetchShipmentDetails();

    // Then poll every 3 seconds
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _fetchShipmentDetails();
    });
  }

  void _fetchShipmentDetails() {
    if (!mounted) return;
    context.read<AddShipmentBloc>().add(
          FetchShipmentDetailsEvent(trackingNumber: widget.trackingNumber),
        );
  }

  String? _getBranchName(int? branchId) {
    if (branchId == null) return null;
    try {
      final branch = widget.branches.firstWhere(
        (b) => b.id == branchId,
        orElse: () => BranchModel(),
      );
      return branch.name;
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0A1931) : Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Payment Status',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: BlocListener<AddShipmentBloc, AddShipmentState>(
        listener: (context, state) {
          if (state is ShipmentDetailsFetched) {
            setState(() {
              _shipmentDetails = state.shipmentDetails;
              _isLoading = false;
              _errorMessage = null;
            });

            // Check if payment status is SUCCESS
            if (state.shipmentDetails.paymentStatus == 'SUCCESS') {
              _pollingTimer?.cancel();
              Future.microtask(() {
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrintShipmentScreen(
                        trackingNumber: widget.trackingNumber,
                      ),
                    ),
                  );
                }
              });
            }
          } else if (state is ShipmentDetailsFetchError) {
            setState(() {
              _isLoading = false;
              _errorMessage = state.error;
            });
          } else if (state is FetchShipmentDetailsLoading) {
            if (_shipmentDetails == null) {
              setState(() {
                _isLoading = true;
              });
            }
          }
        },
        child: _isLoading && _shipmentDetails == null
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null && _shipmentDetails == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: $_errorMessage',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _fetchShipmentDetails,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : _shipmentDetails == null
                    ? const Center(child: Text('No shipment details available'))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child:
                            _buildShipmentCard(_shipmentDetails!, isDarkMode),
                      ),
      ),
    );
  }

  Widget _buildShipmentCard(PaymentInvoiceModel details, bool isDarkMode) {
    final senderBranchName =
        _getBranchName(details.senderBranchId) ?? details.senderBranch ?? 'N/A';
    final receiverBranchName = _getBranchName(details.receiverBranchId) ??
        details.receiverBranch ??
        'N/A';

    final isSuccess = details.paymentStatus == 'SUCCESS';
    final isPending = details.paymentStatus == 'PENDING';

    return Column(
      children: [
        // Payment Status Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isSuccess
                  ? [Colors.green[400]!, Colors.green[600]!]
                  : isPending
                      ? [Colors.orange[400]!, Colors.orange[600]!]
                      : [Colors.blue[400]!, Colors.blue[600]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color:
                    (isSuccess ? Colors.green : Colors.orange).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(
                isSuccess
                    ? Icons.check_circle
                    : isPending
                        ? Icons.hourglass_empty
                        : Icons.info,
                size: 64,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                details.paymentStatus ?? 'PENDING',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              if (isPending) ...[
                const SizedBox(height: 8),
                const Text(
                  'Waiting for payment confirmation...',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 16),
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Tracking Number Card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.local_shipping,
                      color: Colors.deepPurple[400],
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Tracking Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildInfoRow(
                  'Tracking Number',
                  details.awb ?? 'N/A',
                  isDarkMode,
                  isBold: true,
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  'Transaction Reference',
                  details.transactionReference ?? 'N/A',
                  isDarkMode,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Sender & Receiver Card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.people,
                      color: Colors.deepPurple[400],
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Sender & Receiver',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Sender Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[900] : Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 20,
                            color: Colors.blue[700],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Sender',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        'Name',
                        details.senderName ?? 'N/A',
                        isDarkMode,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'Mobile',
                        details.senderMobile ?? 'N/A',
                        isDarkMode,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'Branch',
                        senderBranchName,
                        isDarkMode,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Receiver Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[900] : Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 20,
                            color: Colors.green[700],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Receiver',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        'Name',
                        details.receiverName ?? 'N/A',
                        isDarkMode,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'Mobile',
                        details.receiverMobile ?? 'N/A',
                        isDarkMode,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'Branch',
                        receiverBranchName,
                        isDarkMode,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Shipment Details Card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.inventory_2,
                      color: Colors.deepPurple[400],
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Shipment Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailBox(
                        'Weight',
                        '${details.qty ?? 0} ${details.unit ?? 'kg'}',
                        Icons.scale,
                        Colors.purple,
                        isDarkMode,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDetailBox(
                        'Boxes',
                        '${details.numBoxes ?? 0}',
                        Icons.inbox,
                        Colors.indigo,
                        isDarkMode,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  'Description',
                  details.shipmentDescription ?? 'N/A',
                  isDarkMode,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Payment & Barcode Card
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.payment,
                      color: Colors.deepPurple[400],
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Payment & Barcode',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepPurple[50]!,
                        Colors.deepPurple[100]!,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Amount',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'ETB ${details.totalAmount?.toStringAsFixed(2) ?? '0.00'}',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple[900],
                            ),
                          ),
                        ],
                      ),
                      if (details.barcodeUrl != null)
                        Container(
                          width: 120,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.deepPurple[200]!,
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              details.barcodeUrl!,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 32,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                );
                              },
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
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDarkMode,
      {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailBox(String label, String value, IconData icon,
      MaterialColor color, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : color[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color[200]!,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color[700], size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : color[900],
            ),
          ),
        ],
      ),
    );
  }
}
