import 'package:courier_app/features/miles_configuration/data/repository/miles_configuration_repository.dart';
import 'package:courier_app/features/miles_configuration/models/miles_configuration_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
part 'miles_configuration_event.dart';
part 'miles_configuration_state.dart';

class MilesConfigurationBloc
    extends Bloc<MilesConfigurationEvent, MilesConfigurationState> {
  final MilesConfigurationRepository milesConfigurationRepository;
  // PhoneNumberManager phoneManager = PhoneNumberManager();
  MilesConfigurationBloc(this.milesConfigurationRepository)
      : super(MilesConfigurationInitial()) {
    on<FetchMilesConfiguration>(_fetchMilesConfiguration);
  }
  void _fetchMilesConfiguration(FetchMilesConfiguration event,
      Emitter<MilesConfigurationState> emit) async {
    emit(MilesConfigurationLoading());
    try {
      final milesConfigurations =
          await milesConfigurationRepository.getMilesConfiguration();
      emit(MilesConfigurationSuccess(milesConfigurations));
    } catch (e) {
      emit(MilesConfigurationFailure(e.toString()));
    }
  }
}
