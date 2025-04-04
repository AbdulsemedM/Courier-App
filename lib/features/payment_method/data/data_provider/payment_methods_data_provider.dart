import 'package:courier_app/configuration/api_constants.dart';
import 'package:courier_app/providers/provider_setup.dart';

class PaymentMethodsDataProvider {
  Future<String> fetchPaymentMethods() async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.getRequest("/api/v1/payment-methods");
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> addPaymentMethod(Map<String, dynamic> paymentMethod) async {
    try {
      final apiProvider = ProviderSetup.getApiProvider(ApiConstants.baseUrl);
      final response = await apiProvider.postRequest(
          "/api/v1/payment-method", paymentMethod);
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}
