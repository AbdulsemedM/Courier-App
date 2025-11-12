part of 'income_statement_bloc.dart';

@immutable
sealed class IncomeStatementState {}

final class IncomeStatementInitial extends IncomeStatementState {}

final class FetchIncomeStatementLoading extends IncomeStatementState {}

final class FetchIncomeStatementSuccess extends IncomeStatementState {
  final IncomeStatementModel incomeStatement;

  FetchIncomeStatementSuccess({required this.incomeStatement});
}

final class FetchIncomeStatementError extends IncomeStatementState {
  final String message;

  FetchIncomeStatementError({required this.message});
}

