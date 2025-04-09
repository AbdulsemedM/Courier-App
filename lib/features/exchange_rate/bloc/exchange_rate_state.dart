part of 'exchange_rate_bloc.dart';

@immutable
sealed class ExchangeRateState {}

final class ExchangeRateInitial extends ExchangeRateState {}

final class FetchExchangeRatesLoading extends ExchangeRateState {}

final class FetchExchangeRatesSuccess extends ExchangeRateState {
  final List<ExchangeRateModel> exchangeRates;
  FetchExchangeRatesSuccess({required this.exchangeRates});
}

final class FetchExchangeRatesFailure extends ExchangeRateState {
  final String error;
  FetchExchangeRatesFailure({required this.error});
}

final class AddExchangeRateLoading extends ExchangeRateState {}

final class AddExchangeRateSuccess extends ExchangeRateState {
  final String message;
  AddExchangeRateSuccess({required this.message});
}

final class AddExchangeRateFailure extends ExchangeRateState {
  final String error;
  AddExchangeRateFailure({required this.error});
}
