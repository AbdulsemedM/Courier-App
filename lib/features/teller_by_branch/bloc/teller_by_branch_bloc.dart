import 'package:courier_app/features/teller_by_branch/data/model/teller_by_branch_model.dart';
import 'package:courier_app/features/teller_by_branch/data/repository/teller_by_branch_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'teller_by_branch_event.dart';
part 'teller_by_branch_state.dart';

class TellerByBranchBloc extends Bloc<TellerByBranchEvent, TellerByBranchState> {
  final TellerByBranchRepository tellerByBranchRepository;
  TellerByBranchBloc(this.tellerByBranchRepository) : super(TellerByBranchInitial()) {
    on<FetchTellersByBranch>(_fetchTellersByBranch);
    on<ReopenTeller>(_reopenTeller);
  }

  void _fetchTellersByBranch(FetchTellersByBranch event, Emitter<TellerByBranchState> emit) async {
    emit(FetchTellersByBranchLoading());
    try {
      final tellers = await tellerByBranchRepository.fetchTellersWithStatus(event.branchId);
      emit(FetchTellersByBranchSuccess(tellers: tellers));
    } catch (e) {
      emit(FetchTellersByBranchError(message: e.toString()));
    }
  }

  void _reopenTeller(ReopenTeller event, Emitter<TellerByBranchState> emit) async {
    emit(ReopenTellerLoading());
    try {
      final message = await tellerByBranchRepository.reopenTeller(event.tellerId);
      emit(ReopenTellerSuccess(message: message));
      // After successful reopen, refresh the tellers list
      // Note: We need the current branchId, but we don't have it in the event
      // We'll handle refresh in the UI after success
    } catch (e) {
      emit(ReopenTellerError(message: e.toString()));
    }
  }
}

