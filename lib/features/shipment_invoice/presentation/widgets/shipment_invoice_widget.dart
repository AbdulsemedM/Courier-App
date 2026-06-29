import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:courier_app/core/theme/app_palette.dart';
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
                color: AppPalette.forMode(isDarkMode).textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Enter AWB Number',
                hintStyle: TextStyle(
                  color: AppPalette.forMode(isDarkMode).textSecondary,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppPalette.forMode(isDarkMode).textSecondary,
                ),
                filled: true,
                fillColor:
                    AppPalette.forMode(isDarkMode).surfaceMuted,
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
              backgroundColor: AppPalette.forMode(isDarkMode).accent,
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Search',
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }

  static Widget buildShimmerEffect(BuildContext context) {
    final isDarkMode = context.isDarkMode;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: isDarkMode ? Colors.grey[850]! : AppPalette.forMode(isDarkMode).border,
        highlightColor: isDarkMode ? Colors.grey[700]! : AppPalette.forMode(isDarkMode).surfaceMuted,
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
        color: AppPalette.forMode(isDarkMode).appBarBackground,
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
              color: isDarkMode
                  ? const Color.fromARGB(255, 73, 4, 185)
                  : const Color.fromARGB(255, 73, 4, 185),
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
                          color: AppPalette.forMode(isDarkMode).textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'AWB',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppPalette.forMode(isDarkMode).textSecondary,
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
              color: isDarkMode
                  ? const Color.fromARGB(255, 73, 4, 185)
                  : const Color.fromARGB(255, 73, 4, 185),
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
        color: isDarkMode
            ? const Color.fromARGB(255, 73, 4, 185)
            : const Color.fromARGB(255, 73, 4, 185),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppPalette.forMode(isDarkMode).border,
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
              color: AppPalette.forMode(isDarkMode).textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            phone,
            style: TextStyle(
              color: AppPalette.forMode(isDarkMode).textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          if (branch.trim().isNotEmpty)
            Text(
              'Branch: $branch',
              style: TextStyle(
                color: AppPalette.forMode(isDarkMode).textSecondary,
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
              color: AppPalette.forMode(isDarkMode).textSecondary,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppPalette.forMode(isDarkMode).textPrimary,
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
            color: AppPalette.forMode(isDarkMode).textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          date,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppPalette.forMode(isDarkMode).textPrimary,
          ),
        ),
      ],
    );
  }

  static Widget buildEmptyState(BuildContext context) {
    final palette = context.palette;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_outlined,
            size: 64,
            color: palette.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'Enter AWB number to view invoice',
            style: TextStyle(
              fontSize: 18,
              color: palette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
