import 'dart:convert';

import 'package:courier_app/features/miles_configuration/data/data_provider/miles_configuration_data_provider.dart';
import 'package:courier_app/features/miles_configuration/models/miles_configuration_model.dart';

class MilesConfigurationRepository {
  final MilesConfigurationDataProvider milesConfigurationDataProvider;
  MilesConfigurationRepository(this.milesConfigurationDataProvider);
  Future<List<MilesConfigurationModel>> getMilesConfiguration() async {
    try {
      final response =
          await milesConfigurationDataProvider.getMilesConfiguration();
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final milesConfigurations = (data['data'] as List)
            .map((order) => MilesConfigurationModel.fromMap(order))
            .toList();
        return milesConfigurations;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<String> addMilesConfiguration(int originBranchId,
      int destinationBranchId, String unit, int milesPerUnit) async {
    try {
      final response =
          await milesConfigurationDataProvider.addMilesConfiguration(
              originBranchId, destinationBranchId, unit, milesPerUnit);
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      return data['message'];
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
