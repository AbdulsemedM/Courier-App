part of 'shipments_bloc.dart';

@immutable
sealed class ShipmentsEvent {}

class FetchShipments extends ShipmentsEvent {}
