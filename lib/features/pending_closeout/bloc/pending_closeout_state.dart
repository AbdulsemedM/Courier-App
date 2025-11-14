part of 'pending_closeout_bloc.dart';

@immutable
sealed class PendingCloseoutState {}

final class PendingCloseoutInitial extends PendingCloseoutState {}

final class PendingCloseoutLoading extends PendingCloseoutState {}

final class PendingCloseoutLoaded extends PendingCloseoutState {
  final PendingCloseoutModel pendingCloseouts;

  PendingCloseoutLoaded({required this.pendingCloseouts});
}

final class PendingCloseoutError extends PendingCloseoutState {
  final String message;

  PendingCloseoutError({required this.message});
}

