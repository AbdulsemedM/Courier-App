part of 'barcode_reader_bloc.dart';

@immutable
sealed class BarcodeReaderEvent {}

final class BarcodeReaderInitialEvent extends BarcodeReaderEvent {}

final class BarcodeReaderChangeStatusEvent extends BarcodeReaderEvent {
  final List<String> shipmentIds;
  final String status;
  final int? shelfId;
  BarcodeReaderChangeStatusEvent({
    required this.shipmentIds,
    required this.status,
    this.shelfId,
  });
}
