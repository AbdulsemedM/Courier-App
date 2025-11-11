import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:courier_app/features/analytics/model/analytics_dashboard_model.dart';

class AnalyticsWidgets {
  static Widget buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDarkMode,
  }) {
    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.grey[900],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildStatusCard({
    required String title,
    required int value,
    required IconData icon,
    required Color color,
    required bool isDarkMode,
  }) {
    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.grey[900],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildTargetCard({
    required String title,
    required int progress,
    required int target,
    required double percentage,
    required String status,
    required bool isDarkMode,
  }) {
    final isPass = status.toLowerCase() == 'pass';
    final progressColor = isPass ? Colors.green : Colors.red;
    
    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.grey[900],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: progressColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: progressColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '$progress/$target kg',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.grey[900],
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (progress / target).clamp(0.0, 1.0),
            backgroundColor: progressColor.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Text(
            '${percentage.toStringAsFixed(1)}% Achieved',
            style: TextStyle(
              fontSize: 12,
              color: progressColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFinancialCard({
    required String title,
    required double value,
    required IconData icon,
    required Color color,
    required bool isDarkMode,
    String? suffix,
  }) {
    final formattedValue = NumberFormat.currency(
      symbol: 'ETB ',
      decimalDigits: 2,
    ).format(value);
    
    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$formattedValue${suffix ?? ''}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFinancialBreakdownCard({
    required String period,
    required FinancialPeriod financialPeriod,
    required bool isDarkMode,
  }) {
    return Container(
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
          Text(
            period,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.grey[900],
            ),
          ),
          const SizedBox(height: 12),
          _buildFinancialRow('Cash', financialPeriod.cash ?? 0.0, Colors.green, isDarkMode),
          const SizedBox(height: 8),
          _buildFinancialRow('COD', financialPeriod.cod ?? 0.0, Colors.blue, isDarkMode),
          const SizedBox(height: 8),
          _buildFinancialRow('Expenses', financialPeriod.expenses ?? 0.0, Colors.orange, isDarkMode),
          const SizedBox(height: 8),
          _buildFinancialRow('Expected Net', financialPeriod.expectedNetCash ?? 0.0, Colors.green, isDarkMode),
        ],
      ),
    );
  }

  static Widget _buildFinancialRow(String label, double value, Color color, bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        Text(
          NumberFormat.currency(symbol: 'ETB ', decimalDigits: 2).format(value),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  static Widget buildCharityCard({
    required String title,
    required String value,
    required IconData icon,
    required bool isDarkMode,
    String? subtitle,
  }) {
    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.green, size: 24),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }

  static Widget buildDeliveriesTrendChart({
    required List<DeliveryPerDay> deliveriesPerDay,
    required bool isDarkMode,
  }) {
    if (deliveriesPerDay.isEmpty) {
      return Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode
              ? Colors.grey[850]!.withOpacity(0.5)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            'No data available',
            style: TextStyle(
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ),
      );
    }

    return Container(
      height: 200,
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
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < deliveriesPerDay.length) {
                    final date = deliveriesPerDay[value.toInt()].date;
                    if (date != null) {
                      try {
                        final dateTime = DateFormat('yyyy-MM-dd').parse(date);
                        return Text(
                          DateFormat('MMM dd').format(dateTime),
                          style: TextStyle(
                            fontSize: 10,
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          ),
                        );
                      } catch (e) {
                        return const Text('');
                      }
                    }
                  }
                  return const Text('');
                },
                reservedSize: 30,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      fontSize: 10,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  );
                },
                reservedSize: 40,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
            ),
          ),
          minX: 0,
          maxX: (deliveriesPerDay.length - 1).toDouble(),
          minY: 0,
          maxY: deliveriesPerDay.map((e) => e.deliveries ?? 0).reduce((a, b) => a > b ? a : b).toDouble() + 1,
          lineBarsData: [
            LineChartBarData(
              spots: deliveriesPerDay.asMap().entries.map((entry) {
                return FlSpot(
                  entry.key.toDouble(),
                  (entry.value.deliveries ?? 0).toDouble(),
                );
              }).toList(),
              isCurved: true,
              color: const Color(0xFF5b3895),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: const Color(0xFF5b3895).withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildEarningsSummaryChart({
    required List<EarningsOverTime> earningsOverTime,
    required bool isDarkMode,
  }) {
    if (earningsOverTime.isEmpty) {
      return Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode
              ? Colors.grey[850]!.withOpacity(0.5)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            'No data available',
            style: TextStyle(
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ),
      );
    }

    final maxValue = earningsOverTime.map((e) {
      final max = [
        e.revenue ?? 0,
        e.expenses ?? 0,
        e.profit ?? 0,
      ].reduce((a, b) => a > b ? a : b);
      return max;
    }).reduce((a, b) => a > b ? a : b);

    return Container(
      height: 200,
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
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxValue + (maxValue * 0.2),
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < earningsOverTime.length) {
                    final period = earningsOverTime[value.toInt()].period ?? '';
                    return Text(
                      period,
                      style: TextStyle(
                        fontSize: 10,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    );
                  }
                  return const Text('');
                },
                reservedSize: 30,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      fontSize: 10,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  );
                },
                reservedSize: 40,
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
            ),
          ),
          barGroups: earningsOverTime.asMap().entries.map((entry) {
            final index = entry.key;
            final earnings = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: earnings.revenue ?? 0,
                  color: Colors.blue,
                  width: 8,
                ),
                BarChartRodData(
                  toY: earnings.expenses ?? 0,
                  color: Colors.orange,
                  width: 8,
                ),
                BarChartRodData(
                  toY: earnings.profit ?? 0,
                  color: Colors.green,
                  width: 8,
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  static Widget buildDeliveryTimeDistributionChart({
    required List<AverageDeliveryTime> averageDeliveryTime,
    required bool isDarkMode,
  }) {
    if (averageDeliveryTime.isEmpty || averageDeliveryTime.every((e) => (e.count ?? 0) == 0)) {
      return Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode
              ? Colors.grey[850]!.withOpacity(0.5)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            'No data available',
            style: TextStyle(
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ),
      );
    }

    final colors = [Colors.green, Colors.blue, Colors.orange, Colors.red];
    
    return Container(
      height: 200,
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
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: averageDeliveryTime.map((e) => e.count ?? 0).reduce((a, b) => a > b ? a : b).toDouble() + 1,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < averageDeliveryTime.length) {
                    final timeRange = averageDeliveryTime[value.toInt()].timeRange ?? '';
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        timeRange,
                        style: TextStyle(
                          fontSize: 9,
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return const Text('');
                },
                reservedSize: 40,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      fontSize: 10,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  );
                },
                reservedSize: 40,
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
            ),
          ),
          barGroups: averageDeliveryTime.asMap().entries.map((entry) {
            final index = entry.key;
            final timeData = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: (timeData.count ?? 0).toDouble(),
                  color: colors[index % colors.length],
                  width: 20,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  static Widget buildDeliveryLocationCard({
    required List<DeliveryLocation> deliveryLocations,
    required bool isDarkMode,
  }) {
    if (deliveryLocations.isEmpty) {
      return Container(
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
            Text(
              'Top Delivery Location',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.grey[900],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Text(
                    'N/A',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '0 deliveries',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '0% of total',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final topLocation = deliveryLocations.first;

    return Container(
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
          Text(
            'Top Delivery Location',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.grey[900],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            topLocation.location ?? 'N/A',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.grey[900],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${topLocation.count ?? 0} deliveries',
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: (topLocation.percentage ?? 0) / 100,
                  backgroundColor: const Color(0xFF5b3895).withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF5b3895)),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${topLocation.percentage?.toStringAsFixed(1) ?? 0}% of total',
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

