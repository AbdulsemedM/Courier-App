import 'package:courier_app/features/track_shipment/data/repository/track_shipment_repository.dart';
import 'package:courier_app/features/track_shipment/model/customer_shipment_history_item.dart';
import 'package:courier_app/features/track_shipment/model/track_shipment_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
part 'track_shipment_event.dart';
part 'track_shipment_state.dart';

class TrackShipmentBloc extends Bloc<TrackShipmentEvent, TrackShipmentState> {
  final TrackShipmentRepository trackShipmentRepository;
  List<CustomerShipmentHistoryItem> _cachedPhoneHistory = [];
  int _requestId = 0;

  TrackShipmentBloc(this.trackShipmentRepository)
      : super(TrackShipmentInitial()) {
    on<TrackShipment>((event, emit) async {
      final requestId = ++_requestId;
      final previousSuccess =
          state is TrackShipmentSuccess ? state as TrackShipmentSuccess : null;

      if (!event.preservePreviousData) {
        emit(TrackShipmentLoading());
      }

      try {
        final result =
            await trackShipmentRepository.getTrackShipment(event.awb);
        if (requestId != _requestId) return;
        emit(TrackShipmentSuccess(result));
      } catch (e) {
        if (requestId != _requestId) return;
        if (event.preservePreviousData && previousSuccess != null) {
          return;
        }
        emit(TrackShipmentFailure(e.toString()));
      }
    });
    on<TrackShipmentByPhone>(_onTrackByPhone);
    on<TrackShipmentShowPhoneHistory>(_onShowPhoneHistory);
    on<TrackShipmentClear>(_onClear);
  }

  Future<void> _onTrackByPhone(
    TrackShipmentByPhone event,
    Emitter<TrackShipmentState> emit,
  ) async {
    final requestId = ++_requestId;
    emit(TrackShipmentLoading());
    try {
      final items = await trackShipmentRepository
          .getCustomerShipmentHistory(event.phone);
      if (requestId != _requestId) return;
      _cachedPhoneHistory = items;
      emit(TrackShipmentPhoneHistorySuccess(items));
    } catch (e) {
      if (requestId != _requestId) return;
      emit(TrackShipmentFailure(e.toString()));
    }
  }

  void _onShowPhoneHistory(
    TrackShipmentShowPhoneHistory event,
    Emitter<TrackShipmentState> emit,
  ) {
    _requestId++;
    if (_cachedPhoneHistory.isEmpty) {
      emit(TrackShipmentInitial());
      return;
    }
    emit(TrackShipmentPhoneHistorySuccess(_cachedPhoneHistory));
  }

  void _onClear(
    TrackShipmentClear event,
    Emitter<TrackShipmentState> emit,
  ) {
    _requestId++;
    _cachedPhoneHistory = [];
    emit(TrackShipmentInitial());
  }
}
