import 'package:courier_app/features/branches/data/repository/branches_repository.dart';
import 'package:courier_app/features/branches/model/branches_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
part 'branches_event.dart';
part 'branches_state.dart';

class BranchesBloc extends Bloc<BranchesEvent, BranchesState> {
  final BranchesRepository branchesRepository;
  BranchesBloc(this.branchesRepository) : super(BranchesInitial()) {
    on<FetchBranches>(_fetchBranches);
  }
  void _fetchBranches(FetchBranches event, Emitter<BranchesState> emit) async {
    emit(FetchBranchesLoading());
    try {
      final branches = await branchesRepository.fetchBranches();
      emit(FetchBranchesLoaded(branches: branches));
    } catch (e) {
      emit(FetchBranchesError(message: e.toString()));
    }
  }
}
