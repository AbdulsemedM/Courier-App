import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class CloseoutTransactionDataProvider {
  Future<String> fetchCloseoutTransactions({
    required int tellerId,
    required String startDate,
    required String endDate,
  }) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final params = {
        'tellerId': tellerId.toString(),
        'startDate': startDate,
        'endDate': endDate,
      };
      final response = await apiProvider.getRequest(
        '/api/v1/transactions/teller',
        params: params,
      );
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}

