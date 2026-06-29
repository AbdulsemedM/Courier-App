import 'package:courier_app/core/utils/api_json_decoder.dart';
import 'package:courier_app/features/branch_report/data/data_provider/branch_report_data_provider.dart';
import 'package:courier_app/features/branch_report/data/model/branch_shipment_model.dart';
import 'package:courier_app/features/branch_report/data/model/branch_shipment_report_summary.dart';

class BranchReportRepository {
  final BranchReportDataProvider dataProvider;

  BranchReportRepository({required this.dataProvider});

  Future<BranchShipmentReportResult> fetchBranchShipments({
    required int branchId,
    required String startDate,
    required String endDate,
    String search = '',
  }) async {
    try {
      final response = await dataProvider.fetchBranchShipments(
        branchId: branchId,
        startDate: startDate,
        endDate: endDate,
        search: search,
      );
      final data = decodeApiMap(response);
      if (data['status'] != 200) {
        throw data['message']?.toString() ?? 'Failed to fetch branch shipments';
      }

      final payload = data['data'];
      final shipments = _parseShipments(payload);
      final summary = _parseSummary(payload, shipments);
      final branchName = _parseBranchName(payload, shipments);

      return BranchShipmentReportResult(
        shipments: shipments,
        summary: summary,
        branchName: branchName,
      );
    } catch (e) {
      throw e.toString();
    }
  }

  List<BranchShipmentModel> _parseShipments(dynamic payload) {
    final rawList = _extractShipmentList(payload);
    final shipments = <BranchShipmentModel>[];

    for (final item in rawList) {
      try {
        shipments.add(BranchShipmentModel.fromReportJson(item));
      } catch (_) {
        // Skip malformed shipment records.
      }
    }

    if (shipments.isEmpty && rawList.isNotEmpty) {
      throw 'Failed to parse shipment data';
    }

    return shipments;
  }

  List<Map<String, dynamic>> _extractShipmentList(dynamic payload) {
    if (payload is List) {
      return payload
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }

    if (payload is Map) {
      final map = Map<String, dynamic>.from(payload);
      for (final key in ['content', 'shipments', 'items', 'records', 'data']) {
        final value = map[key];
        if (value is List) {
          return value
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
        }
      }
    }

    throw 'Invalid response format: Expected shipment list';
  }

  BranchShipmentReportSummary _parseSummary(
    dynamic payload,
    List<BranchShipmentModel> shipments,
  ) {
    if (payload is Map) {
      final map = Map<String, dynamic>.from(payload);
      for (final key in ['summary', 'totals', 'stats', 'statistics']) {
        final value = map[key];
        if (value is Map) {
          final summary = BranchShipmentReportSummary.fromJson(
            Map<String, dynamic>.from(value),
          );
          if (summary.totalShipments > 0 || shipments.isEmpty) {
            return summary;
          }
        }
      }

      final directSummary = BranchShipmentReportSummary.fromJson(map);
      if (directSummary.totalShipments > 0 ||
          directSummary.cash > 0 ||
          directSummary.cod > 0 ||
          directSummary.totalFee > 0) {
        return directSummary;
      }
    }

    return BranchShipmentReportSummary.fromShipments(shipments);
  }

  String? _parseBranchName(
    dynamic payload,
    List<BranchShipmentModel> shipments,
  ) {
    if (payload is Map) {
      final map = Map<String, dynamic>.from(payload);
      final branch = map['branch'];
      if (branch is Map && branch['name'] != null) {
        return branch['name'].toString();
      }
      if (map['branchName'] != null) {
        return map['branchName'].toString();
      }
    }

    for (final shipment in shipments) {
      final name = shipment.branchDisplayName;
      if (name != null && name.isNotEmpty) {
        return name;
      }
    }

    return null;
  }
}
