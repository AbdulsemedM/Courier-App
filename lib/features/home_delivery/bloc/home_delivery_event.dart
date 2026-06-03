part of 'home_delivery_bloc.dart';

sealed class HomeDeliveryEvent extends Equatable {
  const HomeDeliveryEvent();

  @override
  List<Object?> get props => [];
}

class FetchHomeDeliveries extends HomeDeliveryEvent {
  final int branchId;
  final HomeDeliveryView view;
  final String? status;

  const FetchHomeDeliveries({
    required this.branchId,
    required this.view,
    this.status,
  });

  @override
  List<Object?> get props => [branchId, view, status];
}

class FetchMessengers extends HomeDeliveryEvent {
  final int branchId;

  const FetchMessengers({required this.branchId});

  @override
  List<Object?> get props => [branchId];
}

class AssignMessenger extends HomeDeliveryEvent {
  final String awb;
  final int messengerId;
  final int assignedBy;
  final String estimatedDeliveryTime;

  const AssignMessenger({
    required this.awb,
    required this.messengerId,
    required this.assignedBy,
    required this.estimatedDeliveryTime,
  });

  @override
  List<Object?> get props =>
      [awb, messengerId, assignedBy, estimatedDeliveryTime];
}
