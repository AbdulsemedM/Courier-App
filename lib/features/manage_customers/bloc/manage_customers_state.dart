part of 'manage_customers_bloc.dart';

@immutable
sealed class ManageCustomersState {}

final class ManageCustomersInitial extends ManageCustomersState {}

final class FetchCustomersLoading extends ManageCustomersState {}

final class FetchCustomersSuccess extends ManageCustomersState {
  final List<CustomerModel> customers;
  FetchCustomersSuccess({required this.customers});
}

final class FetchCustomersError extends ManageCustomersState {
  final String error;
  FetchCustomersError({required this.error});
}

final class AddCustomerLoading extends ManageCustomersState {}

final class AddCustomerSuccess extends ManageCustomersState {
  final String message;
  AddCustomerSuccess({required this.message});
}

final class AddCustomerError extends ManageCustomersState {
  final String error;
  AddCustomerError({required this.error});
}

final class UpdateCustomerLoading extends ManageCustomersState {}

final class UpdateCustomerSuccess extends ManageCustomersState {
  final String message;
  UpdateCustomerSuccess({required this.message});
}

final class UpdateCustomerError extends ManageCustomersState {
  final String error;
  UpdateCustomerError({required this.error});
}
