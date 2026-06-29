import 'package:courier_app/core/utils/branch_name_resolver.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

class _PaperConfig {
  final int rowWidth;
  final int labelWidth;
  final int valueWidth;
  final int lineChars;

  const _PaperConfig({
    required this.rowWidth,
    required this.labelWidth,
    required this.valueWidth,
    required this.lineChars,
  });

  static Future<_PaperConfig> detect() async {
    try {
      final paperMm = await SunmiPrinter.paperSize();
      if (paperMm <= 58) {
        return const _PaperConfig(
          rowWidth: 22,
          labelWidth: 9,
          valueWidth: 13,
          lineChars: 32,
        );
      }
    } catch (_) {
      // Fall back to 80mm defaults.
    }
    return const _PaperConfig(
      rowWidth: 30,
      labelWidth: 12,
      valueWidth: 18,
      lineChars: 48,
    );
  }
}

class SunmiInvoicePrinter {
  static Future<bool> isSunmiDevice() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final manufacturer = androidInfo.manufacturer.toUpperCase();
      final model = androidInfo.model.toUpperCase();

      return manufacturer.contains('SUNMI') ||
          model.contains('V3 MIX') ||
          model.contains('V3MIX') ||
          model.contains('SUNMI') ||
          model.contains('V3');
    } catch (_) {
      return false;
    }
  }

  static Future<bool> printInvoice({
    required Map<String, dynamic> data,
    required String awb,
    Map<int, String>? branchNamesById,
  }) async {
    final bool? binded = await SunmiPrinter.bindingPrinter();
    if (binded != true) {
      return false;
    }

    await SunmiPrinter.initPrinter();
    await SunmiPrinter.startTransactionPrint(true);

    final paper = await _PaperConfig.detect();

    final senderName = (data['senderName'] ?? '').toString().toUpperCase();
    final senderMobile = (data['senderMobile'] ?? '').toString();
    final senderBranch = _resolveBranchName(
      data: data,
      branchKey: 'senderBranch',
      branchNameKeys: const ['senderBranchName', 'senderbranchName'],
      branchIdKey: 'senderBranchId',
      branchNamesById: branchNamesById,
    );

    final receiverBranch = _resolveBranchName(
      data: data,
      branchKey: 'receiverBranch',
      branchNameKeys: const ['receiverBranchName'],
      branchIdKey: 'receiverBranchId',
      branchNamesById: branchNamesById,
    );

    final receiverName = (data['receiverName'] ?? '').toString().toUpperCase();
    final receiverMobile = (data['receiverMobile'] ?? '').toString();

    final description = (data['shipmentDescription'] ?? '').toString();
    final qty = data['qty'] ?? 1;
    final unit = (data['unit'] ?? 'kg').toString();
    final numPcs = data['numPcs'] ?? 0;

    final netFee = (data['netFee'] as num?)?.toDouble() ?? 0.0;
    final totalAmount = (data['totalAmount'] as num?)?.toDouble() ?? netFee;
    final vatAmount = (data['vatAmount'] as num?)?.toDouble() ??
        (totalAmount - netFee).clamp(0.0, double.infinity);
    final vatRate = (data['vatRate'] as num?)?.toDouble() ?? 0.0;

    final serviceText = _resolveServiceModeText(data);
    final paymentStatus = _resolvePaymentStatusText(data);
    final generatedOn = _formatInvoiceGeneratedDate(
      data['updatedAt'] ?? data['createdAt'],
    );

    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.printText(
      'Shipment Invoice',
      style: SunmiStyle(
        bold: true,
        fontSize: SunmiFontSize.LG,
        align: SunmiPrintAlign.CENTER,
      ),
    );
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText(
      'AWB: $awb',
      style: SunmiStyle(
        fontSize: SunmiFontSize.MD,
        align: SunmiPrintAlign.CENTER,
      ),
    );
    await SunmiPrinter.lineWrap(1);
    await _printDivider(paper.lineChars);
    await SunmiPrinter.lineWrap(1);

    await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT);
    await _printSectionHeader('Sender', paper);
    if (senderName.isNotEmpty) {
      await _printFullWidthText(senderName, paper);
    }
    if (senderMobile.isNotEmpty) {
      await _printFullWidthText(senderMobile, paper);
    }
    if (senderBranch.isNotEmpty) {
      await _printFullWidthText('Branch: $senderBranch', paper);
    }
    await SunmiPrinter.lineWrap(1);

    await _printSectionHeader('Receiver', paper);
    if (receiverName.isNotEmpty) {
      await _printFullWidthText(receiverName, paper);
    }
    if (receiverMobile.isNotEmpty) {
      await _printFullWidthText(receiverMobile, paper);
    }
    if (receiverBranch.isNotEmpty) {
      await _printFullWidthText('Branch: $receiverBranch', paper);
    }
    await SunmiPrinter.lineWrap(1);
    await _printDivider(paper.lineChars);

    await _printSectionHeader('Shipment Details', paper);
    await _printLabelValueRow(
      paper: paper,
      label: 'Description',
      value: description.isNotEmpty ? description : 'N/A',
      multilineValue: true,
    );
    await _printLabelValueRow(
      paper: paper,
      label: 'Quantity',
      value: '$qty $unit',
    );
    await _printLabelValueRow(
      paper: paper,
      label: 'Pieces',
      value: '$numPcs',
    );
    await _printLabelValueRow(
      paper: paper,
      label: 'Service',
      value: serviceText,
    );
    await SunmiPrinter.lineWrap(1);
    await _printDivider(paper.lineChars);

    await _printSectionHeader('Payment Details', paper);
    await _printLabelValueRow(
      paper: paper,
      label: 'Net Fee',
      value: _formatEtb(netFee),
    );
    await _printLabelValueRow(
      paper: paper,
      label: _formatVatLabel(vatRate),
      value: _formatEtb(vatAmount),
    );
    await _printLabelValueRow(
      paper: paper,
      label: 'Total Amount',
      value: _formatEtb(totalAmount),
      bold: true,
    );
    await _printLabelValueRow(
      paper: paper,
      label: 'Payment Status',
      value: paymentStatus,
    );
    await SunmiPrinter.lineWrap(1);
    await _printDivider(paper.lineChars);
    await SunmiPrinter.lineWrap(1);

    await SunmiPrinter.setAlignment(SunmiPrintAlign.RIGHT);
    await SunmiPrinter.printText(
      'Generated on $generatedOn',
      style: SunmiStyle(
        fontSize: SunmiFontSize.XS,
        align: SunmiPrintAlign.RIGHT,
      ),
    );
    await SunmiPrinter.lineWrap(2);

    await SunmiPrinter.exitTransactionPrint(true);
    await SunmiPrinter.cut();
    return true;
  }

  static String _resolveBranchName({
    required Map<String, dynamic> data,
    required String branchKey,
    required List<String> branchNameKeys,
    required String branchIdKey,
    Map<int, String>? branchNamesById,
  }) {
    for (final key in branchNameKeys) {
      final value = data[key]?.toString().trim() ?? '';
      if (!BranchNameResolver.isMissingName(value)) {
        return value;
      }
    }

    final parsedName = BranchNameResolver.parseName(data[branchKey]);
    if (parsedName.isNotEmpty) return parsedName;

    final branchId = BranchNameResolver.parseId(data[branchKey]) ??
        BranchNameResolver.parseId(data[branchIdKey]);

    return BranchNameResolver.resolve(
      name: null,
      branchId: branchId,
      branchNamesById: branchNamesById,
    );
  }

  static Future<void> _printDivider(int length) async {
    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
    await SunmiPrinter.line(len: length);
    await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT);
  }

  static Future<void> _printSectionHeader(
    String title,
    _PaperConfig paper,
  ) async {
    await SunmiPrinter.bold();
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: title,
        width: paper.rowWidth,
        align: SunmiPrintAlign.LEFT,
      ),
    ]);
    await SunmiPrinter.resetBold();
    await SunmiPrinter.lineWrap(1);
  }

  static Future<void> _printFullWidthText(
    String text,
    _PaperConfig paper,
  ) async {
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: text,
        width: paper.rowWidth,
        align: SunmiPrintAlign.LEFT,
      ),
    ]);
    await SunmiPrinter.lineWrap(1);
  }

  static Future<void> _printLabelValueRow({
    required _PaperConfig paper,
    required String label,
    required String value,
    bool bold = false,
    bool multilineValue = false,
  }) async {
    if (bold) await SunmiPrinter.bold();
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: label,
        width: paper.labelWidth,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: multilineValue ? '' : value,
        width: paper.valueWidth,
        align: SunmiPrintAlign.RIGHT,
      ),
    ]);
    if (bold) await SunmiPrinter.resetBold();
    await SunmiPrinter.lineWrap(1);

    if (multilineValue && value.isNotEmpty) {
      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: value,
          width: paper.rowWidth,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);
      await SunmiPrinter.lineWrap(1);
    }
  }

  static String? _resolvePaymentField(dynamic value) {
    if (value == null) return null;
    if (value is Map) {
      final field = value['method'] ?? value['code'];
      if (field != null && field.toString().trim().isNotEmpty) {
        return field.toString().trim();
      }
      return null;
    }
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static String? _resolvePaymentModeField(dynamic value) {
    if (value == null) return null;
    if (value is Map) {
      final field = value['code'] ?? value['method'];
      if (field != null && field.toString().trim().isNotEmpty) {
        return field.toString().trim();
      }
      return null;
    }
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static String _resolveServiceModeText(Map<String, dynamic> data) {
    final serviceMode = data['serviceMode'];
    if (serviceMode is Map) {
      return (serviceMode['description'] ?? serviceMode['code'] ?? 'COURIER')
          .toString()
          .toUpperCase();
    }
    if (serviceMode != null && serviceMode.toString().isNotEmpty) {
      return serviceMode.toString().toUpperCase();
    }
    return 'COURIER';
  }

  static String _resolvePaymentStatusText(Map<String, dynamic> data) {
    final paymentMode = _resolvePaymentModeField(data['paymentMode']);
    if (paymentMode != null && paymentMode.isNotEmpty) {
      return paymentMode.toUpperCase();
    }
    final paymentMethod = _resolvePaymentField(data['paymentMethod']);
    if (paymentMethod != null && paymentMethod.isNotEmpty) {
      return paymentMethod.toUpperCase();
    }
    final paymentStatus = data['paymentStatus']?.toString();
    if (paymentStatus != null && paymentStatus.isNotEmpty) {
      return paymentStatus.toUpperCase();
    }
    return 'N/A';
  }

  static String _formatEtb(double amount) => '${amount.toStringAsFixed(2)} ETB';

  static String _formatVatLabel(double rate) {
    final displayRate =
        rate == rate.roundToDouble() ? rate.toInt().toString() : '$rate';
    return 'VAT ($displayRate%)';
  }

  static String _formatInvoiceGeneratedDate(dynamic dateValue) {
    try {
      if (dateValue == null || dateValue.toString().isEmpty) {
        return DateFormat('M/d/yyyy, h:mm:ss a').format(DateTime.now());
      }
      final dateTime = DateTime.parse(dateValue.toString());
      return DateFormat('M/d/yyyy, h:mm:ss a').format(dateTime);
    } catch (_) {
      return dateValue?.toString() ?? 'N/A';
    }
  }
}
