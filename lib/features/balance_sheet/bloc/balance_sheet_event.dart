part of 'balance_sheet_bloc.dart';

@immutable
sealed class BalanceSheetEvent {}

class FetchBalanceSheet extends BalanceSheetEvent {
  final int branchId;
  final String asOfDate;

  FetchBalanceSheet({
    required this.branchId,
    required this.asOfDate,
  });
}

