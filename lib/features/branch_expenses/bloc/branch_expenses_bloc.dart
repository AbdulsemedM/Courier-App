import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:courier_app/features/branch_expenses/data/repository/branch_expenses_repository.dart';
import 'package:courier_app/features/branch_report/data/model/branch_shipment_model.dart';

part 'branch_expenses_event.dart';
part 'branch_expenses_state.dart';

class BranchExpensesBloc extends Bloc<BranchExpensesEvent, BranchExpensesState> {
  final BranchExpensesRepository repository;

  BranchExpensesBloc({required this.repository}) : super(BranchExpensesInitial()) {
    on<FetchBranchExpenses>(_onFetchBranchExpenses);
  }

  Future<void> _onFetchBranchExpenses(
    FetchBranchExpenses event,
    Emitter<BranchExpensesState> emit,
  ) async {
    emit(BranchExpensesLoading());
    try {
      final shipments = await repository.fetchBranchExpenses(
        branchId: event.branchId,
        fromDate: event.fromDate,
        toDate: event.toDate,
      );
      emit(BranchExpensesLoaded(shipments: shipments));
    } catch (e) {
      emit(BranchExpensesError(message: e.toString()));
    }
  }
}

