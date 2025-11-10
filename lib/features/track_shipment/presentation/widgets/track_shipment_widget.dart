import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../model/track_shipment_model.dart';
import 'package:intl/intl.dart';
import '../../../add_shipment/model/branch_model.dart';

class TrackShipmentWidgets {
  static Widget buildShimmerEffect(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: isDarkMode ? Colors.grey[850]! : Colors.grey[300]!,
        highlightColor: isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
        child: Column(
          children: [
            // Header shimmer
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 16),
            // Details shimmer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: List.generate(
                  4,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          height: 20,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Timeline shimmer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: List.generate(
                  3,
                  (index) => Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.only(bottom: 16),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildTrackingDetails({
    required bool isDarkMode,
    required List<TrackShipmentModel> shipments,
    List<BranchModel>? branches,
  }) {
    final mainShipment = shipments.first;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(isDarkMode, mainShipment),
            const SizedBox(height: 16),
            _buildShipmentInfoCard(isDarkMode, mainShipment, branches),
            const SizedBox(height: 16),
            _buildPaymentCard(isDarkMode, mainShipment),
            const SizedBox(height: 16),
            if (mainShipment.barcodeUrl != null)
              _buildBarcodeCard(isDarkMode, mainShipment),
            if (mainShipment.barcodeUrl != null) const SizedBox(height: 16),
            _buildTimelineCard(isDarkMode, shipments),
          ],
        ),
      ),
    );
  }

  static String? _getBranchName(int? branchId, List<BranchModel>? branches) {
    if (branchId == null || branches == null) return null;
    try {
      final branch = branches.firstWhere(
        (b) => b.id == branchId,
        orElse: () => BranchModel(),
      );
      return branch.name;
    } catch (e) {
      return null;
    }
  }

  static Widget _buildHeaderCard(bool isDarkMode, TrackShipmentModel shipment) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepPurple[400]!,
            Colors.deepPurple[600]!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_shipping,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tracking Number',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      shipment.awb,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              if (shipment.shipmentType != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    shipment.shipmentType!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              if (shipment.shipmentType != null) const SizedBox(width: 8),
              if (shipment.statusCode != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    shipment.statusCode!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildShipmentInfoCard(bool isDarkMode,
      TrackShipmentModel shipment, List<BranchModel>? branches) {
    final senderBranchName =
        _getBranchName(shipment.senderBranchId, branches) ?? shipment.name;
    final receiverBranchName =
        _getBranchName(shipment.receiverBranchId, branches);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
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
                  Icons.info_outline,
                  color: Colors.deepPurple[400],
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Shipment Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
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
                      Icon(Icons.person_outline,
                          size: 20, color: Colors.blue[700]),
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
                  _buildInfoRow('Name', shipment.senderName, isDarkMode),
                  const SizedBox(height: 8),
                  _buildInfoRow('Mobile', shipment.senderMobile, isDarkMode),
                  const SizedBox(height: 8),
                  _buildInfoRow('Branch', senderBranchName, isDarkMode),
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
                      Icon(Icons.person, size: 20, color: Colors.green[700]),
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
                  _buildInfoRow('Name', shipment.receiverName, isDarkMode),
                  const SizedBox(height: 8),
                  _buildInfoRow('Mobile', shipment.receiverMobile, isDarkMode),
                  const SizedBox(height: 8),
                  if (receiverBranchName != null)
                    _buildInfoRow('Branch', receiverBranchName, isDarkMode),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Shipment Details
            Row(
              children: [
                if (shipment.deliveryType != null)
                  Expanded(
                    child: _buildDetailChip(
                      Icons.local_shipping,
                      shipment.deliveryType!,
                      Colors.blue,
                      isDarkMode,
                    ),
                  ),
                if (shipment.deliveryType != null) const SizedBox(width: 12),
                if (shipment.transportMode != null)
                  Expanded(
                    child: _buildDetailChip(
                      Icons.directions_car,
                      shipment.transportMode!,
                      Colors.purple,
                      isDarkMode,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Description',
                _stripHtmlTags(shipment.shipmentDescription), isDarkMode),
            const SizedBox(height: 12),
            Row(
              children: [
                if (shipment.qty != null && shipment.unit != null)
                  Expanded(
                    child: _buildDetailBox(
                      'Weight',
                      '${shipment.qty} ${shipment.unit}',
                      Icons.scale,
                      Colors.indigo,
                      isDarkMode,
                    ),
                  ),
                if (shipment.qty != null && shipment.unit != null)
                  const SizedBox(width: 12),
                if (shipment.numBoxes != null)
                  Expanded(
                    child: _buildDetailBox(
                      'Boxes',
                      '${shipment.numBoxes}',
                      Icons.inbox,
                      Colors.orange,
                      isDarkMode,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildPaymentCard(
      bool isDarkMode, TrackShipmentModel shipment) {
    final isPending = shipment.paymentStatus == 'PENDING';
    final isSuccess = shipment.paymentStatus == 'SUCCESS';

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
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
                  'Payment Information',
                  style: TextStyle(
                    fontSize: 20,
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
                  colors: isSuccess
                      ? [Colors.green[50]!, Colors.green[100]!]
                      : isPending
                          ? [Colors.orange[50]!, Colors.orange[100]!]
                          : [Colors.blue[50]!, Colors.blue[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
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
                            'ETB ${shipment.totalAmount?.toStringAsFixed(2) ?? shipment.netFee}',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple[900],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSuccess
                              ? Colors.green[400]
                              : isPending
                                  ? Colors.orange[400]
                                  : Colors.blue[400],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          shipment.paymentStatus ?? 'UNKNOWN',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (shipment.paymentStatusDescription != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      shipment.paymentStatusDescription!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  if (shipment.transactionReference != null) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      'Transaction Ref',
                      shipment.transactionReference!,
                      isDarkMode,
                    ),
                  ],
                  if (shipment.method.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow(
                        'Payment Method', shipment.method, isDarkMode),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildBarcodeCard(
      bool isDarkMode, TrackShipmentModel shipment) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
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
                  Icons.qr_code,
                  color: Colors.deepPurple[400],
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Barcode',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.deepPurple[200]!,
                    width: 2,
                  ),
                ),
                child: Image.network(
                  shipment.barcodeUrl!,
                  width: 250,
                  height: 120,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                      width: 250,
                      height: 120,
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 48,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(
                      width: 250,
                      height: 120,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildTimelineCard(
      bool isDarkMode, List<TrackShipmentModel> shipments) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
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
                  Icons.timeline,
                  color: Colors.deepPurple[400],
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Shipment Status Timeline',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: shipments.length,
              itemBuilder: (context, index) {
                final shipment = shipments[index];
                return _buildTimelineItem(
                  isDarkMode: isDarkMode,
                  description: shipment.description.isNotEmpty
                      ? shipment.description
                      : (shipment.statusDescription ?? 'Status update'),
                  time: shipment.createdAt,
                  user: shipment.addedByFirstName != null
                      ? '${shipment.addedByFirstName} ${shipment.addedByLastName ?? ''}'
                          .trim()
                      : shipment.updatedBy,
                  isLast: index == shipments.length - 1,
                  statusCode: shipment.statusCode,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildTimelineItem({
    required bool isDarkMode,
    required String description,
    required String time,
    required String user,
    required bool isLast,
    String? statusCode,
  }) {
    final formattedTime = _formatDateTime(time);
    final statusColor = _getStatusColor(statusCode);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.check,
                  size: 14,
                  color: Colors.white,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 3,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          statusColor,
                          statusColor.withOpacity(0.3),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description.trim(),
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formattedTime,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      if (user.isNotEmpty) ...[
                        const SizedBox(width: 12),
                        Icon(
                          Icons.person,
                          size: 14,
                          color: Colors.grey[600]!,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'user: $user',
                          style: TextStyle(
                            color: Colors.grey[600]!,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Color _getStatusColor(String? statusCode) {
    switch (statusCode?.toUpperCase()) {
      case 'PAR':
        return Colors.orange;
      case 'SUCCESS':
      case 'COMPLETED':
        return Colors.green;
      case 'PENDING':
        return Colors.blue;
      default:
        return Colors.deepPurple;
    }
  }

  static String _formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return '';

    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return DateFormat('MM/dd/yyyy, hh:mm:ss a').format(dateTime);
    } catch (e) {
      return dateTimeStr;
    }
  }

  static String _stripHtmlTags(String htmlString) {
    if (htmlString.isEmpty) return '';
    return htmlString
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .trim();
  }

  static Widget _buildInfoRow(String label, String value, bool isDarkMode) {
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
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  static Widget _buildDetailChip(
      IconData icon, String label, MaterialColor color, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : color[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color[200]!,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color[700], size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : color[900],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildDetailBox(String label, String value, IconData icon,
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
