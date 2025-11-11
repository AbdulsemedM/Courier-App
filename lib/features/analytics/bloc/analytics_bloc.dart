import 'package:courier_app/features/analytics/data/repository/analytics_repository.dart';
import 'package:courier_app/features/analytics/model/analytics_dashboard_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'analytics_event.dart';
part 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final AnalyticsRepository analyticsRepository;

  AnalyticsBloc(this.analyticsRepository) : super(AnalyticsInitial()) {
    on<FetchAnalyticsDashboard>(_fetchAnalyticsDashboard);
  }

  void _fetchAnalyticsDashboard(
    FetchAnalyticsDashboard event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());
    try {
      final analytics = await analyticsRepository.fetchAnalyticsDashboard(
        branchId: event.branchId,
        fromDate: event.fromDate,
        toDate: event.toDate,
      );
      emit(AnalyticsLoaded(analytics: analytics));
    } catch (e) {
      emit(AnalyticsError(message: e.toString()));
    }
  }
}

