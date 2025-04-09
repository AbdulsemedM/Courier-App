part of 'exchange_rate_bloc.dart';

@immutable
sealed class ExchangeRateEvent {}

class FetchExchangeRates extends ExchangeRateEvent {}

class AddExchangeRate extends ExchangeRateEvent {
  final Map<String, dynamic> exchangeRate;
  AddExchangeRate({required this.exchangeRate});
}
