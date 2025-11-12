part of 'teller_account_bloc.dart';

@immutable
sealed class TellerAccountEvent {}

class FetchTellerAccounts extends TellerAccountEvent {
  final String accountType;

  FetchTellerAccounts({required this.accountType});
}

