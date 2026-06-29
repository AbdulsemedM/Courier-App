import 'package:courier_app/core/utils/branch_name_resolver.dart';
import 'package:courier_app/features/shipment_invoice/model/shipment_invoice_model.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ShipmentInvoicePdfGenerator {
  static Future<pw.Document> generate(
    ShipmentInvoiceModel invoice, {
    Map<int, String>? branchNamesById,
  }) async {
    final pdf = pw.Document();
    final logo = await imageFromAssetBundle('assets/images/courier.png');

    final senderBranch = BranchNameResolver.resolve(
      name: invoice.senderbranchName,
      branchId: invoice.senderBranchId,
      branchNamesById: branchNamesById,
    );
    final receiverBranch = BranchNameResolver.resolve(
      name: invoice.receiverBranchName,
      branchId: invoice.receiverBranchId,
      branchNamesById: branchNamesById,
    );

    final totalAmount =
        invoice.totalAmount > 0 ? invoice.totalAmount : invoice.netFee;
    final vatRateLabel = _formatVatLabel(invoice.vatRate);
    final generatedOn = _formatGeneratedDate(invoice.invoiceDate);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 36),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Shipment Invoice',
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        'AWB: ${invoice.awb}',
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  pw.SizedBox(
                    width: 130,
                    child: pw.Image(logo),
                  ),
                ],
              ),
              pw.SizedBox(height: 28),
              _sectionTitle('Sender'),
              _personBlock(
                name: invoice.senderName,
                phone: invoice.senderMobile,
                branch: senderBranch,
              ),
              pw.SizedBox(height: 20),
              _sectionTitle('Receiver'),
              _personBlock(
                name: invoice.receiverName,
                phone: invoice.receiverMobile,
                branch: receiverBranch,
              ),
              pw.SizedBox(height: 20),
              _sectionTitle('Shipment Details'),
              _detailRow('Description', invoice.shipmentDescription),
              _detailRow('Quantity', '${invoice.qty} ${invoice.unit}'),
              _detailRow('Pieces', '${invoice.numPcs}'),
              _detailRowWithBadge('Service', invoice.serviceModeName),
              pw.SizedBox(height: 20),
              _sectionTitle('Payment Details'),
              _detailRow('Net Fee', _formatEtb(invoice.netFee)),
              _detailRow(vatRateLabel, _formatEtb(invoice.vatAmount)),
              _detailRow(
                'Total Amount',
                _formatEtb(totalAmount),
                valueBold: true,
              ),
              _detailRowWithBadge('Payment Status', invoice.paymentModeName),
              pw.Spacer(),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Generated on $generatedOn',
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey700,
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

  static pw.Widget _sectionTitle(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 16,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  static pw.Widget _personBlock({
    required String name,
    required String phone,
    required String branch,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          name.toUpperCase(),
          style: pw.TextStyle(
            fontSize: 13,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 4),
        if (phone.isNotEmpty)
          pw.Text(phone, style: const pw.TextStyle(fontSize: 12)),
        if (branch.isNotEmpty) ...[
          pw.SizedBox(height: 4),
          pw.Text(
            'Branch: $branch',
            style: const pw.TextStyle(fontSize: 12),
          ),
        ],
      ],
    );
  }

  static pw.Widget _detailRow(
    String label,
    String value, {
    bool valueBold = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 2,
            child: pw.Text(label, style: const pw.TextStyle(fontSize: 12)),
          ),
          pw.Expanded(
            flex: 3,
            child: pw.Text(
              value,
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight:
                    valueBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _detailRowWithBadge(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Expanded(
            flex: 2,
            child: pw.Text(label, style: const pw.TextStyle(fontSize: 12)),
          ),
          pw.Expanded(
            flex: 3,
            child: pw.Align(
              alignment: pw.Alignment.centerRight,
              child: _badge(value),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _badge(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey300,
        borderRadius: pw.BorderRadius.circular(12),
      ),
      child: pw.Text(
        text.toUpperCase(),
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.grey800,
        ),
      ),
    );
  }

  static String _formatEtb(double amount) =>
      '${amount.toStringAsFixed(2)} ETB';

  static String _formatVatLabel(double rate) {
    final displayRate =
        rate == rate.roundToDouble() ? rate.toInt().toString() : '$rate';
    return 'VAT ($displayRate%)';
  }

  static String _formatGeneratedDate(String? dateValue) {
    try {
      if (dateValue == null || dateValue.isEmpty) {
        return DateFormat('M/d/yyyy, h:mm:ss a').format(DateTime.now());
      }
      final dateTime = DateTime.parse(dateValue);
      return DateFormat('M/d/yyyy, h:mm:ss a').format(dateTime);
    } catch (_) {
      return dateValue ?? 'N/A';
    }
  }
}
