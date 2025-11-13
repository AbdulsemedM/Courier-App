part of 'admin_report_bloc.dart';

abstract class AdminReportEvent {}

class FetchAdminShipments extends AdminReportEvent {
  final int branchId;
  final String fromDate;
  final String toDate;

  FetchAdminShipments({
    required this.branchId,
    required this.fromDate,
    required this.toDate,
  });
}

