part of 'home_delivery_bloc.dart';

sealed class HomeDeliveryState extends Equatable {
  const HomeDeliveryState();

  @override
  List<Object?> get props => [];
}

class HomeDeliveryInitial extends HomeDeliveryState {}

class FetchHomeDeliveriesLoading extends HomeDeliveryState {}

class FetchHomeDeliveriesSuccess extends HomeDeliveryState {
  final List<HomeDeliveryModel> deliveries;

  const FetchHomeDeliveriesSuccess({required this.deliveries});

  @override
  List<Object?> get props => [deliveries];
}

class FetchHomeDeliveriesFailure extends HomeDeliveryState {
  final String message;

  const FetchHomeDeliveriesFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class FetchMessengersLoading extends HomeDeliveryState {
  final HomeDeliveryState previous;

  const FetchMessengersLoading({required this.previous});

  @override
  List<Object?> get props => [previous];
}

class FetchMessengersSuccess extends HomeDeliveryState {
  final List<MessengerModel> messengers;
  final HomeDeliveryState previous;

  const FetchMessengersSuccess({
    required this.messengers,
    required this.previous,
  });

  @override
  List<Object?> get props => [messengers, previous];
}

class FetchMessengersFailure extends HomeDeliveryState {
  final String message;
  final HomeDeliveryState previous;

  const FetchMessengersFailure({
    required this.message,
    required this.previous,
  });

  @override
  List<Object?> get props => [message, previous];
}

class AssignMessengerLoading extends HomeDeliveryState {
  final HomeDeliveryState previous;

  const AssignMessengerLoading({required this.previous});

  @override
  List<Object?> get props => [previous];
}

class AssignMessengerSuccess extends HomeDeliveryState {
  final String message;
  final HomeDeliveryState previous;

  const AssignMessengerSuccess({
    required this.message,
    required this.previous,
  });

  @override
  List<Object?> get props => [message, previous];
}

class AssignMessengerFailure extends HomeDeliveryState {
  final String message;
  final HomeDeliveryState previous;

  const AssignMessengerFailure({
    required this.message,
    required this.previous,
  });

  @override
  List<Object?> get props => [message, previous];
}
