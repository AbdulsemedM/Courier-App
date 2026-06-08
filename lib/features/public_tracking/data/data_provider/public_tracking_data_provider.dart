import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class PublicTrackingDataProvider {
  Future<String> trackByAwb(String awb) async {
    return _fetch(params: {'awb': awb.trim()});
  }

  Future<String> trackByPhone(String fullPhone) async {
    return _fetch(params: {'phone': fullPhone.trim()});
  }

  Future<String> trackByQuery(String query) async {
    return _fetch(params: {'query': query.trim()});
  }

  Future<String> _fetch({required Map<String, String> params}) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest(
        ApiEndpoints.publicTracking,
        params: params,
      );
      return response.body;
    } catch (e) {
      final message = e.toString();
      if (message.contains('403') || message.contains('Forbidden')) {
        throw 'Public tracking is not available right now. '
            'The server rejected this request — please ask your administrator '
            'to enable anonymous access to /api/v1/public/tracking.';
      }
      throw message.replaceFirst('Exception: ', '');
    }
  }
}
