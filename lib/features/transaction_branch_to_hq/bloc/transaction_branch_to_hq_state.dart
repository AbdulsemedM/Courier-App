part of 'transaction_branch_to_hq_bloc.dart';

@immutable
sealed class TransactionBranchToHqState {}

final class TransactionBranchToHqInitial extends TransactionBranchToHqState {}

final class FetchTransactionsLoading extends TransactionBranchToHqState {}

final class FetchTransactionsSuccess extends TransactionBranchToHqState {
  final TransactionBranchToHqModel transactions;

  FetchTransactionsSuccess({required this.transactions});
}

final class FetchTransactionsError extends TransactionBranchToHqState {
  final String message;

  FetchTransactionsError({required this.message});
}

