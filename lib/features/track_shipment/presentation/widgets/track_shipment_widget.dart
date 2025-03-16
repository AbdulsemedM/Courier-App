import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../model/track_shipment_model.dart';
import 'package:intl/intl.dart';

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
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 16),
            // Details shimmer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
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
                borderRadius: BorderRadius.circular(12),
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
            _buildDetailsCard(isDarkMode, mainShipment),
            const SizedBox(height: 16),
            _buildTimelineCard(isDarkMode, shipments),
          ],
        ),
      ),
    );
  }

  static Widget _buildHeaderCard(bool isDarkMode, TrackShipmentModel shipment) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.blue.withOpacity(0.1) : Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.blue.withOpacity(0.3) : Colors.blue[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AWB: ${shipment.awb}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            shipment.shipmentDescription,
            style: TextStyle(
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildDetailsCard(
      bool isDarkMode, TrackShipmentModel shipment) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          _buildDetailRow(
            isDarkMode: isDarkMode,
            icon: Icons.person_outline,
            label: 'Sender',
            value: '${shipment.senderName}\n${shipment.senderMobile}',
          ),
          const Divider(),
          _buildDetailRow(
            isDarkMode: isDarkMode,
            icon: Icons.person,
            label: 'Receiver',
            value: '${shipment.receiverName}\n${shipment.receiverMobile}',
          ),
          const Divider(),
          _buildDetailRow(
            isDarkMode: isDarkMode,
            icon: Icons.location_on_outlined,
            label: 'Branch',
            value: shipment.name,
          ),
          const Divider(),
          _buildDetailRow(
            isDarkMode: isDarkMode,
            icon: Icons.payment,
            label: 'Payment',
            value: '${shipment.netFee}\n${shipment.method}',
          ),
        ],
      ),
    );
  }

  static Widget _buildTimelineCard(
      bool isDarkMode, List<TrackShipmentModel> shipments) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tracking Timeline',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: shipments.length,
            itemBuilder: (context, index) {
              final shipment = shipments[index];
              return _buildTimelineItem(
                isDarkMode: isDarkMode,
                description: shipment.description,
                time: shipment.createdAt,
                isLast: index == shipments.length - 1,
              );
            },
          ),
        ],
      ),
    );
  }

  static String _formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return '';

    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    } catch (e) {
      return dateTimeStr; // Return original string if parsing fails
    }
  }

  static Widget _buildTimelineItem({
    required bool isDarkMode,
    required String description,
    required String time,
    required bool isLast,
  }) {
    final formattedTime = _formatDateTime(time);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.blue[400] : Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDarkMode ? Colors.blue[300]! : Colors.blue[200]!,
                    width: 3,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
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
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedTime,
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildDetailRow({
    required bool isDarkMode,
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
