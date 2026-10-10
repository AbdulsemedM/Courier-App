import 'package:courier_app/core/theme/app_palette.dart';
import 'package:courier_app/core/theme/app_typography.dart';
import 'package:courier_app/core/widgets/brand_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginWidgets {
  static Widget buildBackground({
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
                  ? [palette.background, palette.surface]
                  : [palette.background, palette.scaffoldSecondary],
            ),
          ),
          child: child,
        );
      },
    );
  }

  static Widget buildBrandHero({
    required bool isDarkMode,
    required VoidCallback? onToggleTheme,
    required bool isDarkModeActive,
  }) {
    return Builder(
      builder: (context) {
        final palette = context.palette;
        final headline = isDarkMode ? palette.textPrimary : palette.primary;
        final subtitle =
            isDarkMode ? palette.textSecondary : palette.textSecondary;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 44),
          decoration: BoxDecoration(
            gradient: isDarkMode
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF33206B), Color(0xFF15101F)],
                  )
                : null,
            color: isDarkMode ? null : palette.background,
            border: Border(
              bottom: BorderSide(
                color: palette.accent.withValues(alpha: 0.7),
                width: 1,
              ),
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'STAFF PORTAL',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                      color: palette.textSecondary,
                    ),
                  ),
                  if (onToggleTheme != null)
                    Material(
                      color: palette.surfaceMuted.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: onToggleTheme,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            isDarkModeActive
                                ? Icons.light_mode_outlined
                                : Icons.dark_mode_outlined,
                            color: palette.textPrimary,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: Container(
                  padding: isDarkMode
                      ? const EdgeInsets.symmetric(horizontal: 22, vertical: 14)
                      : EdgeInsets.zero,
                  decoration: isDarkMode
                      ? BoxDecoration(
                          color: BrandColors.ivory,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        )
                      : null,
                  child: Image.asset(
                    'assets/images/hudhud_logo.png',
                    height: 84,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 26),
              const Center(child: BrandRule(width: 56)),
              const SizedBox(height: 18),
              Center(
                child: Text(
                  'Move faster.\nDeliver smarter.',
                  textAlign: TextAlign.center,
                  style: AppFonts.heading(
                    fontSize: 28,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                    color: headline,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Sign in to manage shipments, manifests & more',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.4,
                    color: subtitle,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget buildPublicTrackPromoCard({
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    return Builder(
      builder: (context) {
        final palette = context.palette;

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                onTap();
              },
              borderRadius: BorderRadius.circular(16),
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: palette.surface,
                  border: Border.all(color: palette.border),
                  boxShadow: [
                    BoxShadow(
                      color: palette.cardShadow,
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _PulsingRadarIcon(),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Track your shipment',
                                    style: AppFonts.heading(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: isDarkMode
                                          ? palette.textPrimary
                                          : palette.primary,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: palette.accentMuted,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'FREE · NO LOGIN',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: palette.accent,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'AWB · phone · tracking number',
                              style: TextStyle(
                                fontSize: 12,
                                color: palette.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: palette.accent,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget buildLoginCard({
    required bool isDarkMode,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required bool obscurePassword,
    required bool rememberMe,
    required bool isLoading,
    required VoidCallback onTogglePassword,
    required ValueChanged<bool> onRememberMeChanged,
    required VoidCallback onLogin,
    required VoidCallback onForgotPassword,
  }) {
    return Builder(
      builder: (context) {
        final palette = context.palette;
        final linkColor =
            isDarkMode ? const Color(0xFFB79CF0) : palette.primary;

        return Transform.translate(
          offset: const Offset(0, -28),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 24),
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: palette.border),
              boxShadow: [
                BoxShadow(
                  color: palette.cardShadow,
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Welcome back',
                    style: AppFonts.heading(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? palette.textPrimary : palette.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: BrandRule(),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Enter your credentials to continue',
                    style: TextStyle(
                      fontSize: 13,
                      color: palette.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 22),
                  _LoginTextField(
                    controller: emailController,
                    label: 'Email',
                    hint: 'you@company.com',
                    icon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                    enabled: !isLoading,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _LoginTextField(
                    controller: passwordController,
                    label: 'Password',
                    hint: '••••••••',
                    icon: Icons.lock_outline_rounded,
                    obscureText: obscurePassword,
                    enabled: !isLoading,
                    suffix: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: palette.textSecondary,
                        size: 20,
                      ),
                      onPressed: onTogglePassword,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'At least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: rememberMe,
                          onChanged: isLoading
                              ? null
                              : (v) => onRememberMeChanged(v ?? false),
                          activeColor: palette.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: isLoading
                              ? null
                              : () => onRememberMeChanged(!rememberMe),
                          child: Text(
                            'Remember me',
                            style: TextStyle(
                              fontSize: 14,
                              color: palette.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: isLoading ? null : onForgotPassword,
                        style: TextButton.styleFrom(
                          foregroundColor: linkColor,
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _LoginButton(
                    label: 'Sign in',
                    isLoading: isLoading,
                    onPressed: isLoading ? null : onLogin,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final bool enabled;
  final TextInputType? keyboardType;
  final Widget? suffix;
  final String? Function(String?)? validator;

  const _LoginTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.enabled = true,
    this.keyboardType,
    this.suffix,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final focusColor =
        context.isDarkMode ? const Color(0xFFB79CF0) : palette.primary;

    return TextFormField(
      controller: controller,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
        color: palette.textPrimary,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: palette.textSecondary),
        hintStyle: TextStyle(color: palette.textSecondary.withValues(alpha: 0.7)),
        prefixIcon: Icon(icon, color: focusColor, size: 22),
        suffixIcon: suffix,
        filled: true,
        fillColor: palette.surfaceMuted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: focusColor, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.danger, width: 1.6),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

class _PulsingRadarIcon extends StatefulWidget {
  @override
  State<_PulsingRadarIcon> createState() => _PulsingRadarIconState();
}

class _PulsingRadarIconState extends State<_PulsingRadarIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: palette.primary,
            boxShadow: [
              BoxShadow(
                color: palette.accent
                    .withValues(alpha: 0.12 + _controller.value * 0.18),
                blurRadius: 10 + _controller.value * 8,
                spreadRadius: _controller.value * 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.radar_rounded,
            color: Colors.white,
            size: 26,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;

  const _LoginButton({
    required this.label,
    required this.isLoading,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed == null
            ? null
            : () {
                HapticFeedback.lightImpact();
                onPressed!();
              },
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: onPressed == null ? palette.border : palette.primary,
            boxShadow: onPressed == null
                ? null
                : [
                    BoxShadow(
                      color: palette.primary.withValues(alpha: 0.28),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.4,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
