part of 'teller_liability_by_branch_bloc.dart';

@immutable
sealed class TellerLiabilityByBranchEvent {}

class FetchTellerLiabilitiesByBranch extends TellerLiabilityByBranchEvent {
  final int branchId;

  FetchTellerLiabilitiesByBranch({required this.branchId});
}

