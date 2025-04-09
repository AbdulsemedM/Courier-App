part of 'manage_customers_bloc.dart';

@immutable
sealed class ManageCustomersEvent {}

class FetchCustomersEvent extends ManageCustomersEvent {}

class AddCustomerEvent extends ManageCustomersEvent {
  final Map<String, dynamic> customer;
  AddCustomerEvent({required this.customer});
}

class UpdateCustomerEvent extends ManageCustomersEvent {
  final Map<String, dynamic> customer;
  final String customerId;
  UpdateCustomerEvent({required this.customer, required this.customerId});
}
