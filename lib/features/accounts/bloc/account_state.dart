part of 'account_bloc.dart';

@immutable
sealed class AccountState {}

final class AccountInitial extends AccountState {}

final class FetchAccountsLoading extends AccountState {}

final class FetchAccountsSuccess extends AccountState {
  final List<AccountModel> accounts;

  FetchAccountsSuccess({required this.accounts});
}

final class FetchAccountsError extends AccountState {
  final String message;

  FetchAccountsError({required this.message});
}
