part of 'analytics_bloc.dart';

sealed class AnalyticsEvent {}

class FetchAnalyticsDashboard extends AnalyticsEvent {
  final int branchId;
  final String fromDate;
  final String toDate;

  FetchAnalyticsDashboard({
    required this.branchId,
    required this.fromDate,
    required this.toDate,
  });
}

