import 'dart:convert';

import 'package:courier_app/features/income_statement/data/data_provider/income_statement_data_provider.dart';
import 'package:courier_app/features/income_statement/data/model/income_statement_model.dart';

class IncomeStatementRepository {
  final IncomeStatementDataProvider incomeStatementDataProvider;

  IncomeStatementRepository({required this.incomeStatementDataProvider});

  Future<IncomeStatementModel> fetchIncomeStatement(
      int branchId, String fromDate, String toDate) async {
    try {
      final response = await incomeStatementDataProvider.fetchIncomeStatement(
          branchId, fromDate, toDate);
      final data = jsonDecode(response);
      
      // Check if response has status wrapper or is direct data
      if (data.containsKey('status')) {
        if (data['status'] != 200) {
          throw data['message'] ?? 'Failed to fetch income statement';
        }
        return IncomeStatementModel.fromMap(data['data'] as Map<String, dynamic>);
      } else {
        // Direct data response (no status wrapper)
        return IncomeStatementModel.fromMap(data as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error in fetchIncomeStatement: ${e.toString()}');
      throw e.toString();
    }
  }
}

