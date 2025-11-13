part of 'branch_report_bloc.dart';

abstract class BranchReportEvent {}

class FetchBranchShipments extends BranchReportEvent {
  final int branchId;
  final String fromDate;
  final String toDate;

  FetchBranchShipments({
    required this.branchId,
    required this.fromDate,
    required this.toDate,
  });
}
