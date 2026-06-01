import 'package:courier_app/configuration/auth_service.dart';
import 'package:courier_app/configuration/phone_number_manager.dart';
import 'package:courier_app/core/utils/role_display_helper.dart';
import 'package:courier_app/core/theme/app_palette.dart';
import 'package:courier_app/features/comming_soon/coming_soon_screen.dart';
import 'package:courier_app/features/login/presentation/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_provider.dart';
import '../widgets/settings_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool locationEnabled = true;
  String _displayRole = '...';
  String? _email;
  bool _isLoadingProfile = true;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadProfileInfo();
  }

  Future<void> _loadProfileInfo() async {
    final roleInfo = await RoleDisplayHelper.loadRoleDisplayInfo();
    final email = await PhoneNumberManager().getPhoneNumber();
    if (!mounted) return;
    setState(() {
      _displayRole = roleInfo.formattedRole;
      _email = email;
      _isLoadingProfile = false;
    });
  }

  Future<void> _handleLogout() async {
    final palette = context.palette;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: palette.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Log out?',
          style: TextStyle(
            color: palette.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'You will need to sign in again to access your account.',
          style: TextStyle(color: palette.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(color: palette.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Log out'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await _authService.deleteToken();
      await _authService.deleteUserId();
      await _authService.deleteBranch();
      await _authService.deleteRoleName();
      await _authService.deleteRoleNames();
      await PermissionManager().setPermission([]);

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during logout: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _openComingSoon() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ComingSoonScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final palette = context.palette;
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
          ),
        ),
      ),
      body: SettingsWidgets.buildPageBackground(
        isDarkMode: isDarkMode,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            SettingsWidgets.buildProfileHero(
              name: _isLoadingProfile ? '...' : _displayRole,
              email: _email,
              onTap: _openComingSoon,
            ),
            SettingsWidgets.buildSectionLabel('ACCOUNT'),
            SettingsWidgets.buildSettingsGroup(
              children: [
                SettingsWidgets.buildNavRow(
                  title: 'Personal Information',
                  icon: Icons.person_outline_rounded,
                  accentColor: const Color(0xFF2563EB),
                  subtitle: 'Name, contact & profile',
                  onTap: _openComingSoon,
                ),
                SettingsWidgets.buildNavRow(
                  title: 'Payment Methods',
                  icon: Icons.payments_outlined,
                  accentColor: const Color(0xFF059669),
                  subtitle: 'Cards and payment options',
                  onTap: _openComingSoon,
                ),
                SettingsWidgets.buildNavRow(
                  title: 'Address Book',
                  icon: Icons.location_on_outlined,
                  accentColor: const Color(0xFFEA580C),
                  subtitle: 'Saved delivery addresses',
                  onTap: _openComingSoon,
                ),
              ],
            ),
            SettingsWidgets.buildSectionLabel('PREFERENCES'),
            SettingsWidgets.buildSettingsGroup(
              children: [
                SettingsWidgets.buildToggleRow(
                  title: 'Push Notifications',
                  icon: Icons.notifications_outlined,
                  accentColor: const Color(0xFF7C3AED),
                  value: notificationsEnabled,
                  subtitle: 'Delivery and status alerts',
                  onChanged: (value) {
                    setState(() => notificationsEnabled = value);
                  },
                ),
                SettingsWidgets.buildToggleRow(
                  title: 'Dark Mode',
                  icon: Icons.dark_mode_outlined,
                  accentColor: const Color(0xFF4F46E5),
                  value: isDarkMode,
                  subtitle: isDarkMode ? 'Switch to light theme' : 'Switch to dark theme',
                  onChanged: (_) => themeProvider.toggleTheme(),
                ),
                SettingsWidgets.buildToggleRow(
                  title: 'Location Services',
                  icon: Icons.my_location_outlined,
                  accentColor: const Color(0xFFDC2626),
                  value: locationEnabled,
                  subtitle: 'Track deliveries on map',
                  onChanged: (value) {
                    setState(() => locationEnabled = value);
                  },
                ),
              ],
            ),
            SettingsWidgets.buildSectionLabel('SUPPORT'),
            SettingsWidgets.buildSettingsGroup(
              children: [
                SettingsWidgets.buildNavRow(
                  title: 'Help Center',
                  icon: Icons.help_outline_rounded,
                  accentColor: const Color(0xFF0D9488),
                  subtitle: 'FAQs and contact support',
                  onTap: _openComingSoon,
                ),
                SettingsWidgets.buildNavRow(
                  title: 'Terms & Privacy',
                  icon: Icons.shield_outlined,
                  accentColor: const Color(0xFF64748B),
                  subtitle: 'Legal information',
                  onTap: _openComingSoon,
                ),
                SettingsWidgets.buildNavRow(
                  title: 'About App',
                  icon: Icons.info_outline_rounded,
                  accentColor: const Color(0xFF2563EB),
                  subtitle: 'Version 1.0.3',
                  onTap: _openComingSoon,
                ),
              ],
            ),
            SettingsWidgets.buildLogoutButton(onPressed: _confirmLogout),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmLogout() async {
    await _handleLogout();
  }
}
