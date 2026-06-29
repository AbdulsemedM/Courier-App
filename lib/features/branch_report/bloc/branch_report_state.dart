part of 'branch_report_bloc.dart';

abstract class BranchReportState {}

class BranchReportInitial extends BranchReportState {}

class BranchReportLoading extends BranchReportState {}

class BranchReportLoaded extends BranchReportState {
  final List<BranchShipmentModel> shipments;
  final BranchShipmentReportSummary summary;
  final String? branchName;

  BranchReportLoaded({
    required this.shipments,
    required this.summary,
    this.branchName,
  });
}

class BranchReportError extends BranchReportState {
  final String message;

  BranchReportError({required this.message});
}
