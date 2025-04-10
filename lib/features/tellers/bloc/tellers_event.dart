part of 'tellers_bloc.dart';

@immutable
sealed class TellersEvent {}

class FetchTellers extends TellersEvent {}

class AddTeller extends TellersEvent {
  final Map<String, dynamic> teller;

  AddTeller({required this.teller});
}

class UpdateTeller extends TellersEvent {
  final Map<String, dynamic> teller;
  final String tellerId;

  UpdateTeller({required this.teller, required this.tellerId});
}
