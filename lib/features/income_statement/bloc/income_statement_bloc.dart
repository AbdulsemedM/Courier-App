import 'package:courier_app/features/income_statement/data/model/income_statement_model.dart';
import 'package:courier_app/features/income_statement/data/repository/income_statement_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'income_statement_event.dart';
part 'income_statement_state.dart';

class IncomeStatementBloc
    extends Bloc<IncomeStatementEvent, IncomeStatementState> {
  final IncomeStatementRepository incomeStatementRepository;

  IncomeStatementBloc(this.incomeStatementRepository)
      : super(IncomeStatementInitial()) {
    on<FetchIncomeStatement>(_fetchIncomeStatement);
  }

  void _fetchIncomeStatement(FetchIncomeStatement event,
      Emitter<IncomeStatementState> emit) async {
    emit(FetchIncomeStatementLoading());
    try {
      final incomeStatement = await incomeStatementRepository.fetchIncomeStatement(
        event.branchId,
        event.fromDate,
        event.toDate,
      );
      emit(FetchIncomeStatementSuccess(incomeStatement: incomeStatement));
    } catch (e) {
      emit(FetchIncomeStatementError(message: e.toString()));
    }
  }
}

