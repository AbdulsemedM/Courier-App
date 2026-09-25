import 'package:courier_app/features/branches/data/repository/branches_repository.dart';
import 'package:courier_app/features/branches/model/branches_model.dart';
import 'package:courier_app/features/branches/model/country_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'branches_event.dart';
part 'branches_state.dart';

class BranchesBloc extends Bloc<BranchesEvent, BranchesState> {
  final BranchesRepository branchesRepository;
  BranchesBloc(this.branchesRepository) : super(BranchesInitial()) {
    on<FetchBranches>(_fetchBranches);
    on<FetchCountry>(_fetchCountry);
    on<AddBranch>(_addBranch);
  }
  void _fetchBranches(FetchBranches event, Emitter<BranchesState> emit) async {
    // Keep previously loaded branches while refreshing so screens that resolve
    // branch IDs → names (e.g. Track Shipment origin/destination) don't flash empty.
    final previous = state is FetchBranchesLoaded
        ? (state as FetchBranchesLoaded).branches
        : null;
    if (previous == null) {
      emit(FetchBranchesLoading());
    }
    try {
      final branches = await branchesRepository.fetchBranches();
      emit(FetchBranchesLoaded(branches: branches));
    } catch (e) {
      if (previous != null) {
        emit(FetchBranchesLoaded(branches: previous));
      } else {
        emit(FetchBranchesError(message: e.toString()));
      }
    }
  }

  void _fetchCountry(FetchCountry event, Emitter<BranchesState> emit) async {
    emit(FetchCountryLoading());
    try {
      final countries = await branchesRepository.fetchCountry();
      emit(FetchCountryLoaded(countries: countries));
    } catch (e) {
      emit(FetchCountryError(message: e.toString()));
    }
  }

  void _addBranch(AddBranch event, Emitter<BranchesState> emit) async {
    emit(AddBranchLoading());
    try {
      final message = await branchesRepository.addBranch(event.body);
      emit(AddBranchLoaded(message: message));
    } catch (e) {
      emit(AddBranchError(message: e.toString()));
    }
  }
}
