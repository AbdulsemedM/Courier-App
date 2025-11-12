import 'dart:convert';
import 'package:courier_app/features/teller_by_branch/data/data_provider/teller_by_branch_data_provider.dart';
import 'package:courier_app/features/teller_by_branch/data/model/teller_by_branch_model.dart';

class TellerByBranchRepository {
  final TellerByBranchDataProvider tellerByBranchDataProvider;

  TellerByBranchRepository({required this.tellerByBranchDataProvider});

  Future<List<TellerByBranchModel>> fetchTellersByBranch(int branchId) async {
    try {
      final response = await tellerByBranchDataProvider.fetchTellersByBranch(branchId);
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'] ?? 'Failed to fetch tellers by branch';
      }
      if (data['data'] is List) {
        final tellers = (data['data'] as List)
            .map((teller) => TellerByBranchModel.fromMap(teller))
            .toList();
        return tellers;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }

  Future<TellerAccountStatus> fetchTellerAccountStatus(int tellerId) async {
    try {
      final response = await tellerByBranchDataProvider.fetchTellerAccountStatus(tellerId);
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'] ?? 'Failed to fetch teller account status';
      }
      return TellerAccountStatus.fromMap(data['data'] as Map<String, dynamic>);
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }

  Future<List<TellerByBranchWithStatus>> fetchTellersWithStatus(int branchId) async {
    try {
      // First fetch all tellers for the branch
      final tellers = await fetchTellersByBranch(branchId);
      
      // Then fetch account status for each teller
      final List<TellerByBranchWithStatus> tellersWithStatus = [];
      
      for (var teller in tellers) {
        try {
          final accountStatus = await fetchTellerAccountStatus(teller.id);
          tellersWithStatus.add(TellerByBranchWithStatus(
            teller: teller,
            accountStatus: accountStatus,
          ));
        } catch (e) {
          // If status fetch fails for one teller, still add the teller without status
          print('Failed to fetch status for teller ${teller.id}: $e');
          tellersWithStatus.add(TellerByBranchWithStatus(
            teller: teller,
            accountStatus: null,
          ));
        }
      }
      
      return tellersWithStatus;
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }
}

