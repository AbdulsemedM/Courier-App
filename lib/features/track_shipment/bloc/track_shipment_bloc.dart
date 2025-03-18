import 'package:courier_app/features/track_shipment/data/repository/track_shipment_repository.dart';
import 'package:courier_app/features/track_shipment/model/track_shipment_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
part 'track_shipment_event.dart';
part 'track_shipment_state.dart';

class TrackShipmentBloc extends Bloc<TrackShipmentEvent, TrackShipmentState> {
  final TrackShipmentRepository trackShipmentRepository;
  TrackShipmentBloc(this.trackShipmentRepository)
      : super(TrackShipmentInitial()) {
    on<TrackShipment>((event, emit) async {
      emit(TrackShipmentLoading());
      try {
        final result =
            await trackShipmentRepository.getTrackShipment(event.awb);
        emit(TrackShipmentSuccess(result));
      } catch (e) {
        emit(TrackShipmentFailure(e.toString()));
      }
    });
  }
}
