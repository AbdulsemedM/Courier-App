part of 'branch_report_net_bloc.dart';

abstract class BranchReportNetEvent {}

class FetchBranchReportNet extends BranchReportNetEvent {
  final int branchId;
  final String fromDate;
  final String toDate;

  FetchBranchReportNet({
    required this.branchId,
    required this.fromDate,
    required this.toDate,
  });
}
