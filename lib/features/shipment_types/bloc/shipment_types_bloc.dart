import 'package:courier_app/features/shipment_types/data/repository/shipment_types_repository.dart';
import 'package:courier_app/features/shipment_types/models/shipment_types_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'shipment_types_event.dart';
part 'shipment_types_state.dart';

class ShipmentTypesBloc extends Bloc<ShipmentTypesEvent, ShipmentTypesState> {
  final ShipmentTypesRepository shipmentTypesRepository;
  ShipmentTypesBloc(this.shipmentTypesRepository) : super(ShipmentTypesInitial()) {
    on<FetchShipmentTypes>(_fetchShipmentTypes);
    on<AddShipmentType>(_addShipmentType);
  }
  void _fetchShipmentTypes(
      FetchShipmentTypes event, Emitter<ShipmentTypesState> emit) async {
    emit(ShipmentTypesLoading());
    try {
      final shipmentTypes = await shipmentTypesRepository.fetchShipmentTypes();
      emit(ShipmentTypesLoaded(shipmentTypes: shipmentTypes));
    } catch (e) {
      emit(ShipmentTypesError(message: e.toString()));
    }
  }

  void _addShipmentType(AddShipmentType event, Emitter<ShipmentTypesState> emit) async {
    emit(AddShipmentTypesLoading());
    try {
      final shipmentType = await shipmentTypesRepository.addShipmentType(event.shipmentType);
      emit(AddShipmentTypesLoaded(message: shipmentType));
    } catch (e) {
      emit(AddShipmentTypesError(message: e.toString()));
    }
  }
}

