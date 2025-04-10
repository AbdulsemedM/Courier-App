
import 'package:courier_app/features/tellers/data/repository/teller_repository.dart';
import 'package:courier_app/features/tellers/model/teller_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'tellers_event.dart';
part 'tellers_state.dart';

class TellersBloc extends Bloc<TellersEvent, TellersState> {
  final TellerRepository tellerRepository;
  TellersBloc(this.tellerRepository) : super(TellersInitial()) {
    on<FetchTellers>(_fetchTellers);
    on<AddTeller>(_addTeller);
    on<UpdateTeller>(_updateTeller);
    }

  void _fetchTellers(FetchTellers event, Emitter<TellersState> emit) async {
    emit(FetchTellersLoading());
    try {
      final tellers = await tellerRepository.fetchTellers();
      emit(FetchTellersSuccess(tellers: tellers));
    } catch (e) {
      emit(FetchTellersError(message: e.toString()));
    }
  }

  void _addTeller(AddTeller event, Emitter<TellersState> emit) async {
    emit(AddTellerLoading());
    try {
      final response = await tellerRepository.addTeller(event.teller);
      emit(AddTellerSuccess(message: response));
    } catch (e) {
      emit(AddTellerError(message: e.toString()));
    }
  }

  void _updateTeller(UpdateTeller event, Emitter<TellersState> emit) async {
    emit(UpdateTellerLoading());
    try {
      final response = await tellerRepository.updateTeller(event.teller, event.tellerId);
        emit(UpdateTellerSuccess(message: response));
    } catch (e) {
      emit(UpdateTellerError(message: e.toString()));
    }
  }
}
