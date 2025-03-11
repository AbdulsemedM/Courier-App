import 'package:courier_app/features/track_order/data/repository/track_order_repository.dart';
import 'package:courier_app/features/track_order/model/shipmet_status_model.dart';
import 'package:courier_app/features/track_order/model/statuses_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'track_order_event.dart';
part 'track_order_state.dart';

class TrackOrderBloc extends Bloc<TrackOrderEvent, TrackOrderState> {
  final TrackOrderRepository trackOrderRepository;
  // PhoneNumberManager phoneManager = PhoneNumberManager();
  TrackOrderBloc(this.trackOrderRepository) : super(TrackOrderInitial()) {
    on<TrackOrder>(_trackOrderFetch);
    on<FetchStatuses>(_statusFetch);
  }
  void _trackOrderFetch(TrackOrder event, Emitter<TrackOrderState> emit) async {
    emit(TrackOrderLoading());
    // print("loading...");
    try {
      // final login =
      List<ShipmentModel> orders = await trackOrderRepository.fetchOrders();
      // phoneManager.setPhoneNumber(event.phoneNumber);
      emit(TrackOrderSuccess(shipments: orders));
    } catch (e) {
      emit(TrackOrdeFailure(errorMessage: e.toString()));
    }
  }

  void _statusFetch(FetchStatuses event, Emitter<TrackOrderState> emit) async {
    emit(FetchStatusLoading());
    // print("loading...");
    try {
      // final login =
      List<StatusModel> statuses = await trackOrderRepository.fetchStatuses();
      // phoneManager.setPhoneNumber(event.phoneNumber);
      emit(FetchStatusSuccess(statuses: statuses));
    } catch (e) {
      emit(FetchStatusFailure(errorMessage: e.toString()));
    }
  }
}
