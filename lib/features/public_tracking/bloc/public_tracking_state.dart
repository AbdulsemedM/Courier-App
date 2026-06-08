part of 'public_tracking_bloc.dart';

sealed class PublicTrackingState {}

final class PublicTrackingInitial extends PublicTrackingState {}

final class PublicTrackingLoading extends PublicTrackingState {}

final class PublicTrackingSingleResult extends PublicTrackingState {
  final List<PublicTrackingTimelineItem> events;
  PublicTrackingSingleResult(this.events);
}

final class PublicTrackingMultipleResults extends PublicTrackingState {
  final List<PublicShipmentSummary> summaries;
  PublicTrackingMultipleResults(this.summaries);
}

final class PublicTrackingFailure extends PublicTrackingState {
  final String message;
  PublicTrackingFailure(this.message);
}
