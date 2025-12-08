part of 'admin_expenses_bloc.dart';

@immutable
sealed class AdminExpensesState {}

final class AdminExpensesInitial extends AdminExpensesState {}

final class AdminExpensesLoading extends AdminExpensesState {}

final class AdminExpensesLoaded extends AdminExpensesState {
  final List<BranchShipmentModel> shipments;

  AdminExpensesLoaded({required this.shipments});
}

final class AdminExpensesError extends AdminExpensesState {
  final String message;

  AdminExpensesError({required this.message});
}

