import 'dart:convert';

import 'package:courier_app/features/accounts/data/data_provider/account_data_provider.dart';
import 'package:courier_app/features/accounts/data/model/account_model.dart';

class AccountRepository {
  final AccountDataProvider accountDataProvider;

  AccountRepository({required this.accountDataProvider});

  Future<List<AccountModel>> fetchAccounts() async {
    try {
      final response = await accountDataProvider.fetchAccounts();
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final accounts = (data['data'] as List)
            .map((account) => AccountModel.fromMap(account))
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
