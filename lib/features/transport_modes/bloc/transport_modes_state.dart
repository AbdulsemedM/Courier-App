part of 'transport_modes_bloc.dart';

@immutable
sealed class TransportModesState {}

final class TransportModesInitial extends TransportModesState {}

final class FetchTransportModesLoading extends TransportModesState {}

final class FetchTransportModesSuccess extends TransportModesState {
  final List<TransportModesModel> transportModes;
  FetchTransportModesSuccess(this.transportModes);
}

final class FetchTransportModesFailure extends TransportModesState {
  final String message;
  FetchTransportModesFailure(this.message);
}

final class AddTransportModeLoading extends TransportModesState {}

final class AddTransportModeSuccess extends TransportModesState {
  final String message;
  AddTransportModeSuccess(this.message);
}

final class AddTransportModeFailure extends TransportModesState {
  final String message;
  AddTransportModeFailure(this.message);
}
