part of 'account_bloc.dart';

@immutable
sealed class AccountEvent {}

class FetchAccounts extends AccountEvent {}
