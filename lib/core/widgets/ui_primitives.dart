import 'package:courier_app/core/theme/app_palette.dart';
import 'package:courier_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Subtle scale-on-press wrapper. Visual only.
class PressableScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;
  final BorderRadius? borderRadius;

  const PressableScale({
    super.key,
    required this.child,
    this.onTap,
    this.pressedScale = 0.97,
    this.borderRadius,
  });

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap == null ? null : (_) => setState(() => _pressed = true),
      onTapUp: widget.onTap == null ? null : (_) => setState(() => _pressed = false),
      onTapCancel: widget.onTap == null ? null : () => setState(() => _pressed = false),
      onTap: widget.onTap == null
          ? null
          : () {
              HapticFeedback.lightImpact();
              widget.onTap!();
            },
      child: AnimatedScale(
        scale: _pressed ? widget.pressedScale : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}

class IconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const IconBadge({
    super.key,
    required this.icon,
    required this.color,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.32),
        color: color.withValues(alpha: 0.12),
      ),
      child: Icon(icon, size: size * 0.5, color: color),
    );
  }
}

class SkeletonBox extends StatefulWidget {
  final double height;
  final double? width;
  final BorderRadius? borderRadius;

  const SkeletonBox({
    super.key,
    this.height = 16,
    this.width,
    this.borderRadius,
  });

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment(-1 + _c.value * 2, 0),
              end: Alignment(_c.value * 2, 0),
              colors: [
                palette.surfaceMuted,
                palette.border.withValues(alpha: 0.55),
                palette.surfaceMuted,
              ],
            ),
          ),
        );
      },
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? hint;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconBadge(icon: icon, color: palette.accent, size: 72),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppFonts.heading(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
              ),
            ),
            if (hint != null) ...[
              const SizedBox(height: 8),
              Text(
                hint!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: palette.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class StepIndicator extends StatelessWidget {
  final int current;
  final List<String> labels;

  const StepIndicator({
    super.key,
    required this.current,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        children: [
          Row(
            children: List.generate(labels.length, (index) {
              final isActive = index == current;
              final isCompleted = index < current;
              return Expanded(
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: isActive
                            ? palette.accent
                            : (isCompleted ? palette.primary : palette.surfaceMuted),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isActive || isCompleted
                              ? Colors.transparent
                              : palette.border,
                        ),
                      ),
                      child: Center(
                        child: isCompleted
                            ? const Icon(Icons.check, size: 16, color: Colors.white)
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: isActive ? Colors.white : palette.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                    if (index < labels.length - 1)
                      Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          height: 2,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          color: isCompleted ? palette.accent : palette.border,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(labels.length, (index) {
              final isActive = index == current;
              final isCompleted = index < current;
              return Expanded(
                child: Text(
                  labels[index],
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive
                        ? palette.textPrimary
                        : (isCompleted ? palette.accent : palette.textSecondary),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
