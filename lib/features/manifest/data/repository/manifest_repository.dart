import 'dart:convert';

import 'package:courier_app/features/manifest/data/data_provider/manifest_data_provider.dart';
import 'package:courier_app/features/manifest/data/model/manifest_model.dart';

class ManifestRepository {
  final ManifestDataProvider manifestDataProvider;

  ManifestRepository({required this.manifestDataProvider});

  Future<List<ManifestModel>> fetchManifests({
    required int branchId,
    required String date,
  }) async {
    try {
      final response = await manifestDataProvider.fetchManifests(
        branchId: branchId,
        date: date,
      );
      final data = jsonDecode(response) as Map<String, dynamic>;
      if (data['status'] != 200) {
        throw data['message'] ?? 'Failed to fetch manifests';
      }
      return ManifestListResponse.fromJson(data).data;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<ManifestModel> createManifest({
    required List<String> awbs,
    required String fileType,
    required int userId,
  }) async {
    try {
      final response = await manifestDataProvider.createManifest(
        awbs: awbs,
        fileType: fileType,
        userId: userId,
      );
      final data = jsonDecode(response) as Map<String, dynamic>;
      if (data['status'] != 200) {
        throw data['message'] ?? 'Failed to create manifest';
      }

      final list = ManifestListResponse.fromJson(data).data;
      if (list.isEmpty) {
        throw 'No manifest returned from server';
      }
      return list.first;
    } catch (e) {
      throw e.toString();
    }
  }
}
