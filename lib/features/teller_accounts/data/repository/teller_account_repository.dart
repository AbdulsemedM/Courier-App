import 'dart:convert';
import 'package:courier_app/features/teller_accounts/data/data_provider/teller_account_data_provider.dart';
import 'package:courier_app/features/teller_accounts/data/model/teller_account_model.dart';

class TellerAccountRepository {
  final TellerAccountDataProvider tellerAccountDataProvider;

  TellerAccountRepository({required this.tellerAccountDataProvider});

  Future<List<TellerAccountModel>> fetchTellerAccounts(String accountType) async {
    try {
      final response = await tellerAccountDataProvider.fetchTellerAccounts(accountType);
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'] ?? 'Failed to fetch teller accounts';
      }
      if (data['data'] is List) {
        final accounts = (data['data'] as List)
            .map((account) => TellerAccountModel.fromMap(account))
            .toList();
        return accounts;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }
}

