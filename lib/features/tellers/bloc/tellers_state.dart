part of 'tellers_bloc.dart';

@immutable
sealed class TellersState {}

final class TellersInitial extends TellersState {}

final class FetchTellersLoading extends TellersState {}

final class FetchTellersSuccess extends TellersState {
  final List<TellerModel> tellers;

  FetchTellersSuccess({required this.tellers});
}

final class FetchTellersError extends TellersState {
  final String message;

  FetchTellersError({required this.message});
}

final class AddTellerLoading extends TellersState {}

final class AddTellerSuccess extends TellersState {
  final String message;

  AddTellerSuccess({required this.message});
}

final class AddTellerError extends TellersState {
  final String message;

  AddTellerError({required this.message});
}

final class UpdateTellerLoading extends TellersState {}

  final class UpdateTellerSuccess extends TellersState {
  final String message;

  UpdateTellerSuccess({required this.message});
}

final class UpdateTellerError extends TellersState {
  final String message;

  UpdateTellerError({required this.message});
}
