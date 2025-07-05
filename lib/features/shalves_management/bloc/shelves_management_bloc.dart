import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'shelves_management_event.dart';
part 'shelves_management_state.dart';

class ShelvesManagementBloc extends Bloc<ShelvesManagementEvent, ShelvesManagementState> {
  ShelvesManagementBloc() : super(ShelvesManagementInitial()) {
    on<ShelvesManagementEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
