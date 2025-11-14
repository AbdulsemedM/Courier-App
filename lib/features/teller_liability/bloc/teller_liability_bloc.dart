import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:courier_app/features/teller_liability/data/repository/teller_liability_repository.dart';
import 'package:courier_app/features/teller_liability/data/model/teller_liability_model.dart';

part 'teller_liability_event.dart';
part 'teller_liability_state.dart';

class TellerLiabilityBloc extends Bloc<TellerLiabilityEvent, TellerLiabilityState> {
  final TellerLiabilityRepository repository;

  TellerLiabilityBloc({required this.repository}) : super(TellerLiabilityInitial()) {
    on<FetchTellerLiabilities>(_onFetchTellerLiabilities);
  }

  Future<void> _onFetchTellerLiabilities(
    FetchTellerLiabilities event,
    Emitter<TellerLiabilityState> emit,
  ) async {
    emit(TellerLiabilityLoading());
    try {
      final liabilities = await repository.fetchTellerLiabilities();
      emit(TellerLiabilityLoaded(liabilities: liabilities));
    } catch (e) {
      emit(TellerLiabilityError(message: e.toString()));
    }
  }
}

