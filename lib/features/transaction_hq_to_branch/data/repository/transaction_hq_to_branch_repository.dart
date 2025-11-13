import 'dart:convert';

import 'package:courier_app/features/transaction_hq_to_branch/data/data_provider/transaction_hq_to_branch_data_provider.dart';
import 'package:courier_app/features/transaction_hq_to_branch/data/model/transaction_hq_to_branch_model.dart';

class TransactionHqToBranchRepository {
  final TransactionHqToBranchDataProvider dataProvider;

  TransactionHqToBranchRepository({required this.dataProvider});

  Future<TransactionHqToBranchModel> fetchTransactions(
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
        final model = TransactionHqToBranchModel.fromMap(data);
        // Add date range to model
        return TransactionHqToBranchModel(
          status: model.status,
          message: model.message,
          data: model.data,
          startDate: startDate,
          endDate: endDate,
        );
      } else {
        // Direct data response (no status wrapper)
        return TransactionHqToBranchModel(
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

