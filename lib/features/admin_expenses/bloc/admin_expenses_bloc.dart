import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:courier_app/features/admin_expenses/data/repository/admin_expenses_repository.dart';
import 'package:courier_app/features/branch_report/data/model/branch_shipment_model.dart';

part 'admin_expenses_event.dart';
part 'admin_expenses_state.dart';

class AdminExpensesBloc extends Bloc<AdminExpensesEvent, AdminExpensesState> {
  final AdminExpensesRepository repository;

  AdminExpensesBloc({required this.repository}) : super(AdminExpensesInitial()) {
    on<FetchAdminExpenses>(_onFetchAdminExpenses);
  }

  Future<void> _onFetchAdminExpenses(
    FetchAdminExpenses event,
    Emitter<AdminExpensesState> emit,
  ) async {
    emit(AdminExpensesLoading());
    try {
      final shipments = await repository.fetchAdminExpenses(
        branchId: event.branchId,
        fromDate: event.fromDate,
        toDate: event.toDate,
      );
      emit(AdminExpensesLoaded(shipments: shipments));
    } catch (e) {
      emit(AdminExpensesError(message: e.toString()));
    }
  }
}

