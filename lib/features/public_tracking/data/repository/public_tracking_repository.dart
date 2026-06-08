import 'dart:convert';

import 'package:courier_app/features/public_tracking/data/data_provider/public_tracking_data_provider.dart';
import 'package:courier_app/features/public_tracking/model/public_tracking_models.dart';

class PublicTrackingRepository {
  final PublicTrackingDataProvider dataProvider;

  PublicTrackingRepository(this.dataProvider);

  Future<PublicTrackingResult> trackByAwb(String awb) async {
    final trimmed = awb.trim();
    if (trimmed.isEmpty) {
      throw 'Please enter an AWB or tracking number';
    }

    final useQuery = trimmed.length < 5;
    final response = useQuery
        ? await dataProvider.trackByQuery(trimmed)
        : await dataProvider.trackByAwb(trimmed);
    return _parseResponse(response);
  }

  Future<PublicTrackingResult> trackByPhone(
    String countryDialCode,
    String localNumber,
  ) async {
    final fullPhone = buildFullPhone(countryDialCode, localNumber);
    if (fullPhone.length < 10) {
      throw 'Please enter a valid phone number';
    }

    final response = await dataProvider.trackByPhone(fullPhone);
    return _parseResponse(response);
  }

  PublicTrackingResult _parseResponse(String response) {
    final data = jsonDecode(response);
    if (data['status'] != 200) {
      throw data['message']?.toString() ?? 'Unable to find shipment';
    }

    if (data['data'] is! List) {
      throw 'Invalid response format';
    }

    final items = data['data'] as List;
    if (items.isEmpty) {
      throw 'No shipments found';
    }

    final maps = items.whereType<Map<String, dynamic>>().toList();
    if (maps.isEmpty) {
      throw 'No shipments found';
    }

    final summaries = maps
        .map(PublicShipmentSummary.fromMap)
        .where((s) => s.awb.isNotEmpty)
        .toList();

    final uniqueAwbs = summaries.map((s) => s.awb).toSet();

    if (uniqueAwbs.length > 1) {
      return PublicTrackingResult.multiple(summaries);
    }

    final events = maps.map(PublicTrackingTimelineItem.fromMap).toList();
    final looksLikeTimeline = maps.any(
      (m) => m.containsKey('description') || m.containsKey('status'),
    );

    if (looksLikeTimeline && events.isNotEmpty) {
      return PublicTrackingResult.single(events);
    }

    if (summaries.isNotEmpty) {
      return PublicTrackingResult.multiple(summaries);
    }

    if (events.isNotEmpty) {
      return PublicTrackingResult.single(events);
    }

    throw 'No shipments found';
  }
}
