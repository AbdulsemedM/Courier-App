part of 'payment_methods_bloc.dart';

@immutable
sealed class PaymentMethodsEvent {}

class FetchPaymentMethods extends PaymentMethodsEvent {}

class AddPaymentMethod extends PaymentMethodsEvent {
  final Map<String, dynamic> paymentMethod;

  AddPaymentMethod({required this.paymentMethod});
}