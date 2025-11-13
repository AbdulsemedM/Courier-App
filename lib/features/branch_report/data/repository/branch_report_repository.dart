import 'dart:convert';
import 'package:courier_app/features/branch_report/data/data_provider/branch_report_data_provider.dart';
import 'package:courier_app/features/branch_report/data/model/branch_shipment_model.dart';

class BranchReportRepository {
  final BranchReportDataProvider dataProvider;

  BranchReportRepository({required this.dataProvider});

  Future<List<BranchShipmentModel>> fetchBranchShipments({
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
        throw data['message'] ?? 'Failed to fetch branch shipments';
      }
      if (data['data'] is List) {
        final shipments = (data['data'] as List)
            .map((shipment) => BranchShipmentModel.fromJson(shipment))
            .toList();
        return shipments;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
