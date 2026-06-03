import 'package:courier_app/core/utils/api_json_decoder.dart';
import 'package:courier_app/features/messenger/data/data_provider/messenger_data_provider.dart';
import 'package:courier_app/features/messenger/data/model/messenger_model.dart';

class MessengerRepository {
  final MessengerDataProvider messengerDataProvider;

  MessengerRepository({required this.messengerDataProvider});

  Future<List<MessengerModel>> fetchMessengersByBranch(
    int branchId, {
    String? status,
  }) async {
    try {
      final response = await messengerDataProvider.fetchMessengersByBranch(
        branchId,
        status: status,
      );
      return _parseList(response);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<MessengerModel>> fetchAvailableMessengers(int branchId) async {
    try {
      final response =
          await messengerDataProvider.fetchAvailableMessengers(branchId);
      return _parseList(response);
    } catch (e) {
      throw e.toString();
    }
  }

  List<MessengerModel> _parseList(String response) {
    final data = decodeApiMap(response);
    if (data['status'] != 200) {
      throw data['message']?.toString() ?? 'Failed to load messengers';
    }
    final payload = data['data'];
    if (payload is! List) {
      return [];
    }
    return payload
        .whereType<Map>()
        .map((item) => MessengerModel.fromJson(
              Map<String, dynamic>.from(item),
            ))
        .toList();
  }
}
