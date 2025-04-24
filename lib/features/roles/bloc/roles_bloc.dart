import 'package:courier_app/features/roles/model/roles_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
part 'roles_event.dart';
part 'roles_state.dart';

class RolesBloc extends Bloc<RolesEvent, RolesState> {
  RolesBloc() : super(RolesInitial()) {
    on<RolesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
