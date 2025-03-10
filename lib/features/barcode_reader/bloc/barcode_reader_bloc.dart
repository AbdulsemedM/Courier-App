import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'barcode_reader_event.dart';
part 'barcode_reader_state.dart';

class BarcodeReaderBloc extends Bloc<BarcodeReaderEvent, BarcodeReaderState> {
  BarcodeReaderBloc() : super(BarcodeReaderInitial()) {
    on<BarcodeReaderEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
