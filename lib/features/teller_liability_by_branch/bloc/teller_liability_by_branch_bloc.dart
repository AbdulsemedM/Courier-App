import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:courier_app/features/teller_liability_by_branch/data/repository/teller_liability_by_branch_repository.dart';
import 'package:courier_app/features/teller_liability/data/model/teller_liability_model.dart';

part 'teller_liability_by_branch_event.dart';
part 'teller_liability_by_branch_state.dart';

class TellerLiabilityByBranchBloc extends Bloc<TellerLiabilityByBranchEvent, TellerLiabilityByBranchState> {
  final TellerLiabilityByBranchRepository repository;

  TellerLiabilityByBranchBloc({required this.repository}) : super(TellerLiabilityByBranchInitial()) {
    on<FetchTellerLiabilitiesByBranch>(_onFetchTellerLiabilitiesByBranch);
  }

  Future<void> _onFetchTellerLiabilitiesByBranch(
    FetchTellerLiabilitiesByBranch event,
    Emitter<TellerLiabilityByBranchState> emit,
  ) async {
    emit(TellerLiabilityByBranchLoading());
    try {
      final liabilities = await repository.fetchTellerLiabilitiesByBranch(
        branchId: event.branchId,
      );
      emit(TellerLiabilityByBranchLoaded(liabilities: liabilities));
    } catch (e) {
      emit(TellerLiabilityByBranchError(message: e.toString()));
    }
  }
}

