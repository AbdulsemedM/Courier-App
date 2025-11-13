part of 'teller_by_branch_bloc.dart';

@immutable
sealed class TellerByBranchState {}

final class TellerByBranchInitial extends TellerByBranchState {}

final class FetchTellersByBranchLoading extends TellerByBranchState {}

final class FetchTellersByBranchSuccess extends TellerByBranchState {
  final List<TellerByBranchWithStatus> tellers;

  FetchTellersByBranchSuccess({required this.tellers});
}

final class FetchTellersByBranchError extends TellerByBranchState {
  final String message;

  FetchTellersByBranchError({required this.message});
}

final class ReopenTellerLoading extends TellerByBranchState {}

final class ReopenTellerSuccess extends TellerByBranchState {
  final String message;

  ReopenTellerSuccess({required this.message});
}

final class ReopenTellerError extends TellerByBranchState {
  final String message;

  ReopenTellerError({required this.message});
}

