part of 'admin_report_bloc.dart';

abstract class AdminReportState {}

class AdminReportInitial extends AdminReportState {}

class AdminReportLoading extends AdminReportState {}

class AdminReportLoaded extends AdminReportState {
  final List<AdminShipmentModel> shipments;

  AdminReportLoaded({required this.shipments});
}

class AdminReportError extends AdminReportState {
  final String message;

  AdminReportError({required this.message});
}

