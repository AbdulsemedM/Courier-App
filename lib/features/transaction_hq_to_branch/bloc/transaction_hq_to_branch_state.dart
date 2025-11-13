part of 'transaction_hq_to_branch_bloc.dart';

@immutable
sealed class TransactionHqToBranchState {}

final class TransactionHqToBranchInitial extends TransactionHqToBranchState {}

final class FetchTransactionsLoading extends TransactionHqToBranchState {}

final class FetchTransactionsSuccess extends TransactionHqToBranchState {
  final TransactionHqToBranchModel transactions;

  FetchTransactionsSuccess({required this.transactions});
}

final class FetchTransactionsError extends TransactionHqToBranchState {
  final String message;

  FetchTransactionsError({required this.message});
}

