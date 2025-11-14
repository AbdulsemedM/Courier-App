part of 'teller_liability_bloc.dart';

@immutable
sealed class TellerLiabilityEvent {}

class FetchTellerLiabilities extends TellerLiabilityEvent {}

