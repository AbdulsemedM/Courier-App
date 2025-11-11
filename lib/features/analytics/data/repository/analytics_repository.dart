import 'dart:convert';

import 'package:courier_app/features/analytics/data/data_provider/analytics_data_provider.dart';
import 'package:courier_app/features/analytics/model/analytics_dashboard_model.dart';

class AnalyticsRepository {
  final AnalyticsDataProvider analyticsDataProvider;

  AnalyticsRepository({required this.analyticsDataProvider});

  Future<AnalyticsDashboardModel> fetchAnalyticsDashboard({
    required int branchId,
    required String fromDate,
    required String toDate,
  }) async {
    try {
      final response = await analyticsDataProvider.fetchAnalyticsDashboard(
        branchId: branchId,
        fromDate: fromDate,
        toDate: toDate,
      );
      final data = jsonDecode(response);
      
      // Check if response has status field (some APIs wrap it)
      if (data is Map<String, dynamic>) {
        if (data.containsKey('status') && data['status'] != 200) {
          throw data['message'] ?? 'Failed to fetch analytics';
        }
        
        // If wrapped in 'data' field, use that; otherwise use the response directly
        final analyticsData = data['data'] ?? data;
        return AnalyticsDashboardModel.fromJson(
          analyticsData as Map<String, dynamic>,
        );
      } else {
        throw "Invalid response format: Expected a map";
      }
    } catch (e) {
      throw e.toString();
    }
  }
}

