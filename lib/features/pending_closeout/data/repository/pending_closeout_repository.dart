import 'dart:convert';
import 'package:courier_app/features/pending_closeout/data/data_provider/pending_closeout_data_provider.dart';
import 'package:courier_app/features/pending_closeout/data/model/pending_closeout_model.dart';

class PendingCloseoutRepository {
  final PendingCloseoutDataProvider dataProvider;

  PendingCloseoutRepository({required this.dataProvider});

  Future<PendingCloseoutModel> fetchPendingCloseouts({
    int? branchId,
  }) async {
    try {
      final response = await dataProvider.fetchPendingCloseouts(
        branchId: branchId,
      );
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'] ?? 'Failed to fetch pending closeouts';
      }
      return PendingCloseoutModel.fromMap(data);
    } catch (e) {
      print('Error in fetchPendingCloseouts: ${e.toString()}');
      throw e.toString();
    }
  }
}

