import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
part 'miles_configuration_event.dart';
part 'miles_configuration_state.dart';

class MilesConfigurationBloc
    extends Bloc<MilesConfigurationEvent, MilesConfigurationState> {
  MilesConfigurationBloc() : super(MilesConfigurationInitial()) {
    on<MilesConfigurationEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
