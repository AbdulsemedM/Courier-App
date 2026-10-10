import 'package:courier_app/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

/// Semantic tone for a [StatusChip].
enum StatusTone { success, warning, danger, info, neutral, brand }

/// Unified status badge (paid, pending, delivered, failed, COD, ...)
/// rendered in soft, muted tones from the brand palette.
class StatusChip extends StatelessWidget {
  final String label;
  final StatusTone tone;
  final IconData? icon;
  final bool compact;

  const StatusChip({
    super.key,
    required this.label,
    this.tone = StatusTone.neutral,
    this.icon,
    this.compact = false,
  });

  /// Maps free-form payment / shipment status text to a tone.
  static StatusTone toneForLabel(String? raw) {
    final value = (raw ?? '').trim().toUpperCase();
    if (value.isEmpty) return StatusTone.neutral;
    if (value == 'SUCCESS' ||
        value == 'PAID' ||
        value.contains('DELIVERED') ||
        value == 'COMPLETED') {
      return StatusTone.success;
    }
    if (value == 'PENDING' || value == 'COD' || value.contains('PENDING')) {
      return StatusTone.warning;
    }
    if (value == 'FAILED' ||
        value == 'CANCELLED' ||
        value == 'REJECTED' ||
        value.contains('FAIL')) {
      return StatusTone.danger;
    }
    return StatusTone.info;
  }

  /// Convenience constructor that picks the tone from the label.
  factory StatusChip.auto(String label, {IconData? icon, bool compact = false}) {
    return StatusChip(
      label: label,
      tone: toneForLabel(label),
      icon: icon,
      compact: compact,
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    late final Color fg;
    late final Color bg;
    switch (tone) {
      case StatusTone.success:
        fg = palette.success;
        bg = palette.successSoft;
      case StatusTone.warning:
        fg = palette.warning;
        bg = palette.warningSoft;
      case StatusTone.danger:
        fg = palette.danger;
        bg = palette.dangerSoft;
      case StatusTone.info:
        fg = palette.info;
        bg = palette.infoSoft;
      case StatusTone.brand:
        fg = context.isDarkMode ? const Color(0xFFB79CF0) : palette.primary;
        bg = palette.primarySoft;
      case StatusTone.neutral:
        fg = palette.textSecondary;
        bg = palette.surfaceMuted;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 3 : 6,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: compact ? 12 : 14, color: fg),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: fg,
                fontSize: compact ? 11 : 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
