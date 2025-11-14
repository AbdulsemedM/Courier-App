import 'dart:convert';
import 'package:courier_app/features/closeout_transaction/data/data_provider/closeout_transaction_data_provider.dart';
import 'package:courier_app/features/closeout_transaction/data/model/closeout_transaction_model.dart';

class CloseoutTransactionRepository {
  final CloseoutTransactionDataProvider dataProvider;

  CloseoutTransactionRepository({required this.dataProvider});

  Future<CloseoutTransactionModel> fetchCloseoutTransactions({
    required int tellerId,
    required String startDate,
    required String endDate,
  }) async {
    try {
      final response = await dataProvider.fetchCloseoutTransactions(
        tellerId: tellerId,
        startDate: startDate,
        endDate: endDate,
      );
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'] ?? 'Failed to fetch closeout transactions';
      }
      return CloseoutTransactionModel.fromMap(data);
    } catch (e) {
      print('Error in fetchCloseoutTransactions: ${e.toString()}');
      throw e.toString();
    }
  }
}

