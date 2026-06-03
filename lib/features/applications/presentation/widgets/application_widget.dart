// import 'package:courier_app/features/add_shipment/presentation/screens/payment_screen.dart';
import 'package:courier_app/app/utils/responsive_helper.dart';
import 'package:courier_app/features/comming_soon/coming_soon_screen.dart';
// import 'package:courier_app/features/miles_configuration/presentation/screens/miles_configuration_screen.dart';
import 'package:courier_app/features/pay_by_awb/presentation/screen/pay_by_awb_screen.dart';
// import 'package:courier_app/features/roles/presentation/screen/roles_screen.dart';
import 'package:courier_app/features/shelves_management/presentation/screen/shelves_screen.dart';
import 'package:courier_app/features/shipment/presentation/screens/shipments_screen.dart';
import 'package:courier_app/features/shipment_invoice/presentation/screens/shipment_invoice_screen.dart';
import 'package:courier_app/features/home_delivery/presentation/screens/home_deliveries_screen.dart';
import 'package:courier_app/features/manifest/presentation/screens/manifest_screen.dart';
import 'package:courier_app/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ApplicationWidgets {
  static Widget buildApplicationsBody({
    required BuildContext context,
    required bool isDarkMode,
    required List<MenuOption> options,
    required Function(Widget) onOptionSelected,
  }) {
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
                  palette.accentMuted.withValues(alpha: 0.35),
                  palette.scaffoldSecondary,
                ],
        ),
      ),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your workspace',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.4,
                      color: palette.accent,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Pick a tool to get started',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      letterSpacing: -0.4,
                      color: palette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${options.length} apps available',
                    style: TextStyle(
                      fontSize: 11,
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: ResponsiveHelper.getResponsivePadding(
              context,
              mobile: const EdgeInsets.fromLTRB(12, 8, 12, 20),
              tablet: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              desktop: const EdgeInsets.fromLTRB(28, 16, 28, 36),
            ),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(
                  context,
                  mobile: 3,
                  tablet: 4,
                  desktop: 5,
                ),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio:
                    ResponsiveHelper.isTablet(context) ? 0.95 : 0.9,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final option = options[index];
                  return _ApplicationMenuCard(
                    option: option,
                    isDarkMode: isDarkMode,
                    onTap: () => onOptionSelected(option.screen),
                  );
                },
                childCount: options.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @Deprecated('Use buildApplicationsBody')
  static Widget buildMenuGrid({
    required BuildContext context,
    required bool isDarkMode,
    required List<MenuOption> options,
    required Function(Widget) onOptionSelected,
  }) {
    return buildApplicationsBody(
      context: context,
      isDarkMode: isDarkMode,
      options: options,
      onOptionSelected: onOptionSelected,
    );
  }

  static Widget buildEmptyState({required bool isDarkMode}) {
    final palette = AppPalette.forMode(isDarkMode);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: palette.accentMuted,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.apps_rounded,
              size: 48,
              color: palette.accent,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No applications yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new tools',
            style: TextStyle(color: palette.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ApplicationMenuCard extends StatefulWidget {
  final MenuOption option;
  final bool isDarkMode;
  final VoidCallback onTap;

  const _ApplicationMenuCard({
    required this.option,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  State<_ApplicationMenuCard> createState() => _ApplicationMenuCardState();
}

class _ApplicationMenuCardState extends State<_ApplicationMenuCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final option = widget.option;
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
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      Color.alphaBlend(
                        option.color.withValues(alpha: 0.35),
                        palette.surface,
                      ),
                      palette.surface,
                    ]
                  : [
                      option.gradientStart,
                      option.gradientEnd,
                    ],
            ),
            border: Border.all(
              color: isDark
                  ? option.color.withValues(alpha: 0.35)
                  : Colors.white.withValues(alpha: 0.9),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: option.color.withValues(alpha: isDark ? 0.2 : 0.18),
                blurRadius: _pressed ? 6 : 12,
                offset: Offset(0, _pressed ? 3 : 6),
              ),
              if (!isDark)
                BoxShadow(
                  color: palette.cardShadow.withValues(alpha: 0.06),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Positioned(
                  right: -18,
                  top: -18,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: option.color.withValues(alpha: 0.12),
                    ),
                  ),
                ),
                Positioned(
                  left: -12,
                  bottom: -14,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: option.color.withValues(alpha: 0.08),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _IconBadge(
                            icon: option.icon,
                            color: option.color,
                            isDark: isDark,
                          ),
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.1)
                                  : Colors.white.withValues(alpha: 0.75),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Icon(
                              Icons.arrow_outward_rounded,
                              size: 11,
                              color: option.color,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        option.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                          letterSpacing: -0.2,
                          color: palette.textPrimary,
                        ),
                      ),
                      if (option.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          option.subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w500,
                            color: palette.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool isDark;

  const _IconBadge({
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        color: isDark
            ? Colors.white.withValues(alpha: 0.12)
            : Colors.white.withValues(alpha: 0.92),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.22),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: 19,
        color: color,
      ),
    );
  }
}

class MenuOption {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final Color gradientStart;
  final Color gradientEnd;
  final Widget screen;

  const MenuOption({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.color,
    Color? gradientStart,
    Color? gradientEnd,
    required this.screen,
  })  : gradientStart = gradientStart ?? color,
        gradientEnd = gradientEnd ?? color;

  MenuOption copyWithGradients({
    required Color gradientStart,
    required Color gradientEnd,
  }) {
    return MenuOption(
      title: title,
      subtitle: subtitle,
      icon: icon,
      color: color,
      gradientStart: gradientStart,
      gradientEnd: gradientEnd,
      screen: screen,
    );
  }
}

final List<MenuOption> defaultMenuOptions = [
  MenuOption(
    title: 'Pay by AWB',
    subtitle: 'Quick payment lookup',
    icon: Icons.payments_rounded,
    color: const Color(0xFF1D4ED8),
    gradientStart: const Color(0xFFEFF6FF),
    gradientEnd: const Color(0xFFDBEAFE),
    screen: const PayByAwbScreen(),
  ),
  MenuOption(
    title: 'Shipment Invoice',
    subtitle: 'Scan & print invoice',
    icon: Icons.receipt_long_rounded,
    color: const Color(0xFF6D28D9),
    gradientStart: const Color(0xFFF5F3FF),
    gradientEnd: const Color(0xFFEDE9FE),
    screen: const ShipmentInvoiceScreen(),
  ),
  MenuOption(
    title: 'All Shipments',
    subtitle: 'Track every shipment',
    icon: Icons.local_shipping_rounded,
    color: const Color(0xFFC2410C),
    gradientStart: const Color(0xFFFFF7ED),
    gradientEnd: const Color(0xFFFFEDD5),
    screen: const ShipmentsScreen(),
  ),
  MenuOption(
    title: 'Manifest',
    subtitle: 'Create & view manifests',
    icon: Icons.fact_check_rounded,
    color: const Color(0xFF4338CA),
    gradientStart: const Color(0xFFEEF2FF),
    gradientEnd: const Color(0xFFE0E7FF),
    screen: const ManifestScreen(),
  ),
  MenuOption(
    title: 'Home Deliveries',
    subtitle: 'Assign & track deliveries',
    icon: Icons.delivery_dining_rounded,
    color: const Color(0xFFBE185D),
    gradientStart: const Color(0xFFFDF2F8),
    gradientEnd: const Color(0xFFFCE7F3),
    screen: const HomeDeliveriesScreen(),
  ),
  MenuOption(
    title: 'Add Extra Fee',
    subtitle: 'Apply additional charges',
    icon: Icons.add_circle_outline_rounded,
    color: const Color(0xFF0F766E),
    gradientStart: const Color(0xFFF0FDFA),
    gradientEnd: const Color(0xFFCCFBF1),
    screen: const ComingSoonScreen(),
  ),
  MenuOption(
    title: 'Shelves',
    subtitle: 'Branch shelf layout',
    icon: Icons.grid_view_rounded,
    color: const Color(0xFF0369A1),
    gradientStart: const Color(0xFFF0F9FF),
    gradientEnd: const Color(0xFFE0F2FE),
    screen: const ShelvesScreen(),
  ),
  // Miles Configuration, Roles, Other Settings — hidden per product request
];
