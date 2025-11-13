part of 'transaction_hq_to_branch_bloc.dart';

@immutable
sealed class TransactionHqToBranchEvent {}

class FetchTransactions extends TransactionHqToBranchEvent {
  final int branchId;
  final String startDate;
  final String endDate;

  FetchTransactions({
    required this.branchId,
    required this.startDate,
    required this.endDate,
  });
}

