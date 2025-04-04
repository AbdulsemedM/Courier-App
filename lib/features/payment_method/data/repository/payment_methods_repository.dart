import 'dart:convert';

import 'package:courier_app/features/payment_method/data/data_provider/payment_methods_data_provider.dart';
import 'package:courier_app/features/payment_method/models/payemnt_methods_model.dart';

class PaymentMethodsRepository {
  final PaymentMethodsDataProvider _paymentMethodsDataProvider =
      PaymentMethodsDataProvider();

  PaymentMethodsRepository(
      PaymentMethodsDataProvider paymentMethodsDataProvider);

  Future<List<PaymentMethodModel>> fetchPaymentMethods() async {
    try {
      final response = await _paymentMethodsDataProvider.fetchPaymentMethods();
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final paymentMethods = (data['data'] as List)
            .map((paymentMethod) => PaymentMethodModel.fromMap(paymentMethod))
            .toList();
        return paymentMethods;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }

  Future<String> addPaymentMethod(Map<String, dynamic> paymentMethod) async {
    try {
      final response =
          await _paymentMethodsDataProvider.addPaymentMethod(paymentMethod);
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      return data['message'];
    } catch (e) {
      throw e.toString();
    }
  }
}
