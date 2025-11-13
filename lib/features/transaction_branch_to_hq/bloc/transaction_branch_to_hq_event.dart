part of 'transaction_branch_to_hq_bloc.dart';

@immutable
sealed class TransactionBranchToHqEvent {}

class FetchTransactions extends TransactionBranchToHqEvent {
  final int branchId;
  final String startDate;
  final String endDate;

  FetchTransactions({
    required this.branchId,
    required this.startDate,
    required this.endDate,
  });
}

