import 'dart:convert';
import 'package:courier_app/features/branch_expenses/data/data_provider/branch_expenses_data_provider.dart';
import 'package:courier_app/features/branch_report/data/model/branch_shipment_model.dart';

class BranchExpensesRepository {
  final BranchExpensesDataProvider dataProvider;

  BranchExpensesRepository({required this.dataProvider});

  Future<List<BranchShipmentModel>> fetchBranchExpenses({
    required int branchId,
    required String fromDate,
    required String toDate,
  }) async {
    try {
      final response = await dataProvider.fetchBranchExpenses(
        branchId: branchId,
        fromDate: fromDate,
        toDate: toDate,
      );
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'] ?? 'Failed to fetch branch expenses';
      }
      if (data['data'] is List) {
        return (data['data'] as List)
            .map((item) => BranchShipmentModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error in fetchBranchExpenses: ${e.toString()}');
      throw e.toString();
    }
  }
}

