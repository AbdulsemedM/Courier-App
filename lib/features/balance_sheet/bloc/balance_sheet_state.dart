part of 'balance_sheet_bloc.dart';

@immutable
sealed class BalanceSheetState {}

final class BalanceSheetInitial extends BalanceSheetState {}

final class FetchBalanceSheetLoading extends BalanceSheetState {}

final class FetchBalanceSheetSuccess extends BalanceSheetState {
  final BalanceSheetModel balanceSheet;

  FetchBalanceSheetSuccess({required this.balanceSheet});
}

final class FetchBalanceSheetError extends BalanceSheetState {
  final String message;

  FetchBalanceSheetError({required this.message});
}

