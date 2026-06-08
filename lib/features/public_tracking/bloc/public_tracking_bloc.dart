import 'package:courier_app/features/public_tracking/data/repository/public_tracking_repository.dart';
import 'package:courier_app/features/public_tracking/model/public_tracking_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'public_tracking_event.dart';
part 'public_tracking_state.dart';

class PublicTrackingBloc
    extends Bloc<PublicTrackingEvent, PublicTrackingState> {
  final PublicTrackingRepository repository;

  PublicTrackingBloc(this.repository) : super(PublicTrackingInitial()) {
    on<PublicTrackingSearchByAwb>(_onSearchByAwb);
    on<PublicTrackingSearchByPhone>(_onSearchByPhone);
    on<PublicTrackingShipmentSelected>(_onShipmentSelected);
    on<PublicTrackingReset>(_onReset);
  }

  Future<void> _onSearchByAwb(
    PublicTrackingSearchByAwb event,
    Emitter<PublicTrackingState> emit,
  ) async {
    emit(PublicTrackingLoading());
    try {
      final result = await repository.trackByAwb(event.awb);
      await _emitResult(result, emit);
    } catch (e) {
      emit(PublicTrackingFailure(e.toString()));
    }
  }

  Future<void> _onSearchByPhone(
    PublicTrackingSearchByPhone event,
    Emitter<PublicTrackingState> emit,
  ) async {
    emit(PublicTrackingLoading());
    try {
      final result = await repository.trackByPhone(
        event.countryDialCode,
        event.localNumber,
      );
      await _emitResult(result, emit);
    } catch (e) {
      emit(PublicTrackingFailure(e.toString()));
    }
  }

  Future<void> _onShipmentSelected(
    PublicTrackingShipmentSelected event,
    Emitter<PublicTrackingState> emit,
  ) async {
    emit(PublicTrackingLoading());
    try {
      final result = await repository.trackByAwb(event.awb);
      await _emitResult(result, emit);
    } catch (e) {
      emit(PublicTrackingFailure(e.toString()));
    }
  }

  void _onReset(
    PublicTrackingReset event,
    Emitter<PublicTrackingState> emit,
  ) {
    emit(PublicTrackingInitial());
  }

  Future<void> _emitResult(
    PublicTrackingResult result,
    Emitter<PublicTrackingState> emit,
  ) async {
    switch (result.type) {
      case PublicTrackingResultType.single:
        emit(PublicTrackingSingleResult(result.events));
      case PublicTrackingResultType.multiple:
        if (result.summaries.length == 1) {
          try {
            final detail =
                await repository.trackByAwb(result.summaries.first.awb);
            if (detail.type == PublicTrackingResultType.single) {
              emit(PublicTrackingSingleResult(detail.events));
            } else {
              emit(PublicTrackingMultipleResults(result.summaries));
            }
          } catch (e) {
            emit(PublicTrackingFailure(e.toString()));
          }
          return;
        }
        emit(PublicTrackingMultipleResults(result.summaries));
    }
  }
}
