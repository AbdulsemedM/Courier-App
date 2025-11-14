part of 'teller_liability_by_branch_bloc.dart';

@immutable
sealed class TellerLiabilityByBranchState {}

final class TellerLiabilityByBranchInitial extends TellerLiabilityByBranchState {}

final class TellerLiabilityByBranchLoading extends TellerLiabilityByBranchState {}

final class TellerLiabilityByBranchLoaded extends TellerLiabilityByBranchState {
  final TellerLiabilityModel liabilities;

  TellerLiabilityByBranchLoaded({required this.liabilities});
}

final class TellerLiabilityByBranchError extends TellerLiabilityByBranchState {
  final String message;

  TellerLiabilityByBranchError({required this.message});
}

