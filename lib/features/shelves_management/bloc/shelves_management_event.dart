part of 'shelves_management_bloc.dart';

sealed class ShelvesManagementEvent extends Equatable {
  const ShelvesManagementEvent();

  @override
  List<Object> get props => [];
}

class FetchShelvesEvent extends ShelvesManagementEvent {}

class TransferShelfEvent extends ShelvesManagementEvent {
  final String awbNumber;
  final int toShelfId;
  final String reason;

  const TransferShelfEvent({
    required this.awbNumber,
    required this.toShelfId,
    required this.reason,
  });

  @override
  List<Object> get props => [awbNumber, toShelfId, reason];
}

class RestoreShelvesStateEvent extends ShelvesManagementEvent {
  final ShelvesManagementState state;

  const RestoreShelvesStateEvent(this.state);

  @override
  List<Object> get props => [state];
}
