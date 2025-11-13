part of 'branch_report_bloc.dart';

abstract class BranchReportState {}

class BranchReportInitial extends BranchReportState {}

class BranchReportLoading extends BranchReportState {}

class BranchReportLoaded extends BranchReportState {
  final List<BranchShipmentModel> shipments;

  BranchReportLoaded({required this.shipments});
}

class BranchReportError extends BranchReportState {
  final String message;

  BranchReportError({required this.message});
}
