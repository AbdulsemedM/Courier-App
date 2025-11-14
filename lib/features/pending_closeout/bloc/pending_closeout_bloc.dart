import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:courier_app/features/pending_closeout/data/repository/pending_closeout_repository.dart';
import 'package:courier_app/features/pending_closeout/data/model/pending_closeout_model.dart';

part 'pending_closeout_event.dart';
part 'pending_closeout_state.dart';

class PendingCloseoutBloc extends Bloc<PendingCloseoutEvent, PendingCloseoutState> {
  final PendingCloseoutRepository repository;

  PendingCloseoutBloc({required this.repository}) : super(PendingCloseoutInitial()) {
    on<FetchPendingCloseouts>(_onFetchPendingCloseouts);
  }

  Future<void> _onFetchPendingCloseouts(
    FetchPendingCloseouts event,
    Emitter<PendingCloseoutState> emit,
  ) async {
    emit(PendingCloseoutLoading());
    try {
      final pendingCloseouts = await repository.fetchPendingCloseouts(
        branchId: event.branchId,
      );
      emit(PendingCloseoutLoaded(pendingCloseouts: pendingCloseouts));
    } catch (e) {
      emit(PendingCloseoutError(message: e.toString()));
    }
  }
}

