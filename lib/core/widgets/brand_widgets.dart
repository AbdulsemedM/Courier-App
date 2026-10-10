import 'package:courier_app/core/theme/app_palette.dart';
import 'package:courier_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Thin orange rule echoing the line under the HudHud logo.
class BrandRule extends StatelessWidget {
  final double width;
  final double thickness;

  const BrandRule({super.key, this.width = 48, this.thickness = 2});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: thickness,
      decoration: BoxDecoration(
        color: context.palette.accent,
        borderRadius: BorderRadius.circular(thickness),
      ),
    );
  }
}

/// Serif section title with the orange signature rule beneath it.
class SectionHeading extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Widget? trailing;

  const SectionHeading({
    super.key,
    required this.title,
    this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final color = context.isDarkMode ? palette.textPrimary : palette.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: palette.accent),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                title,
                style: AppFonts.heading(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
        const SizedBox(height: 6),
        const BrandRule(),
      ],
    );
  }
}

/// Elegant surface card used for grouped content.
class BrandCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  const BrandCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: context.palette.cardDecoration,
      child: child,
    );
  }
}

/// Gentle fade + rise entrance. Purely visual; wraps any child.
class FadeSlideIn extends StatelessWidget {
  final Widget child;
  final int index;
  final Duration duration;

  const FadeSlideIn({
    super.key,
    required this.child,
    this.index = 0,
    this.duration = const Duration(milliseconds: 320),
  });

  @override
  Widget build(BuildContext context) {
    final delay = (index.clamp(0, 8)) * 45;
    final total = duration.inMilliseconds + delay;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: total),
      curve: Curves.linear,
      child: child,
      builder: (context, t, child) {
        final p = ((t * total - delay) / duration.inMilliseconds).clamp(0.0, 1.0);
        final eased = Curves.easeOutCubic.transform(p);
        return Opacity(
          opacity: eased,
          child: Transform.translate(
            offset: Offset(0, (1 - eased) * 14),
            child: child,
          ),
        );
      },
    );
  }
}
