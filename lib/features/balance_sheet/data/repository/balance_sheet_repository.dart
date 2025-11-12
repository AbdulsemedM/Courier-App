import 'dart:convert';

import 'package:courier_app/features/balance_sheet/data/data_provider/balance_sheet_data_provider.dart';
import 'package:courier_app/features/balance_sheet/data/model/balance_sheet_model.dart';

class BalanceSheetRepository {
  final BalanceSheetDataProvider balanceSheetDataProvider;

  BalanceSheetRepository({required this.balanceSheetDataProvider});

  Future<BalanceSheetModel> fetchBalanceSheet(int branchId, String asOfDate) async {
    try {
      final response = await balanceSheetDataProvider.fetchBalanceSheet(branchId, asOfDate);
      final data = jsonDecode(response);
      
      // Check if response has status wrapper or is direct data
      if (data.containsKey('status')) {
        if (data['status'] != 200) {
          throw data['message'] ?? 'Failed to fetch balance sheet';
        }
        return BalanceSheetModel.fromMap(data['data'] as Map<String, dynamic>);
      } else {
        // Direct data response (no status wrapper)
        return BalanceSheetModel.fromMap(data as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error in fetchBalanceSheet: ${e.toString()}');
      throw e.toString();
    }
  }
}

