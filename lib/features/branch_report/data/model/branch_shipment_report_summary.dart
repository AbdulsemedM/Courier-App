import 'package:courier_app/features/branch_report/data/model/branch_shipment_model.dart';

class BranchShipmentReportSummary {
  final int totalShipments;
  final int cash;
  final int cod;
  final int ebirr;
  final int sahay;
  final double totalFee;

  const BranchShipmentReportSummary({
    required this.totalShipments,
    required this.cash,
    required this.cod,
    required this.ebirr,
    required this.sahay,
    required this.totalFee,
  });

  factory BranchShipmentReportSummary.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0;
    }

    int toInt(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString()) ?? 0;
    }

    return BranchShipmentReportSummary(
      totalShipments: toInt(
        json['totalShipments'] ??
            json['total'] ??
            json['totalCount'] ??
            json['count'],
      ),
      cash: toInt(
        json['cash'] ??
            json['cashShipments'] ??
            json['CASH'] ??
            json['cashCount'],
      ),
      cod: toInt(
        json['cod'] ??
            json['codShipments'] ??
            json['COD'] ??
            json['codCount'],
      ),
      ebirr: toInt(
        json['ebirr'] ??
            json['ebirrShipments'] ??
            json['EBIRR'] ??
            json['ebirrCount'],
      ),
      sahay: toInt(
        json['sahay'] ??
            json['sahayShipments'] ??
            json['SAHAY'] ??
            json['sahayCount'],
      ),
      totalFee: toDouble(
        json['totalFee'] ?? json['totalNetFee'] ?? json['totalAmount'],
      ),
    );
  }

  factory BranchShipmentReportSummary.fromShipments(
    List<BranchShipmentModel> shipments,
  ) {
    var cash = 0;
    var cod = 0;
    var ebirr = 0;
    var sahay = 0;
    var totalFee = 0.0;

    for (final shipment in shipments) {
      final method = shipment.paymentMethodCode;
      switch (method) {
        case 'CASH':
          cash++;
        case 'COD':
          cod++;
        case 'EBIRR':
          ebirr++;
        case 'SAHAY':
          sahay++;
      }
      totalFee += shipment.feeAmount;
    }

    return BranchShipmentReportSummary(
      totalShipments: shipments.length,
      cash: cash,
      cod: cod,
      ebirr: ebirr,
      sahay: sahay,
      totalFee: totalFee,
    );
  }
}

class BranchShipmentReportResult {
  final List<BranchShipmentModel> shipments;
  final BranchShipmentReportSummary summary;
  final String? branchName;

  const BranchShipmentReportResult({
    required this.shipments,
    required this.summary,
    this.branchName,
  });
}
