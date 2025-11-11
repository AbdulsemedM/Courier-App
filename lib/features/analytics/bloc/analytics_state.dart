part of 'analytics_bloc.dart';

sealed class AnalyticsState {}

final class AnalyticsInitial extends AnalyticsState {}

final class AnalyticsLoading extends AnalyticsState {}

final class AnalyticsLoaded extends AnalyticsState {
  final AnalyticsDashboardModel analytics;

  AnalyticsLoaded({required this.analytics});
}

final class AnalyticsError extends AnalyticsState {
  final String message;

  AnalyticsError({required this.message});
}

