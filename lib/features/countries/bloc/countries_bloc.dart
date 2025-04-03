import 'package:courier_app/features/branches/model/country_model.dart';
import 'package:courier_app/features/countries/data/repository/countries_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
part 'countries_event.dart';
part 'countries_state.dart';

class CountriesBloc extends Bloc<CountriesEvent, CountriesState> {
  final CountriesRepository countriesRepository;
  CountriesBloc(this.countriesRepository) : super(CountriesInitial()) {
    on<FetchCountries>(_fetchCountries);
    on<AddCountry>(_addCountry);
  }
  void _fetchCountries(
      FetchCountries event, Emitter<CountriesState> emit) async {
    emit(FetchCountriesLoading());
    try {
      final countries = await countriesRepository.fetchCountry();
      emit(FetchCountriesSuccess(countries: countries));
    } catch (e) {
      emit(FetchCountriesFailure(message: e.toString()));
    }
  }

  void _addCountry(AddCountry event, Emitter<CountriesState> emit) async {
    emit(AddCountryLoading());
    try {
      final country = await countriesRepository.addCountry(event.country);
      emit(AddCountrySuccess(message: country));
    } catch (e) {
      emit(AddCountryFailure(message: e.toString()));
    }
  }
}
