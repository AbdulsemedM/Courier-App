// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:courier_app/features/shipment/data/repository/shipment_repository.dart';
import 'package:courier_app/features/track_order/model/shipmet_status_model.dart';

part 'shipments_event.dart';
part 'shipments_state.dart';

class ShipmentsBloc extends Bloc<ShipmentsEvent, ShipmentsState> {
  final ShipmentRepository shipmentRepository;
  ShipmentsBloc(this.shipmentRepository) : super(ShipmentsInitial()) {
    on<FetchShipments>(_fetchShipments);
    // on<FilterShipments>(_filterShipments);
  }

  void _fetchShipments(
      FetchShipments event, Emitter<ShipmentsState> emit) async {
    emit(FetchShipmentsLoading());
    try {
      final shipments = await shipmentRepository.fetchShipments();
      emit(FetchShipmentsSuccess(shipments: shipments));
    } catch (e) {
      emit(FetchShipmentsFailure(errorMessage: e.toString()));
    }
  }

  // void _filterShipments(
  //     FilterShipments event, Emitter<ShipmentsState> emit) async {
  //   // Implement the logic to filter shipments based on awbNumber and status
  // }
}
