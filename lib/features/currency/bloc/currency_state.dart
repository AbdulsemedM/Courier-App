part of 'currency_bloc.dart';

@immutable
sealed class CurrencyState {}

final class CurrencyInitial extends CurrencyState {}

final class FetchCurrencyLoading extends CurrencyState {}

final class FetchCurrencySuccess extends CurrencyState {
  final List<CurrencyModel> currencies;
  FetchCurrencySuccess(this.currencies);
}

final class FetchCurrencyFailure extends CurrencyState {
  final String message;
  FetchCurrencyFailure(this.message);
}

final class AddCurrencyLoading extends CurrencyState {}

final class AddCurrencySuccess extends CurrencyState {
  final String message;
  AddCurrencySuccess(this.message);
}

final class AddCurrencyFailure extends CurrencyState {
  final String message;
  AddCurrencyFailure(this.message);
}
