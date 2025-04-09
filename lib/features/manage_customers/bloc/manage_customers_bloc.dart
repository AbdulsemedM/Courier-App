import 'package:courier_app/features/manage_customers/data/repository/manage_customers_repository.dart';
import 'package:courier_app/features/manage_customers/model/customer_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
part 'manage_customers_event.dart';
part 'manage_customers_state.dart';

class ManageCustomersBloc
    extends Bloc<ManageCustomersEvent, ManageCustomersState> {
  final ManageCustomersRepository manageCustomersRepository;
  ManageCustomersBloc(this.manageCustomersRepository)
      : super(ManageCustomersInitial()) {
    on<FetchCustomersEvent>(_fetchCustomers);
    on<AddCustomerEvent>(_addCustomer);
    on<UpdateCustomerEvent>(_updateCustomer);
  }

  void _fetchCustomers(
      FetchCustomersEvent event, Emitter<ManageCustomersState> emit) async {
    emit(FetchCustomersLoading());
    try {
      final customers = await manageCustomersRepository.fetchCustomers();
      emit(FetchCustomersSuccess(customers: customers));
    } catch (e) {
      emit(FetchCustomersError(error: e.toString()));
    }
  }

  void _addCustomer(
      AddCustomerEvent event, Emitter<ManageCustomersState> emit) async {
    emit(AddCustomerLoading());
    try {
      final message =
          await manageCustomersRepository.addCustomer(event.customer);
      emit(AddCustomerSuccess(message: message));
    } catch (e) {
      emit(AddCustomerError(error: e.toString()));
    }
  }

  void _updateCustomer(
      UpdateCustomerEvent event, Emitter<ManageCustomersState> emit) async {
    emit(UpdateCustomerLoading());
    try {
      final message = await manageCustomersRepository.updateCustomer(
          event.customer, event.customerId);
      emit(UpdateCustomerSuccess(message: message));
    } catch (e) {
      emit(UpdateCustomerError(error: e.toString()));
    }
  }
}
