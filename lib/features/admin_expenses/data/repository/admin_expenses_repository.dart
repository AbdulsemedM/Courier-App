import 'dart:convert';
import 'package:courier_app/features/admin_expenses/data/data_provider/admin_expenses_data_provider.dart';
import 'package:courier_app/features/branch_report/data/model/branch_shipment_model.dart';

class AdminExpensesRepository {
  final AdminExpensesDataProvider dataProvider;

  AdminExpensesRepository({required this.dataProvider});

  Future<List<BranchShipmentModel>> fetchAdminExpenses({
    required int branchId,
    required String fromDate,
    required String toDate,
  }) async {
    try {
      final response = await dataProvider.fetchAdminExpenses(
        branchId: branchId,
        fromDate: fromDate,
        toDate: toDate,
      );
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'] ?? 'Failed to fetch admin expenses';
      }
      if (data['data'] is List) {
        return (data['data'] as List)
            .map((item) => BranchShipmentModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error in fetchAdminExpenses: ${e.toString()}');
      throw e.toString();
    }
  }
}

