import 'package:courier_app/features/shelves_management/data/repository/shelves_repository.dart';
import 'package:courier_app/features/shelves_management/model/shelves_mdoel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'shelves_management_event.dart';
part 'shelves_management_state.dart';

class ShelvesManagementBloc
    extends Bloc<ShelvesManagementEvent, ShelvesManagementState> {
  final ShelvesRepository shelvesRepository;

  ShelvesManagementBloc({required this.shelvesRepository})
      : super(ShelvesManagementInitial()) {
    on<FetchShelvesEvent>(_onFetchShelvesEvent);
    //on<AddShelvesEvent>(_onAddShelvesEvent);
  }

  // void _onAddShelvesEvent(AddShelvesEvent event, Emitter<ShelvesManagementState> emit) async {
  //  emit(AddShelvesLoading());
  //try {
  // await shelvesRepository.fetchShelves();
  //emit(AddShelvesSuccess());
  //} catch (e) {
  //    emit(AddShelvesFailure(message: e.toString()));
//    }
//  }

  void _onFetchShelvesEvent(
      FetchShelvesEvent event, Emitter<ShelvesManagementState> emit) async {
    emit(FetchShelvesLoading());
    try {
      final shelves = await shelvesRepository.fetchShelves();
      emit(FetchShelvesSuccess(shelves: shelves));
    } catch (e) {
      emit(FetchShelvesFailure(message: e.toString()));
    }
  }
}
