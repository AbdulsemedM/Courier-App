import 'dart:convert';

import 'package:courier_app/core/utils/api_json_decoder.dart';
import 'package:courier_app/features/manifest/data/data_provider/manifest_data_provider.dart';
import 'package:courier_app/features/manifest/data/manifest_awb_loader.dart';
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

  Future<List<String>> resolveManifestAwbs(ManifestModel manifest) async {
    if (manifest.awbList.isNotEmpty) {
      return manifest.awbList;
    }

    final downloadUrl = manifest.downloadUrl;
    if (downloadUrl == null || downloadUrl.isEmpty) {
      return const [];
    }

    try {
      return await ManifestAwbLoader.loadFromDownloadUrl(downloadUrl);
    } catch (_) {
      return const [];
    }
  }

  Future<String> createManifest({
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
      return data['message']?.toString() ?? 'Manifest created successfully';
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> updateManifest({
    required int manifestId,
    required List<String> awbs,
    required String fileType,
    required int userId,
  }) async {
    try {
      final response = await manifestDataProvider.updateManifest(
        manifestId: manifestId,
        awbs: awbs,
        fileType: fileType,
        userId: userId,
      );
      final data = decodeApiMap(response);
      if (data['status'] != 200) {
        throw data['message'] ?? 'Failed to update manifest';
      }
      return data['message']?.toString() ?? 'Manifest updated successfully';
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> removeAwbFromManifest({
    required int manifestId,
    required String awb,
  }) async {
    try {
      final response = await manifestDataProvider.removeAwbFromManifest(
        manifestId: manifestId,
        awb: awb,
      );
      final data = decodeApiMap(response);
      if (data['status'] != 200) {
        throw data['message'] ?? 'Failed to remove AWB from manifest';
      }
      return data['message']?.toString() ?? 'AWB removed from manifest successfully';
    } catch (e) {
      throw e.toString();
    }
  }
}
