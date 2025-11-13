import 'dart:convert';

import 'package:courier_app/features/transaction_branch_to_hq/data/data_provider/transaction_branch_to_hq_data_provider.dart';
import 'package:courier_app/features/transaction_branch_to_hq/data/model/transaction_branch_to_hq_model.dart';

class TransactionBranchToHqRepository {
  final TransactionBranchToHqDataProvider dataProvider;

  TransactionBranchToHqRepository({required this.dataProvider});

  Future<TransactionBranchToHqModel> fetchTransactions(
      int branchId, String startDate, String endDate) async {
    try {
      final response = await dataProvider.fetchTransactions(
          branchId, startDate, endDate);
      final data = jsonDecode(response);

      // Check if response has status wrapper
      if (data.containsKey('status')) {
        if (data['status'] != 200) {
          throw data['message'] ?? 'Failed to fetch transactions';
        }
        final model = TransactionBranchToHqModel.fromMap(data);
        // Add date range to model
        return TransactionBranchToHqModel(
          status: model.status,
          message: model.message,
          data: model.data,
          startDate: startDate,
          endDate: endDate,
        );
      } else {
        // Direct data response (no status wrapper)
        return TransactionBranchToHqModel(
          status: 200,
          message: 'Success',
          data: (data as List<dynamic>?)
                  ?.map((item) =>
                      TransactionItem.fromMap(item as Map<String, dynamic>))
                  .toList() ??
              [],
          startDate: startDate,
          endDate: endDate,
        );
      }
    } catch (e) {
      print('Error in fetchTransactions: ${e.toString()}');
      throw e.toString();
    }
  }
}

