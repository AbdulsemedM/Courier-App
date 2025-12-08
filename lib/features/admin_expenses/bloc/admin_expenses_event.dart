part of 'admin_expenses_bloc.dart';

@immutable
sealed class AdminExpensesEvent {}

class FetchAdminExpenses extends AdminExpensesEvent {
  final int branchId;
  final String fromDate;
  final String toDate;

  FetchAdminExpenses({
    required this.branchId,
    required this.fromDate,
    required this.toDate,
  });
}

