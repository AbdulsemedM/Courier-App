part of 'branch_expenses_bloc.dart';

@immutable
sealed class BranchExpensesEvent {}

class FetchBranchExpenses extends BranchExpensesEvent {
  final int branchId;
  final String fromDate;
  final String toDate;

  FetchBranchExpenses({
    required this.branchId,
    required this.fromDate,
    required this.toDate,
  });
}

