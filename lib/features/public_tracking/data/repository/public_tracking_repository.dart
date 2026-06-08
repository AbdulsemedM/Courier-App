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
    final decoded = jsonDecode(response);
    if (decoded is! Map<String, dynamic>) {
      throw 'Invalid response format';
    }

    if (decoded['status'] != 200) {
      throw decoded['message']?.toString() ?? 'Unable to find shipment';
    }

    final rawData = decoded['data'];
    if (rawData == null) {
      throw 'No shipments found';
    }

    if (rawData is Map<String, dynamic>) {
      return _parseSingleShipment(rawData);
    }

    if (rawData is List) {
      return _parseShipmentList(rawData);
    }

    throw 'Invalid response format';
  }

  PublicTrackingResult _parseSingleShipment(Map<String, dynamic> shipment) {
    final events = timelineEventsFromShipment(shipment);
    if (events.isEmpty) {
      throw 'No shipments found';
    }
    return PublicTrackingResult.single(events);
  }

  PublicTrackingResult _parseShipmentList(List<dynamic> items) {
    if (items.isEmpty) {
      throw 'No shipments found';
    }

    final maps = items.whereType<Map<String, dynamic>>().toList();
    if (maps.isEmpty) {
      throw 'No shipments found';
    }

    if (maps.length == 1) {
      final shipment = maps.first;
      final history = shipment['history'];
      if (history is List && history.isNotEmpty) {
        return _parseSingleShipment(shipment);
      }
    }

    final summaries = maps
        .map(PublicShipmentSummary.fromMap)
        .where((s) => s.awb.isNotEmpty)
        .toList();

    if (summaries.isEmpty) {
      throw 'No shipments found';
    }

    if (summaries.length == 1) {
      final shipment = maps.firstWhere((m) => m['awb']?.toString() == summaries.first.awb);
      final history = shipment['history'];
      if (history is List && history.isNotEmpty) {
        return _parseSingleShipment(shipment);
      }
    }

    return PublicTrackingResult.multiple(summaries);
  }
}
