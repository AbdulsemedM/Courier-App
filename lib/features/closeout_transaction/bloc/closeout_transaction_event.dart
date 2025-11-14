part of 'closeout_transaction_bloc.dart';

@immutable
sealed class CloseoutTransactionEvent {}

class FetchCloseoutTransactions extends CloseoutTransactionEvent {
  final int tellerId;
  final String startDate;
  final String endDate;

  FetchCloseoutTransactions({
    required this.tellerId,
    required this.startDate,
    required this.endDate,
  });
}

