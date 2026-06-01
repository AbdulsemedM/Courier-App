import 'package:courier_app/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsWidgets {
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
                      palette.accentMuted.withValues(alpha: 0.35),
                      palette.scaffoldSecondary,
                    ],
            ),
          ),
          child: child,
        );
      },
    );
  }

  static Widget buildProfileHero({
    required String name,
    String? email,
    String? imageUrl,
    VoidCallback? onTap,
  }) {
    final initial =
        name.trim().isNotEmpty && name != '...' ? name.trim()[0].toUpperCase() : '?';

    return Builder(
      builder: (context) {
        return Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFF7A33),
                Color(0xFFFF5A00),
                Color(0xFFE85D04),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: context.palette.accent.withValues(alpha: 0.3),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                Positioned(
                  right: -24,
                  top: -24,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onTap,
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        children: [
                          Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.6),
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.12),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: imageUrl != null && imageUrl.isNotEmpty
                                ? ClipOval(
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      initial,
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFFFF5A00),
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.4,
                                    color: Colors.white,
                                  ),
                                ),
                                if (email != null && email.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.mail_outline_rounded,
                                        size: 14,
                                        color: Colors.white.withValues(alpha: 0.8),
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          email,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.white.withValues(alpha: 0.85),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                const SizedBox(height: 8),
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
                                    'Signed in',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white.withValues(alpha: 0.95),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget buildSectionLabel(String title, {String? subtitle}) {
    return Builder(
      builder: (context) {
        final palette = context.palette;
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: palette.textSecondary,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: palette.textSecondary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  static Widget buildSettingsGroup({
    required List<Widget> children,
  }) {
    return Builder(
      builder: (context) {
        final palette = context.palette;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: palette.border),
            boxShadow: [
              BoxShadow(
                color: palette.cardShadow.withValues(alpha: 0.4),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: _intersperse(children, _divider(palette)),
          ),
        );
      },
    );
  }

  static Widget _divider(AppPalette palette) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 58,
      color: palette.border.withValues(alpha: 0.6),
    );
  }

  static List<Widget> _intersperse(List<Widget> items, Widget separator) {
    if (items.isEmpty) return items;
    final result = <Widget>[items.first];
    for (var i = 1; i < items.length; i++) {
      result.add(separator);
      result.add(items[i]);
    }
    return result;
  }

  static Widget buildNavRow({
    required String title,
    required IconData icon,
    required Color accentColor,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return _SettingsRow(
      title: title,
      subtitle: subtitle,
      icon: icon,
      accentColor: accentColor,
      onTap: onTap,
      trailing: const Icon(Icons.chevron_right_rounded, size: 22),
    );
  }

  static Widget buildToggleRow({
    required String title,
    required IconData icon,
    required Color accentColor,
    required bool value,
    required ValueChanged<bool> onChanged,
    String? subtitle,
  }) {
    return Builder(
      builder: (context) {
        final palette = context.palette;
        return _SettingsRow(
          title: title,
          subtitle: subtitle,
          icon: icon,
          accentColor: accentColor,
          trailing: Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: palette.accent.withValues(alpha: 0.5),
            activeThumbColor: palette.accent,
          ),
        );
      },
    );
  }

  static Widget buildLogoutButton({
    required VoidCallback onPressed,
  }) {
    return Builder(
      builder: (context) {
        final palette = context.palette;
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.mediumImpact();
                onPressed();
              },
              borderRadius: BorderRadius.circular(16),
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: palette.surface,
                  border: Border.all(
                    color: Colors.red.withValues(alpha: 0.35),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout_rounded,
                        size: 20,
                        color: Colors.red.shade600,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Log out',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.red.shade600,
                        ),
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

  // Legacy API
  static Widget buildSectionHeader(String title) => buildSectionLabel(title);

  static Widget buildSettingItem({
    required String title,
    required IconData icon,
    required Color iconColor,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return buildNavRow(
      title: title,
      icon: icon,
      accentColor: iconColor,
      subtitle: subtitle,
      onTap: onTap,
    );
  }

  static Widget buildToggleItem({
    required String title,
    required IconData icon,
    required Color iconColor,
    required bool value,
    required ValueChanged<bool> onChanged,
    String? subtitle,
  }) {
    return buildToggleRow(
      title: title,
      icon: icon,
      accentColor: iconColor,
      value: value,
      onChanged: onChanged,
      subtitle: subtitle,
    );
  }

  static Widget buildProfileCard({
    required String name,
    String? email,
    String? imageUrl,
    VoidCallback? onTap,
  }) {
    return buildProfileHero(
      name: name,
      email: email,
      imageUrl: imageUrl,
      onTap: onTap,
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color accentColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsRow({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.accentColor,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap != null
            ? () {
                HapticFeedback.selectionClick();
                onTap!();
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      accentColor.withValues(alpha: 0.22),
                      accentColor.withValues(alpha: 0.08),
                    ],
                  ),
                ),
                child: Icon(icon, color: accentColor, size: 21),
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
                        fontWeight: FontWeight.w600,
                        color: palette.textPrimary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 12,
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
