import 'dart:convert';
import 'package:courier_app/features/admin_report/data/data_provider/admin_report_data_provider.dart';
import 'package:courier_app/features/admin_report/data/model/admin_shipment_model.dart';

class AdminReportRepository {
  final AdminReportDataProvider dataProvider;

  AdminReportRepository({required this.dataProvider});

  Future<List<AdminShipmentModel>> fetchAdminShipments({
    required int branchId,
    required String fromDate,
    required String toDate,
  }) async {
    try {
      final response = await dataProvider.fetchAdminShipments(
        branchId: branchId,
        fromDate: fromDate,
        toDate: toDate,
      );
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'] ?? 'Failed to fetch admin shipments';
      }
      if (data['data'] is List) {
        final shipments = (data['data'] as List)
            .map((shipment) => AdminShipmentModel.fromJson(shipment))
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

