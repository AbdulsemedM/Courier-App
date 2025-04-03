part of 'countries_bloc.dart';

@immutable
sealed class CountriesState {}

final class CountriesInitial extends CountriesState {}

final class FetchCountriesLoading extends CountriesState {}

final class FetchCountriesSuccess extends CountriesState {
  final List<CountryModel> countries;

  FetchCountriesSuccess({required this.countries});
}

final class FetchCountriesFailure extends CountriesState {
  final String message;

  FetchCountriesFailure({required this.message});
}

final class AddCountryLoading extends CountriesState {}

final class AddCountrySuccess extends CountriesState {
  final String message;

  AddCountrySuccess({required this.message});
}

final class AddCountryFailure extends CountriesState {
  final String message;

  AddCountryFailure({required this.message});
}
