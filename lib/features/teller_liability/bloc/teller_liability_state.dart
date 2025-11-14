part of 'teller_liability_bloc.dart';

@immutable
sealed class TellerLiabilityState {}

final class TellerLiabilityInitial extends TellerLiabilityState {}

final class TellerLiabilityLoading extends TellerLiabilityState {}

final class TellerLiabilityLoaded extends TellerLiabilityState {
  final TellerLiabilityModel liabilities;

  TellerLiabilityLoaded({required this.liabilities});
}

final class TellerLiabilityError extends TellerLiabilityState {
  final String message;

  TellerLiabilityError({required this.message});
}

