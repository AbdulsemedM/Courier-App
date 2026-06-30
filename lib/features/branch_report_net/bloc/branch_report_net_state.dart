part of 'branch_report_net_bloc.dart';

abstract class BranchReportNetState {}

class BranchReportNetInitial extends BranchReportNetState {}

class BranchReportNetLoading extends BranchReportNetState {}

class BranchReportNetLoaded extends BranchReportNetState {
  final List<BranchShipmentModel> shipments;
  final BranchShipmentReportSummary summary;

  BranchReportNetLoaded({
    required this.shipments,
    required this.summary,
  });
}

class BranchReportNetError extends BranchReportNetState {
  final String message;

  BranchReportNetError({required this.message});
}
