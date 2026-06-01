import 'package:courier_app/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeWidgets {
  static String greetingForTime() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  static Widget buildPageBackground({
    required bool isDarkMode,
    required Widget child,
  }) {
    return Builder(
      builder: (context) {
        final palette = context.palette;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDarkMode
                  ? [
                      palette.background,
                      const Color(0xFF0F2444),
                      palette.background,
                    ]
                  : [
                      palette.background,
                      palette.accentMuted.withValues(alpha: 0.4),
                      palette.scaffoldSecondary,
                    ],
            ),
          ),
          child: child,
        );
      },
    );
  }

  static Widget buildWelcomeHero({
    required BuildContext context,
    required bool isDarkMode,
    required String displayRole,
    required bool isLoadingRole,
  }) {
    final palette = context.palette;

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
                  const Color(0xFFFF5A00).withValues(alpha: 0.85),
                  const Color(0xFFC2410C),
                  const Color(0xFF1E3A5F),
                ]
              : [
                  const Color(0xFFFF7A33),
                  const Color(0xFFFF5A00),
                  const Color(0xFFE85D04),
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: palette.accent.withValues(alpha: isDarkMode ? 0.25 : 0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.12),
                ),
              ),
            ),
            Positioned(
              left: -20,
              bottom: -30,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.22),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.45),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.local_shipping_rounded,
                      size: 28,
                      color: Colors.white.withValues(alpha: 0.95),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greetingForTime(),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isLoadingRole ? 'Loading...' : displayRole,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                            letterSpacing: -0.5,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'HudHud Courier',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                              color: Colors.white.withValues(alpha: 0.95),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildSectionHeader({
    required BuildContext context,
    required String title,
    String? subtitle,
  }) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
              color: palette.textPrimary,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: palette.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  static Widget buildQuickActionCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String description,
    required Color color,
    required Color gradientStart,
    required Color gradientEnd,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return _HomeActionCard(
      icon: icon,
      label: label,
      description: description,
      color: color,
      gradientStart: gradientStart,
      gradientEnd: gradientEnd,
      isDarkMode: isDarkMode,
      onTap: onTap,
    );
  }

  static Widget buildFeatureTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color accentColor,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return _HomeFeatureTile(
      icon: icon,
      title: title,
      subtitle: subtitle,
      accentColor: accentColor,
      isDarkMode: isDarkMode,
      onTap: onTap,
    );
  }

  // Legacy helpers kept for compatibility
  static Widget buildEnhancedActionCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String description,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return buildQuickActionCard(
      context: context,
      icon: icon,
      label: label,
      description: description,
      color: context.palette.accent,
      gradientStart: context.palette.accentMuted,
      gradientEnd: context.palette.surface,
      onTap: onTap,
      isDarkMode: isDarkMode,
    );
  }

  static Widget buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool? isDarkMode,
  }) {
    return Builder(
      builder: (context) => buildQuickActionCard(
        context: context,
        icon: icon,
        label: label,
        description: '',
        color: context.palette.accent,
        gradientStart: context.palette.accentMuted,
        gradientEnd: context.palette.surface,
        onTap: onTap,
        isDarkMode: isDarkMode ?? context.isDarkMode,
      ),
    );
  }

  static Widget buildDeliveryCard({
    required String orderNumber,
    required String status,
    required String address,
    required String date,
    bool? isDarkMode,
  }) {
    return Builder(
      builder: (context) {
        final palette = context.palette;

        return Container(
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: palette.border),
            boxShadow: [
              BoxShadow(
                color: palette.cardShadow,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      orderNumber,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: palette.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: palette.accentMuted,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: palette.accent,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(address, style: TextStyle(color: palette.textSecondary)),
                const SizedBox(height: 4),
                Text(date, style: TextStyle(color: palette.textSecondary)),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget buildStatisticItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isDarkMode,
  }) {
    return Builder(
      builder: (context) {
        final palette = context.palette;
        return Column(
          children: [
            Icon(icon, size: 28, color: palette.accent),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: palette.textSecondary,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: palette.textPrimary,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _HomeActionCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String description;
  final Color color;
  final Color gradientStart;
  final Color gradientEnd;
  final bool isDarkMode;
  final VoidCallback onTap;

  const _HomeActionCard({
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
    required this.gradientStart,
    required this.gradientEnd,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  State<_HomeActionCard> createState() => _HomeActionCardState();
}

class _HomeActionCardState extends State<_HomeActionCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDark = widget.isDarkMode;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1,
        duration: const Duration(milliseconds: 100),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      Color.alphaBlend(
                        widget.color.withValues(alpha: 0.3),
                        palette.surface,
                      ),
                      palette.surface,
                    ]
                  : [widget.gradientStart, widget.gradientEnd],
            ),
            border: Border.all(
              color: isDark
                  ? widget.color.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.9),
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: isDark ? 0.15 : 0.14),
                blurRadius: _pressed ? 6 : 12,
                offset: Offset(0, _pressed ? 3 : 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.white.withValues(alpha: 0.9),
                  ),
                  child: Icon(
                    widget.icon,
                    size: 22,
                    color: widget.color,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                    color: palette.textPrimary,
                  ),
                ),
                if (widget.description.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    widget.description,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9.5,
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeFeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final bool isDarkMode;
  final VoidCallback onTap;

  const _HomeFeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: palette.surface,
            border: Border.all(color: palette.border),
            boxShadow: isDarkMode
                ? null
                : [
                    BoxShadow(
                      color: palette.cardShadow.withValues(alpha: 0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        accentColor.withValues(alpha: 0.2),
                        accentColor.withValues(alpha: 0.08),
                      ],
                    ),
                  ),
                  child: Icon(icon, color: accentColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: palette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: palette.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
