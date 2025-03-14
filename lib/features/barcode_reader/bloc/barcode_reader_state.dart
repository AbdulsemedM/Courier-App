part of 'barcode_reader_bloc.dart';

@immutable
sealed class BarcodeReaderState {}

final class BarcodeReaderInitial extends BarcodeReaderState {}

final class BarcodeReaderLoading extends BarcodeReaderState {}

final class BarcodeReaderSuccess extends BarcodeReaderState {
  final String message;
  BarcodeReaderSuccess(this.message);
}

final class BarcodeReaderError extends BarcodeReaderState {
  final String message;
  BarcodeReaderError(this.message);
}
