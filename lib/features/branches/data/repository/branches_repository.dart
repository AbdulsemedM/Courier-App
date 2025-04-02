import 'dart:convert';

import 'package:courier_app/features/branches/data/data_provider/branches_data_provider.dart';
import 'package:courier_app/features/branches/model/branches_model.dart';

class BranchesRepository {
  final BranchesDataProvider branchesDataProvider;

  BranchesRepository({required this.branchesDataProvider});

  Future<List<BranchesModel>> fetchBranches() async {
    try {
      final response = await branchesDataProvider.fetchBranches();
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final branches = (data['data'] as List)
            .map((branch) => BranchesModel.fromMap(branch))
            .toList();
        return branches;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
