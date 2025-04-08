import 'package:courier_app/features/transport_modes/data/repository/transport_modes_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../model/transport_modes_model.dart';
part 'transport_modes_event.dart';
part 'transport_modes_state.dart';

class TransportModesBloc
    extends Bloc<TransportModesEvent, TransportModesState> {
  final TransportModesRepository transportModesRepository;
  TransportModesBloc(this.transportModesRepository)
      : super(TransportModesInitial()) {
    on<FetchTransportModes>(_fetchTransportModes);
    on<AddTransportMode>(_addTransportMode);
  }
  void _fetchTransportModes(
      FetchTransportModes event, Emitter<TransportModesState> emit) async {
    emit(FetchTransportModesLoading());
    try {
      final transportModes =
          await transportModesRepository.fetchTransportModes();
      emit(FetchTransportModesSuccess(transportModes));
    } catch (e) {
      emit(FetchTransportModesFailure(e.toString()));
    }
  }

  void _addTransportMode(
      AddTransportMode event, Emitter<TransportModesState> emit) async {
    emit(AddTransportModeLoading());
    try {
      final message =
          await transportModesRepository.addTransportMode(event.transportMode);
      emit(AddTransportModeSuccess(message));
    } catch (e) {
      emit(AddTransportModeFailure(e.toString()));
    }
  }
}
