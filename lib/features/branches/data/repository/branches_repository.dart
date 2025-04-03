import 'dart:convert';

import 'package:courier_app/features/branches/data/data_provider/branches_data_provider.dart';
import 'package:courier_app/features/branches/model/branches_model.dart';
import 'package:courier_app/features/branches/model/country_model.dart';

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

  Future<List<CountryModel>> fetchCountry() async {
    try {
      final response = await branchesDataProvider.fetchCountry();
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final countries = (data['data'] as List)
            .map((country) => CountryModel.fromMap(country))
            .toList();
        return countries;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }

  Future<String> addBranch(Map<String, dynamic> body) async {
    try {
      final response = await branchesDataProvider.addBranch(body);
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      return data['message'];
    } catch (e) {
      throw e.toString();
    }
  }
}
