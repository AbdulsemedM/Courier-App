// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'countries_bloc.dart';

@immutable
sealed class CountriesEvent {}

class FetchCountries extends CountriesEvent {}

class AddCountry extends CountriesEvent {
  final Map<String, dynamic> country;

  AddCountry({required this.country});
}
