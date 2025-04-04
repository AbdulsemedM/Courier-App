import 'package:courier_app/features/services_mode/data/repository/services_mode_repository.dart';
import 'package:courier_app/features/services_mode/models/services_mode_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'services_mode_event.dart';
part 'services_mode_state.dart';

class ServicesModeBloc extends Bloc<ServicesModeEvent, ServicesModeState> {
  final ServicesModeRepository servicesModeRepository;
  ServicesModeBloc(this.servicesModeRepository) : super(ServicesModeInitial()) {
    on<FetchServicesMode>(_fetchServicesMode);
    on<AddServicesMode>(_addServicesMode);
  }
  void _fetchServicesMode(
      FetchServicesMode event, Emitter<ServicesModeState> emit) async {
    emit(ServicesModeLoading());
    try {
      final servicesMode = await servicesModeRepository.fetchServicesMode();
      emit(ServicesModeLoaded(servicesMode: servicesMode));
    } catch (e) {
      emit(ServicesModeError(message: e.toString()));
    }
  }

  void _addServicesMode(
      AddServicesMode event, Emitter<ServicesModeState> emit) async {
    emit(AddServicesModeLoading());
    try {
      final servicesMode =
          await servicesModeRepository.addServicesMode(event.servicesMode);
      emit(AddServicesModeLoaded(message: servicesMode));
    } catch (e) {
      emit(AddServicesModeError(message: e.toString()));
    }
  }
}
