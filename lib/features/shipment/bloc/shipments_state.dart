part of 'shipments_bloc.dart';

@immutable
sealed class ShipmentsState {}

final class ShipmentsInitial extends ShipmentsState {}

final class FetchShipmentsLoading extends ShipmentsState {}

final class FetchShipmentsSuccess extends ShipmentsState {
  final List<ShipmentModel> shipments;

  FetchShipmentsSuccess({required this.shipments});
}

final class FetchShipmentsFailure extends ShipmentsState {
  final String errorMessage;

  FetchShipmentsFailure({required this.errorMessage});
}
