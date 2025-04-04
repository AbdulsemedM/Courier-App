part of 'payment_methods_bloc.dart';

@immutable
sealed class PaymentMethodsState {}

final class PaymentMethodsInitial extends PaymentMethodsState {}

final class PaymentMethodsLoading extends PaymentMethodsState {}

final class PaymentMethodsLoaded extends PaymentMethodsState {
  final List<PaymentMethodModel> paymentMethods;

  PaymentMethodsLoaded({required this.paymentMethods});
}

final class PaymentMethodsError extends PaymentMethodsState {
  final String message;

  PaymentMethodsError({required this.message});
}

final class AddPaymentMethodLoading extends PaymentMethodsState {}

final class AddPaymentMethodLoaded extends PaymentMethodsState {
  final String message;

  AddPaymentMethodLoaded({required this.message});
}

final class AddPaymentMethodError extends PaymentMethodsState {
  final String message;

  AddPaymentMethodError({required this.message});
}
