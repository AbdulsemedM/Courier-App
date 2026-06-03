import 'package:courier_app/core/utils/api_json_decoder.dart';
import 'package:courier_app/features/home_delivery/data/data_provider/home_delivery_data_provider.dart';
import 'package:courier_app/features/home_delivery/data/model/home_delivery_model.dart';

enum HomeDeliveryView { all, unassigned, overdue }

class HomeDeliveryRepository {
  final HomeDeliveryDataProvider homeDeliveryDataProvider;

  HomeDeliveryRepository({required this.homeDeliveryDataProvider});

  Future<List<HomeDeliveryModel>> fetchDeliveries({
    required int branchId,
    required HomeDeliveryView view,
    String? status,
  }) async {
    try {
      final String response;
      switch (view) {
        case HomeDeliveryView.unassigned:
          response = await homeDeliveryDataProvider.fetchUnassigned(branchId);
          break;
        case HomeDeliveryView.overdue:
          response = await homeDeliveryDataProvider.fetchOverdue(branchId);
          break;
        case HomeDeliveryView.all:
          response = await homeDeliveryDataProvider.fetchByBranch(
            branchId,
            status: status,
          );
          break;
      }
      return _parseList(response);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> assignMessenger({
    required String awb,
    required int messengerId,
    required int assignedBy,
    required String estimatedDeliveryTime,
  }) async {
    try {
      final response = await homeDeliveryDataProvider.assignMessenger(
        awb: awb,
        messengerId: messengerId,
        assignedBy: assignedBy,
        estimatedDeliveryTime: estimatedDeliveryTime,
      );
      final data = decodeApiMap(response);
      if (data['status'] != 200) {
        throw data['message']?.toString() ?? 'Failed to assign messenger';
      }
      return data['message']?.toString() ?? 'Messenger assigned successfully';
    } catch (e) {
      throw e.toString();
    }
  }

  List<HomeDeliveryModel> _parseList(String response) {
    final data = decodeApiMap(response);
    if (data['status'] != 200) {
      throw data['message']?.toString() ?? 'Failed to load home deliveries';
    }
    final payload = data['data'];
    if (payload is! List) {
      return [];
    }
    return payload
        .whereType<Map>()
        .map((item) => HomeDeliveryModel.fromJson(
              Map<String, dynamic>.from(item),
            ))
        .toList();
  }
}
