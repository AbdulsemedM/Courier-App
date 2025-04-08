part of 'currency_bloc.dart';

@immutable
sealed class CurrencyEvent {}

class FetchCurrencies extends CurrencyEvent {}

class AddCurrency extends CurrencyEvent {
  final Map<String, dynamic> currency;
  AddCurrency(this.currency);
}
