part of 'shelves_management_bloc.dart';

sealed class ShelvesManagementState extends Equatable {
  const ShelvesManagementState();

  @override
  List<Object> get props => [];
}

final class ShelvesManagementInitial extends ShelvesManagementState {}

final class FetchShelvesLoading extends ShelvesManagementState {}

final class FetchShelvesSuccess extends ShelvesManagementState {
  final List<ShelvesModel> shelves;

  FetchShelvesSuccess({required this.shelves});
}

final class FetchShelvesFailure extends ShelvesManagementState {
  final String message;

  FetchShelvesFailure({required this.message});
}

final class TransferShelfLoading extends ShelvesManagementState {
  final ShelvesManagementState previous;

  const TransferShelfLoading({required this.previous});

  @override
  List<Object> get props => [previous];
}

final class TransferShelfSuccess extends ShelvesManagementState {
  final String message;
  final ShelvesManagementState previous;

  const TransferShelfSuccess({
    required this.message,
    required this.previous,
  });

  @override
  List<Object> get props => [message, previous];
}

final class TransferShelfFailure extends ShelvesManagementState {
  final String message;
  final ShelvesManagementState previous;

  const TransferShelfFailure({
    required this.message,
    required this.previous,
  });

  @override
  List<Object> get props => [message, previous];
}
