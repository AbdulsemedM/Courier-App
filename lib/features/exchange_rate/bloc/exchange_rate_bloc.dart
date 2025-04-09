import 'package:courier_app/features/exchange_rate/data/repository/exchange_rate_repository.dart';
import 'package:courier_app/features/exchange_rate/model/exchange_rate_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'exchange_rate_event.dart';
part 'exchange_rate_state.dart';

class ExchangeRateBloc extends Bloc<ExchangeRateEvent, ExchangeRateState> {
  final ExchangeRateRepository exchangeRateRepository;
  ExchangeRateBloc(this.exchangeRateRepository) : super(ExchangeRateInitial()) {
    on<FetchExchangeRates>(_fetchExchangeRates);
    on<AddExchangeRate>(_addExchangeRate);
  }

  Future<void> _fetchExchangeRates(
      FetchExchangeRates event, Emitter<ExchangeRateState> emit) async {
    emit(FetchExchangeRatesLoading());
    try {
      final exchangeRates = await exchangeRateRepository.fetchExchangeRates();
      emit(FetchExchangeRatesSuccess(exchangeRates: exchangeRates));
    } catch (e) {
      emit(FetchExchangeRatesFailure(error: e.toString()));
    }
  }

  Future<void> _addExchangeRate(
      AddExchangeRate event, Emitter<ExchangeRateState> emit) async {
    emit(AddExchangeRateLoading());
    try {
      final message =
          await exchangeRateRepository.addExchangeRate(event.exchangeRate);
      emit(AddExchangeRateSuccess(message: message));
    } catch (e) {
      emit(AddExchangeRateFailure(error: e.toString()));
    }
  }
}
