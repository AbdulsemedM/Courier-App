import 'package:courier_app/features/currency/data/repository/currency_repository.dart';
import 'package:courier_app/features/currency/model/currency_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'currency_event.dart';
part 'currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final CurrencyRepository currencyRepository;
  CurrencyBloc(this.currencyRepository) : super(CurrencyInitial()) {
    on<FetchCurrencies>(_fetchCurrencies);
    on<AddCurrency>(_addCurrency);
  }

  Future<void> _fetchCurrencies(
      FetchCurrencies event, Emitter<CurrencyState> emit) async {
    emit(FetchCurrencyLoading());
    try {
      final currencies = await currencyRepository.fetchCurrencies();
      emit(FetchCurrencySuccess(currencies));
    } catch (e) {
      emit(FetchCurrencyFailure(e.toString()));
    }
  }

  Future<void> _addCurrency(
      AddCurrency event, Emitter<CurrencyState> emit) async {
    emit(AddCurrencyLoading());
    try {
      final currency = await currencyRepository.addCurrency(event.currency);
      emit(AddCurrencySuccess(currency));
    } catch (e) {
      emit(AddCurrencyFailure(e.toString()));
    }
  }
}
