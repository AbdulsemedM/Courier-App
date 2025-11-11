import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:courier_app/configuration/auth_service.dart';
import 'package:courier_app/core/theme/theme_provider.dart';
import 'package:courier_app/features/analytics/bloc/analytics_bloc.dart';
import 'package:courier_app/features/analytics/presentation/widgets/analytics_widgets.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AuthService _authService = AuthService();
  int? _branchId;
  String? _fromDate;
  String? _toDate;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final branch = await _authService.getBranch();
    if (branch != null) {
      setState(() {
        _branchId = int.tryParse(branch);
        final now = DateTime.now();
        _fromDate = DateFormat('yyyy-MM-dd').format(now);
        _toDate = DateFormat('yyyy-MM-dd').format(now);
      });

      if (_branchId != null && _fromDate != null && _toDate != null) {
        context.read<AnalyticsBloc>().add(
              FetchAnalyticsDashboard(
                branchId: _branchId!,
                fromDate: _fromDate!,
                toDate: _toDate!,
              ),
            );
      }
    }
  }

  Future<void> _refreshData() async {
    if (_branchId != null && _fromDate != null && _toDate != null) {
      context.read<AnalyticsBloc>().add(
            FetchAnalyticsDashboard(
              branchId: _branchId!,
              fromDate: _fromDate!,
              toDate: _toDate!,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: BlocBuilder<AnalyticsBloc, AnalyticsState>(
          builder: (context, state) {
            if (state is AnalyticsLoading) {
              return _buildLoadingState(isDarkMode);
            } else if (state is AnalyticsLoaded) {
              return _buildContent(state.analytics, isDarkMode);
            } else if (state is AnalyticsError) {
              return _buildErrorState(state.message, isDarkMode);
            }
            return _buildLoadingState(isDarkMode);
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState(bool isDarkMode) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildShimmerCard(isDarkMode),
        const SizedBox(height: 16),
        _buildShimmerCard(isDarkMode),
        const SizedBox(height: 16),
        _buildShimmerCard(isDarkMode),
      ],
    );
  }

  Widget _buildShimmerCard(bool isDarkMode) {
    return Shimmer.fromColors(
      baseColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildErrorState(String message, bool isDarkMode) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: isDarkMode ? Colors.red[300] : Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading analytics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.grey[900],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _refreshData,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(dynamic analytics, bool isDarkMode) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Range Display
          if (_fromDate != null && _toDate != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.grey[850]!.withOpacity(0.5)
                    : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'From: $_fromDate to $_toDate',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

          // Key Metrics Section
          Text(
            'Key Metrics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.grey[900],
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              AnalyticsWidgets.buildMetricCard(
                title: 'Today',
                value: (analytics.totalShipmentsToday ?? 0).toString(),
                icon: Icons.inventory_2_outlined,
                color: const Color(0xFF9C27B0),
                isDarkMode: isDarkMode,
              ),
              AnalyticsWidgets.buildMetricCard(
                title: 'This Week',
                value: (analytics.totalShipmentsThisWeek ?? 0).toString(),
                icon: Icons.inventory_2_outlined,
                color: const Color(0xFF2196F3),
                isDarkMode: isDarkMode,
              ),
              AnalyticsWidgets.buildMetricCard(
                title: 'Active Drivers',
                value: (analytics.activeDrivers ?? 0).toString(),
                icon: Icons.people_outline,
                color: const Color(0xFFFFC107),
                isDarkMode: isDarkMode,
              ),
              AnalyticsWidgets.buildMetricCard(
                title: 'Active Customers',
                value: (analytics.activeCustomers ?? 0).toString(),
                icon: Icons.people_outline,
                color: const Color(0xFFE91E63),
                isDarkMode: isDarkMode,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Shipment Status Section
          Text(
            'Shipment Status',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.grey[900],
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              AnalyticsWidgets.buildStatusCard(
                title: 'In Transit',
                value: analytics.deliveriesInTransit ?? 0,
                icon: Icons.local_shipping,
                color: const Color(0xFFFFC107),
                isDarkMode: isDarkMode,
              ),
              AnalyticsWidgets.buildStatusCard(
                title: 'Completed',
                value: analytics.completedDeliveries ?? 0,
                icon: Icons.check_circle,
                color: Colors.green,
                isDarkMode: isDarkMode,
              ),
              AnalyticsWidgets.buildStatusCard(
                title: 'Pending',
                value: analytics.pendingDeliveries ?? 0,
                icon: Icons.warning,
                color: const Color(0xFFE91E63),
                isDarkMode: isDarkMode,
              ),
              AnalyticsWidgets.buildStatusCard(
                title: 'Delayed',
                value: analytics.delayedDeliveries ?? 0,
                icon: Icons.access_time,
                color: const Color(0xFFE91E63),
                isDarkMode: isDarkMode,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Target KG Progress Section
          Text(
            'Target KG Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.grey[900],
            ),
          ),
          const SizedBox(height: 12),
          if (analytics.targetKg != null) ...[
            if (analytics.targetKg!.daily != null)
              AnalyticsWidgets.buildTargetCard(
                title: 'Daily Target',
                progress: analytics.targetKg!.daily!.progress ?? 0,
                target: analytics.targetKg!.daily!.target ?? 1,
                percentage: analytics.targetKg!.daily!.percentage ?? 0.0,
                status: analytics.targetKg!.daily!.status ?? 'Fail',
                isDarkMode: isDarkMode,
              ),
            const SizedBox(height: 12),
            if (analytics.targetKg!.weekly != null)
              AnalyticsWidgets.buildTargetCard(
                title: 'Weekly Target',
                progress: analytics.targetKg!.weekly!.progress ?? 0,
                target: analytics.targetKg!.weekly!.target ?? 1,
                percentage: analytics.targetKg!.weekly!.percentage ?? 0.0,
                status: analytics.targetKg!.weekly!.status ?? 'Fail',
                isDarkMode: isDarkMode,
              ),
            const SizedBox(height: 12),
            if (analytics.targetKg!.monthly != null)
              AnalyticsWidgets.buildTargetCard(
                title: 'Monthly Target',
                progress: analytics.targetKg!.monthly!.progress ?? 0,
                target: analytics.targetKg!.monthly!.target ?? 1,
                percentage: analytics.targetKg!.monthly!.percentage ?? 0.0,
                status: analytics.targetKg!.monthly!.status ?? 'Fail',
                isDarkMode: isDarkMode,
              ),
          ],

          const SizedBox(height: 24),

          // Financial Summary Section
          Text(
            'Financial Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.grey[900],
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              AnalyticsWidgets.buildFinancialCard(
                title: 'Revenue',
                value: analytics.revenue ?? 0.0,
                icon: Icons.attach_money,
                color: Colors.blue,
                isDarkMode: isDarkMode,
              ),
              AnalyticsWidgets.buildFinancialCard(
                title: 'Expenses',
                value: analytics.expenses ?? 0.0,
                icon: Icons.warning,
                color: Colors.orange,
                isDarkMode: isDarkMode,
              ),
              AnalyticsWidgets.buildFinancialCard(
                title: 'Profit',
                value: analytics.profit ?? 0.0,
                icon: Icons.trending_up,
                color: Colors.green,
                isDarkMode: isDarkMode,
              ),
              AnalyticsWidgets.buildFinancialCard(
                title: 'Net Cash',
                value: analytics.totals?.totalNetCash ?? 0.0,
                icon: Icons.account_balance_wallet,
                color: (analytics.totals?.totalNetCash ?? 0.0) < 0
                    ? Colors.red
                    : Colors.green,
                isDarkMode: isDarkMode,
                suffix: (analytics.totals?.totalNetCash ?? 0.0) < 0
                    ? ' (Loss)'
                    : '',
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Charity Contribution Section
          Text(
            'Charity Contribution',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.grey[900],
            ),
          ),
          const SizedBox(height: 12),
          if (analytics.charityCalculation != null) ...[
            AnalyticsWidgets.buildCharityCard(
              title: 'Total Charity',
              value: NumberFormat.currency(
                symbol: 'ETB ',
                decimalDigits: 2,
              ).format(analytics.charityCalculation!.charityAmount ?? 0.0),
              icon: Icons.favorite,
              isDarkMode: isDarkMode,
              subtitle:
                  'From ${analytics.charityCalculation!.totalKgHandled?.toStringAsFixed(1) ?? 0} kg handled',
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.grey[850]!.withOpacity(0.5)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.inventory_2_outlined,
                          color: Colors.blue, size: 24),
                      const SizedBox(height: 12),
                      Text(
                        'Cash AWBs (kg)',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        (analytics.charityCalculation!.totalCashAwbsKg ?? 0.0)
                            .toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.grey[900],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.grey[850]!.withOpacity(0.5)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.inventory_2_outlined,
                          color: Colors.blue, size: 24),
                      const SizedBox(height: 12),
                      Text(
                        'COD AWBs (kg)',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        (analytics.charityCalculation!.totalCodAwbsKg ?? 0.0)
                            .toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.grey[900],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 24),

          // Financial Breakdown Section
          Text(
            'Financial Breakdown',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.grey[900],
            ),
          ),
          const SizedBox(height: 12),
          if (analytics.financialOverview != null) ...[
            if (analytics.financialOverview!.today != null)
              AnalyticsWidgets.buildFinancialBreakdownCard(
                period: 'Today',
                financialPeriod: analytics.financialOverview!.today!,
                isDarkMode: isDarkMode,
              ),
            const SizedBox(height: 12),
            if (analytics.financialOverview!.week != null)
              AnalyticsWidgets.buildFinancialBreakdownCard(
                period: 'This Week',
                financialPeriod: analytics.financialOverview!.week!,
                isDarkMode: isDarkMode,
              ),
            const SizedBox(height: 12),
            if (analytics.financialOverview!.month != null)
              AnalyticsWidgets.buildFinancialBreakdownCard(
                period: 'This Month',
                financialPeriod: analytics.financialOverview!.month!,
                isDarkMode: isDarkMode,
              ),
          ],

          const SizedBox(height: 24),

          // Charts Section
          Text(
            'Deliveries Trend',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.grey[900],
            ),
          ),
          const SizedBox(height: 12),
          AnalyticsWidgets.buildDeliveriesTrendChart(
            deliveriesPerDay: analytics.deliveriesPerDay ?? [],
            isDarkMode: isDarkMode,
          ),

          const SizedBox(height: 24),

          Text(
            'Earnings Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.grey[900],
            ),
          ),
          const SizedBox(height: 12),
          AnalyticsWidgets.buildEarningsSummaryChart(
            earningsOverTime: analytics.earningsOverTime ?? [],
            isDarkMode: isDarkMode,
          ),

          const SizedBox(height: 24),

          // Delivery Time Distribution
          Text(
            'Delivery Time Distribution',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.grey[900],
            ),
          ),
          const SizedBox(height: 12),
          AnalyticsWidgets.buildDeliveryTimeDistributionChart(
            averageDeliveryTime: analytics.averageDeliveryTime ?? [],
            isDarkMode: isDarkMode,
          ),

          const SizedBox(height: 24),

          // Top Delivery Location
          AnalyticsWidgets.buildDeliveryLocationCard(
            deliveryLocations: analytics.deliveryLocations ?? [],
            isDarkMode: isDarkMode,
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

