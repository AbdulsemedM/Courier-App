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
    on<TransferShelfEvent>(_onTransferShelfEvent);
    on<RestoreShelvesStateEvent>(_onRestoreShelvesStateEvent);
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

  Future<void> _onTransferShelfEvent(
    TransferShelfEvent event,
    Emitter<ShelvesManagementState> emit,
  ) async {
    final previous = state;
    emit(TransferShelfLoading(previous: previous));
    try {
      final message = await shelvesRepository.transferShelf(
        awbNumber: event.awbNumber,
        toShelfId: event.toShelfId,
        reason: event.reason,
      );
      emit(TransferShelfSuccess(message: message, previous: previous));
    } catch (e) {
      emit(TransferShelfFailure(message: e.toString(), previous: previous));
    }
  }

  void _onRestoreShelvesStateEvent(
    RestoreShelvesStateEvent event,
    Emitter<ShelvesManagementState> emit,
  ) {
    emit(event.state);
  }
}
