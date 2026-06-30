import 'dart:convert';

import 'package:courier_app/features/branch_report/data/model/branch_shipment_model.dart';
import 'package:courier_app/features/branch_report/data/model/branch_shipment_report_summary.dart';
import 'package:courier_app/features/branch_report_net/data/data_provider/branch_report_net_data_provider.dart';

class BranchReportNetRepository {
  final BranchReportNetDataProvider dataProvider;

  BranchReportNetRepository({required this.dataProvider});

  Future<BranchShipmentReportResult> fetchBranchReportNet({
    required int branchId,
    required String fromDate,
    required String toDate,
  }) async {
    try {
      final response = await dataProvider.fetchBranchShipments(
        branchId: branchId,
        fromDate: fromDate,
        toDate: toDate,
      );
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'] ?? 'Failed to fetch branch report net';
      }

      final shipments = <BranchShipmentModel>[];
      if (data['data'] is List) {
        for (final item in data['data'] as List) {
          if (item is Map<String, dynamic>) {
            shipments.add(BranchShipmentModel.fromJson(item));
          }
        }
      }

      final summary =
          BranchShipmentReportSummary.fromShipmentsByPaymentMode(shipments);

      return BranchShipmentReportResult(
        shipments: shipments,
        summary: summary,
      );
    } catch (e) {
      throw e.toString();
    }
  }
}
