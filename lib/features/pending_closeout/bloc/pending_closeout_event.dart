part of 'pending_closeout_bloc.dart';

@immutable
sealed class PendingCloseoutEvent {}

class FetchPendingCloseouts extends PendingCloseoutEvent {
  final int? branchId;

  FetchPendingCloseouts({this.branchId});
}

