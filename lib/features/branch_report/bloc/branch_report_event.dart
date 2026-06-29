part of 'branch_report_bloc.dart';

abstract class BranchReportEvent {}

class FetchBranchShipments extends BranchReportEvent {
  final int branchId;
  final String startDate;
  final String endDate;
  final String search;

  FetchBranchShipments({
    required this.branchId,
    required this.startDate,
    required this.endDate,
    this.search = '',
  });
}
