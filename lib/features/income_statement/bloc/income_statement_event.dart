part of 'income_statement_bloc.dart';

@immutable
sealed class IncomeStatementEvent {}

class FetchIncomeStatement extends IncomeStatementEvent {
  final int branchId;
  final String fromDate;
  final String toDate;

  FetchIncomeStatement({
    required this.branchId,
    required this.fromDate,
    required this.toDate,
  });
}

