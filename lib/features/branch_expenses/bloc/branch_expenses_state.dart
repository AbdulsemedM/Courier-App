part of 'branch_expenses_bloc.dart';

@immutable
sealed class BranchExpensesState {}

final class BranchExpensesInitial extends BranchExpensesState {}

final class BranchExpensesLoading extends BranchExpensesState {}

final class BranchExpensesLoaded extends BranchExpensesState {
  final List<BranchShipmentModel> shipments;

  BranchExpensesLoaded({required this.shipments});
}

final class BranchExpensesError extends BranchExpensesState {
  final String message;

  BranchExpensesError({required this.message});
}

