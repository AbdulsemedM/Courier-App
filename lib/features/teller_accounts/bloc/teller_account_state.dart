part of 'teller_account_bloc.dart';

@immutable
sealed class TellerAccountState {}

final class TellerAccountInitial extends TellerAccountState {}

final class FetchTellerAccountsLoading extends TellerAccountState {}

final class FetchTellerAccountsSuccess extends TellerAccountState {
  final List<TellerAccountModel> accounts;

  FetchTellerAccountsSuccess({required this.accounts});
}

final class FetchTellerAccountsError extends TellerAccountState {
  final String message;

  FetchTellerAccountsError({required this.message});
}

