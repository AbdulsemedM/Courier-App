import 'package:courier_app/core/theme/app_palette.dart';
import 'package:courier_app/features/public_tracking/model/public_tracking_models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class PublicTrackingWidgets {
  static Widget buildShimmer(BuildContext context) {
    final isDark = context.isDarkMode;
    final palette = AppPalette.forMode(isDark);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: isDark ? Colors.grey[850]! : palette.border,
        highlightColor: isDark ? Colors.grey[700]! : palette.surfaceMuted,
        child: Column(
          children: List.generate(
            3,
            (i) => Container(
              height: i == 0 ? 120 : 80,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget buildErrorState({
    required BuildContext context,
    required String message,
    required VoidCallback onRetry,
  }) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 64, color: palette.textSecondary),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: palette.textSecondary,
              fontSize: 15,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          TextButton.icon(
            onPressed: onRetry,
            icon: Icon(Icons.refresh_rounded, color: palette.accent),
            label: Text(
              'Try again',
              style: TextStyle(
                color: palette.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildShipmentList({
    required BuildContext context,
    required List<PublicShipmentSummary> summaries,
    required ValueChanged<String> onSelect,
  }) {
    final palette = context.palette;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: summaries.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = summaries[index];
        return Material(
          color: palette.surface,
          borderRadius: BorderRadius.circular(16),
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.08),
          child: InkWell(
            onTap: () => onSelect(item.awb),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: palette.accentMuted,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.inventory_2_outlined,
                      color: palette.accent,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.awb,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: palette.textPrimary,
                          ),
                        ),
                        if (item.statusLabel != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            item.statusLabel!,
                            style: TextStyle(
                              color: palette.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                        if (item.origin != null || item.destination != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            '${item.origin ?? '—'} → ${item.destination ?? '—'}',
                            style: TextStyle(
                              color: palette.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: palette.textSecondary),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget buildTrackingDetails({
    required BuildContext context,
    required List<PublicTrackingTimelineItem> events,
  }) {
    if (events.isEmpty) return const SizedBox.shrink();

    final palette = context.palette;
    final isDark = context.isDarkMode;
    final main = events.first;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderCard(context, main),
          const SizedBox(height: 16),
          if (main.origin != null || main.destination != null)
            _buildRouteCard(context, main),
          const SizedBox(height: 16),
          _buildTimelineCard(isDark, palette, events),
        ],
      ),
    );
  }

  static Widget _buildHeaderCard(
      BuildContext context, PublicTrackingTimelineItem main) {
    final palette = context.palette;
    final statusLabel = main.statusLabel ?? 'In transit';
    final statusColor = _getStatusColor(main.statusCode);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            palette.accent,
            palette.accent.withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: palette.accent.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tracking number',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            main.awb,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  statusLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildRouteCard(
      BuildContext context, PublicTrackingTimelineItem main) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _routePoint(
              palette,
              label: 'From',
              value: main.origin ?? '—',
              icon: Icons.trip_origin,
            ),
          ),
          Icon(Icons.arrow_forward_rounded, color: palette.accent, size: 20),
          Expanded(
            child: _routePoint(
              palette,
              label: 'To',
              value: main.destination ?? '—',
              icon: Icons.location_on_outlined,
              alignEnd: true,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _routePoint(
    AppPalette palette, {
    required String label,
    required String value,
    required IconData icon,
    bool alignEnd = false,
  }) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!alignEnd) Icon(icon, size: 14, color: palette.accent),
            if (!alignEnd) const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: palette.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (alignEnd) const SizedBox(width: 4),
            if (alignEnd) Icon(icon, size: 14, color: palette.accent),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  static Widget _buildTimelineCard(
    bool isDark,
    AppPalette palette,
    List<PublicTrackingTimelineItem> events,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timeline_rounded, color: palette.accent, size: 24),
              const SizedBox(width: 10),
              Text(
                'Status timeline',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: palette.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...List.generate(events.length, (index) {
            final event = events[index];
            final isLast = index == events.length - 1;
            final isFirst = index == 0;
            return _timelineItem(
              palette: palette,
              description: event.description,
              time: event.createdAt,
              statusLabel: event.statusLabel,
              isActive: isFirst,
              isLast: isLast,
            );
          }),
        ],
      ),
    );
  }

  static Widget _timelineItem({
    required AppPalette palette,
    required String description,
    required String? time,
    required String? statusLabel,
    required bool isActive,
    required bool isLast,
  }) {
    final dotColor = isActive ? palette.accent : palette.border;
    final formattedTime = _formatDate(time);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: isActive ? dotColor : palette.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: dotColor,
                    width: isActive ? 0 : 2,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: palette.border,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (statusLabel != null && statusLabel.isNotEmpty)
                    Text(
                      statusLabel,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: isActive
                            ? palette.accent
                            : palette.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(
                      color: palette.textSecondary,
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),
                  if (formattedTime != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      formattedTime,
                      style: TextStyle(
                        color: palette.textSecondary.withValues(alpha: 0.8),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Color _getStatusColor(String? statusCode) {
    switch (statusCode?.toUpperCase()) {
      case 'PAR':
        return Colors.orange;
      case 'DEL':
      case 'SUCCESS':
      case 'COMPLETED':
        return Colors.green;
      case 'PENDING':
        return Colors.blue;
      default:
        return Colors.deepPurple;
    }
  }

  static String? _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final dt = DateTime.parse(raw);
      return DateFormat('MMM d, yyyy · h:mm a').format(dt.toLocal());
    } catch (_) {
      return raw;
    }
  }
}
