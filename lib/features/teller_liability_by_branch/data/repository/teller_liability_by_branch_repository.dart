import 'dart:convert';
import 'package:courier_app/features/teller_liability_by_branch/data/data_provider/teller_liability_by_branch_data_provider.dart';
import 'package:courier_app/features/teller_liability/data/model/teller_liability_model.dart';

class TellerLiabilityByBranchRepository {
  final TellerLiabilityByBranchDataProvider dataProvider;

  TellerLiabilityByBranchRepository({required this.dataProvider});

  Future<TellerLiabilityModel> fetchTellerLiabilitiesByBranch({
    required int branchId,
  }) async {
    try {
      final response = await dataProvider.fetchTellerLiabilitiesByBranch(
        branchId: branchId,
      );
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'] ?? 'Failed to fetch teller liabilities by branch';
      }
      return TellerLiabilityModel.fromMap(data);
    } catch (e) {
      print('Error in fetchTellerLiabilitiesByBranch: ${e.toString()}');
      throw e.toString();
    }
  }
}

