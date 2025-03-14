part of 'barcode_reader_bloc.dart';

@immutable
sealed class BarcodeReaderEvent {}

final class BarcodeReaderInitialEvent extends BarcodeReaderEvent {}

final class BarcodeReaderChangeStatusEvent extends BarcodeReaderEvent {
  final List<String> shipmentIds;
  final String status;
  BarcodeReaderChangeStatusEvent(
      {required this.shipmentIds, required this.status});
}
