part of 'teller_by_branch_bloc.dart';

@immutable
sealed class TellerByBranchEvent {}

class FetchTellersByBranch extends TellerByBranchEvent {
  final int branchId;

  FetchTellersByBranch({required this.branchId});
}

