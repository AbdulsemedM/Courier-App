import 'package:courier_app/features/payment_method/data/repository/payment_methods_repository.dart';
import 'package:courier_app/features/payment_method/models/payemnt_methods_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
part 'payment_methods_event.dart';
part 'payment_methods_state.dart';

class PaymentMethodsBloc
    extends Bloc<PaymentMethodsEvent, PaymentMethodsState> {
  final PaymentMethodsRepository paymentMethodsRepository;
  PaymentMethodsBloc(this.paymentMethodsRepository)
      : super(PaymentMethodsInitial()) {
    on<FetchPaymentMethods>(_fetchPaymentMethods);
    on<AddPaymentMethod>(_addPaymentMethod);
  }
  void _fetchPaymentMethods(
      FetchPaymentMethods event, Emitter<PaymentMethodsState> emit) async {
    emit(PaymentMethodsLoading());
    try {
      final paymentMethods =
          await paymentMethodsRepository.fetchPaymentMethods();
      emit(PaymentMethodsLoaded(paymentMethods: paymentMethods));
    } catch (e) {
      emit(PaymentMethodsError(message: e.toString()));
    }
  }

  void _addPaymentMethod(
      AddPaymentMethod event, Emitter<PaymentMethodsState> emit) async {
    emit(AddPaymentMethodLoading());
    try {
      final paymentMethod =
          await paymentMethodsRepository.addPaymentMethod(event.paymentMethod);
      emit(AddPaymentMethodLoaded(message: paymentMethod));
    } catch (e) {
      emit(AddPaymentMethodError(message: e.toString()));
    }
  }
}
