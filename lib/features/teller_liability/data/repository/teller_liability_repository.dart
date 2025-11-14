import 'dart:convert';
import 'package:courier_app/features/teller_liability/data/data_provider/teller_liability_data_provider.dart';
import 'package:courier_app/features/teller_liability/data/model/teller_liability_model.dart';

class TellerLiabilityRepository {
  final TellerLiabilityDataProvider dataProvider;

  TellerLiabilityRepository({required this.dataProvider});

  Future<TellerLiabilityModel> fetchTellerLiabilities() async {
    try {
      final response = await dataProvider.fetchTellerLiabilities();
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'] ?? 'Failed to fetch teller liabilities';
      }
      return TellerLiabilityModel.fromMap(data);
    } catch (e) {
      print('Error in fetchTellerLiabilities: ${e.toString()}');
      throw e.toString();
    }
  }
}

