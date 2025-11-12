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
}

