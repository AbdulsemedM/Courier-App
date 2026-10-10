import 'package:courier_app/core/theme/app_palette.dart';
import 'package:courier_app/core/theme/app_typography.dart';
import 'package:courier_app/core/widgets/brand_widgets.dart';
import 'package:courier_app/core/widgets/status_chip.dart';
import 'package:courier_app/core/widgets/ui_primitives.dart';
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
                  ? [palette.background, palette.background]
                  : [palette.background, palette.scaffoldSecondary],
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
      margin: const EdgeInsets.only(top: 12, bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? const [Color(0xFF3A2380), Color(0xFF241552)]
              : const [Color(0xFF4F1D9E), BrandColors.purple, Color(0xFF2E0F66)],
        ),
        boxShadow: [
          BoxShadow(
            color: BrandColors.purple.withValues(alpha: isDarkMode ? 0.3 : 0.28),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned(
              right: -36,
              top: -36,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                    width: 18,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(height: 3, color: palette.accent),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Image.asset(
                      'assets/images/hudhud_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greetingForTime().toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.8,
                            color: Colors.white.withValues(alpha: 0.75),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          isLoadingRole ? 'Loading...' : displayRole,
                          style: AppFonts.heading(
                            fontSize: 24,
                            height: 1.15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'HudHud Express',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.8,
                            color: Colors.white.withValues(alpha: 0.7),
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
      padding: const EdgeInsets.fromLTRB(4, 20, 4, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppFonts.heading(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: context.isDarkMode ? palette.textPrimary : palette.primary,
            ),
          ),
          const SizedBox(height: 6),
          const BrandRule(width: 36),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
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
    return FadeSlideIn(
      child: _HomeActionCard(
        icon: icon,
        label: label,
        description: description,
        color: color,
        gradientStart: gradientStart,
        gradientEnd: gradientEnd,
        isDarkMode: isDarkMode,
        onTap: onTap,
      ),
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
    return FadeSlideIn(
      child: _HomeFeatureTile(
        icon: icon,
        title: title,
        subtitle: subtitle,
        accentColor: accentColor,
        isDarkMode: isDarkMode,
        onTap: onTap,
      ),
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
          decoration: palette.cardDecoration,
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
                      style: AppFonts.heading(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: palette.textPrimary,
                      ),
                    ),
                    StatusChip.auto(status),
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
              style: AppFonts.heading(
                fontSize: 16,
                fontWeight: FontWeight.w700,
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

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 100),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: palette.surface,
            border: Border.all(color: palette.border.withValues(alpha: 0.6)),
            boxShadow: [
              BoxShadow(
                color: palette.cardShadow,
                blurRadius: _pressed ? 6 : 12,
                offset: Offset(0, _pressed ? 2 : 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconBadge(icon: widget.icon, color: widget.color, size: 44),
                const SizedBox(height: 10),
                Text(
                  widget.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.15,
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
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: palette.surface,
            border: Border.all(color: palette.border),
            boxShadow: isDarkMode
                ? null
                : [
                    BoxShadow(
                      color: palette.cardShadow,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                IconBadge(icon: icon, color: accentColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppFonts.heading(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
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
