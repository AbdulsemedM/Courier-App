import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import '../../model/shipment_invoice_model.dart';

class ShipmentInvoiceWidgets {
  static Widget buildSearchInput({
    required bool isDarkMode,
    required TextEditingController controller,
    required VoidCallback onSearch,
  }) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: 'Enter AWB Number',
                hintStyle: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
                filled: true,
                fillColor:
                    isDarkMode ? const Color(0xFF1E293B) : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (_) => onSearch(),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: onSearch,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  static Widget buildShimmerEffect(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: isDarkMode ? Colors.grey[850]! : Colors.grey[300]!,
        highlightColor: isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 24),
            // Sender and Receiver Info
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Payment Details
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return 'N/A';
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  static Widget buildInvoiceDetails({
    required bool isDarkMode,
    required ShipmentInvoiceModel invoice,
  }) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF0F172A) : Colors.blue[50],
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        invoice.awb,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'AWB',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _buildDateRow(
                        isDarkMode: isDarkMode,
                        label: 'Shipment Date',
                        date: _formatDateTime(invoice.shipmentDate),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDateRow(
                        isDarkMode: isDarkMode,
                        label: 'Invoice Date',
                        date: _formatDateTime(invoice.invoiceDate),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Sender and Receiver Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    isDarkMode: isDarkMode,
                    title: 'SENDER',
                    name: invoice.senderName,
                    phone: invoice.senderMobile,
                    branch: invoice.senderbranchName,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoCard(
                    isDarkMode: isDarkMode,
                    title: 'RECEIVER',
                    name: invoice.receiverName,
                    phone: invoice.receiverMobile,
                    branch: invoice.receiverBranchName,
                  ),
                ),
              ],
            ),
          ),

          // Payment Details
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF0F172A) : Colors.grey[50],
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Column(
              children: [
                _buildDetailRow(
                  isDarkMode: isDarkMode,
                  label: 'Payment Mode',
                  value: invoice.paymentMethodName,
                ),
                _buildDetailRow(
                  isDarkMode: isDarkMode,
                  label: 'Payment Method',
                  value: invoice.paymentMethodName,
                ),
                _buildDetailRow(
                  isDarkMode: isDarkMode,
                  label: 'Item Description',
                  value: invoice.shipmentDescription,
                ),
                _buildDetailRow(
                  isDarkMode: isDarkMode,
                  label: 'Price',
                  value: 'ETB ${invoice.netFee}',
                  isTotal: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildInfoCard({
    required bool isDarkMode,
    required String title,
    required String name,
    required String phone,
    required String branch,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF0F172A) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.blue[300] : Colors.blue[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            phone,
            style: TextStyle(
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            branch,
            style: TextStyle(
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildDetailRow({
    required bool isDarkMode,
    required String label,
    required String value,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildDateRow({
    required bool isDarkMode,
    required String label,
    required String date,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          date,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  static Widget buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_outlined,
            size: 64,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            'Enter AWB number to view invoice',
            style: TextStyle(
              fontSize: 18,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
