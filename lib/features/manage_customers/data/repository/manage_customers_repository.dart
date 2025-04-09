import 'dart:convert';

import 'package:courier_app/features/manage_customers/data/data_provider/manage_customers_data_provider.dart';
import 'package:courier_app/features/manage_customers/model/customer_model.dart';

class ManageCustomersRepository {
  final ManageCustomersDataProvider _manageCustomersDataProvider =
      ManageCustomersDataProvider();

  ManageCustomersRepository(
      ManageCustomersDataProvider manageCustomersDataProvider);

  Future<List<CustomerModel>> fetchCustomers() async {
    try {
      final response = await _manageCustomersDataProvider.fetchCustomers();
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      if (data['data'] is List) {
        final customers = (data['data'] as List)
            .map((customer) => CustomerModel.fromMap(customer))
            .toList();
        return customers;
      } else {
        throw "Invalid response format: Expected a list";
      }
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }
  }

  Future<String> addCustomer(Map<String, dynamic> customer) async {
    try {
      final response = await _manageCustomersDataProvider.addCustomer(customer);
      final data = jsonDecode(response);
      if (data['status'] != 200) {
        throw data['message'];
      }
      return data['message'];
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String> updateCustomer(
      Map<String, dynamic> customer, String customerId) async {
    try {
      final response =
          await _manageCustomersDataProvider.updateCustomer(customer, customerId);
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
