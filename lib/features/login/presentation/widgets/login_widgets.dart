import 'package:courier_app/core/theme/app_palette.dart';
import 'package:courier_app/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginWidgets {
  static Widget buildBackground({
    required bool isDarkMode,
    required Widget child,
  }) {
    return Builder(
      builder: (context) {
        return ColoredBox(
          color: context.palette.background,
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
        return Padding(
          padding: const EdgeInsets.fromLTRB(28, 4, 16, 0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: onToggleTheme == null
                    ? const SizedBox(height: 40)
                    : IconButton(
                        tooltip: isDarkModeActive ? 'Light mode' : 'Dark mode',
                        onPressed: onToggleTheme,
                        icon: Icon(
                          isDarkModeActive
                              ? Icons.light_mode_outlined
                              : Icons.dark_mode_outlined,
                          color: palette.textSecondary,
                        ),
                      ),
              ),
              const SizedBox(height: 12),
              Image.asset(
                'assets/images/hudhud_logo.png',
                height: 56,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 28),
              Text(
                'Welcome back',
                style: AppFonts.heading(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? palette.textPrimary : palette.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to continue',
                style: TextStyle(
                  fontSize: 15,
                  color: palette.textSecondary,
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
          padding: const EdgeInsets.fromLTRB(28, 8, 28, 0),
          child: Center(
            child: TextButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                onTap();
              },
              child: Text(
                'Track a shipment without signing in',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? palette.accent : palette.primary,
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

        return Padding(
          padding: const EdgeInsets.fromLTRB(28, 36, 28, 0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                  hint: 'Your password',
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
                        visualDensity: VisualDensity.compact,
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
                            fontSize: 13,
                            color: palette.textSecondary,
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
                const SizedBox(height: 28),
                SizedBox(
                  height: 52,
                  child: FilledButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            HapticFeedback.lightImpact();
                            onLogin();
                          },
                    child: isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Sign in'),
                  ),
                ),
              ],
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
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: palette.textSecondary, size: 22),
        suffixIcon: suffix,
        filled: true,
        fillColor: palette.surface,
        labelStyle: TextStyle(color: palette.textSecondary),
        hintStyle: TextStyle(
          color: palette.textSecondary.withValues(alpha: 0.7),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: focusColor, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: palette.danger, width: 1.4),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      ),
    );
  }
}
