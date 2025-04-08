part of 'transport_modes_bloc.dart';

@immutable
sealed class TransportModesEvent {}

class FetchTransportModes extends TransportModesEvent {}

class AddTransportMode extends TransportModesEvent {
  final Map<String, dynamic> transportMode;
  AddTransportMode(this.transportMode);
}
