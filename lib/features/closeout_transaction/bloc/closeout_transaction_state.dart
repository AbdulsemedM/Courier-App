part of 'closeout_transaction_bloc.dart';

@immutable
sealed class CloseoutTransactionState {}

final class CloseoutTransactionInitial extends CloseoutTransactionState {}

final class CloseoutTransactionLoading extends CloseoutTransactionState {}

final class CloseoutTransactionLoaded extends CloseoutTransactionState {
  final CloseoutTransactionModel transactions;

  CloseoutTransactionLoaded({required this.transactions});
}

final class CloseoutTransactionError extends CloseoutTransactionState {
  final String message;

  CloseoutTransactionError({required this.message});
}

