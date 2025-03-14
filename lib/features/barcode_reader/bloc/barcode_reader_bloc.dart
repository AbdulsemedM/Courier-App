import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repository/barcode_repository.dart';
part 'barcode_reader_event.dart';
part 'barcode_reader_state.dart';

class BarcodeReaderBloc extends Bloc<BarcodeReaderEvent, BarcodeReaderState> {
  final BarcodeRepository barcodeRepository;
  BarcodeReaderBloc(this.barcodeRepository) : super(BarcodeReaderInitial()) {
    on<BarcodeReaderChangeStatusEvent>((event, emit) async {
      emit(BarcodeReaderLoading());
      try {
        final result = await barcodeRepository.changeStatus(
            event.shipmentIds, event.status);
        emit(BarcodeReaderSuccess(result));
      } catch (e) {
        emit(BarcodeReaderError(e.toString()));
      }
    });
  }
}
