import 'dart:convert';

import 'package:courier_app/features/services_mode/data/data_provider/services_mode_data_provider.dart';
import 'package:courier_app/features/services_mode/models/services_mode_models.dart';

class ServicesModeRepository {
  final ServicesModeDataProvider _servicesModeDataProvider =
      ServicesModeDataProvider();

  ServicesModeRepository(ServicesModeDataProvider servicesModeDataProvider);

  Future<List<ServicesModeModels>> fetchServicesMode() async {
    try {
      final response = await _servicesModeDataProvider.fetchServicesMode();
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final servicesMode = (data['data'] as List)
            .map((servicesMode) => ServicesModeModels.fromMap(servicesMode))
            .toList();
        return servicesMode;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }

  Future<String> addServicesMode(Map<String, dynamic> servicesMode) async {
    try {
      final response =
          await _servicesModeDataProvider.addServicesMode(servicesMode);
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
