import 'package:flutter/material.dart';
import '../widgets/settings_widget.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool locationEnabled = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            customColors.backgroundGradientStart,
            customColors.backgroundGradientEnd,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Settings'),
        ),
        body: ListView(
          children: [
            SettingsWidgets.buildProfileCard(
              name: 'Abdulsemed M.',
              email: 'abdulsemed.m@gmail.com',
              imageUrl:
                  'https://www.shutterstock.com/image-vector/businessman-icon-can-be-used-260nw-247098721.jpg',
              onTap: () {
                // Handle profile tap
              },
            ),
            SettingsWidgets.buildSectionHeader('Account Settings'),
            SettingsWidgets.buildSettingItem(
              title: 'Personal Information',
              icon: Icons.person_outline,
              iconColor: Colors.blue,
              subtitle: 'Update your personal details',
              onTap: () {
                // Handle personal info
              },
            ),
            SettingsWidgets.buildSettingItem(
              title: 'Payment Methods',
              icon: Icons.payment,
              iconColor: Colors.green,
              subtitle: 'Manage your payment options',
              onTap: () {
                // Handle payment methods
              },
            ),
            SettingsWidgets.buildSettingItem(
              title: 'Address Book',
              icon: Icons.location_on_outlined,
              iconColor: Colors.orange,
              subtitle: 'Manage delivery addresses',
              onTap: () {
                // Handle address book
              },
            ),
            SettingsWidgets.buildSectionHeader('App Settings'),
            SettingsWidgets.buildToggleItem(
              title: 'Push Notifications',
              icon: Icons.notifications_none,
              iconColor: Colors.purple,
              value: notificationsEnabled,
              subtitle: 'Receive updates about your deliveries',
              onChanged: (value) {
                setState(() => notificationsEnabled = value);
              },
            ),
            SettingsWidgets.buildToggleItem(
              title: 'Dark Mode',
              icon: Icons.dark_mode_outlined,
              iconColor: isDarkMode ? Colors.blue.shade200 : Colors.indigo,
              value: isDarkMode,
              subtitle: 'Switch to ${isDarkMode ? "light" : "dark"} theme',
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
            ),
            SettingsWidgets.buildToggleItem(
              title: 'Location Services',
              icon: Icons.location_on_outlined,
              iconColor: Colors.red,
              value: locationEnabled,
              subtitle: 'Enable location tracking for deliveries',
              onChanged: (value) {
                setState(() => locationEnabled = value);
              },
            ),
            SettingsWidgets.buildSectionHeader('Support'),
            SettingsWidgets.buildSettingItem(
              title: 'Help Center',
              icon: Icons.help_outline,
              iconColor: Colors.teal,
              subtitle: 'Get help with your orders',
              onTap: () {
                // Handle help center
              },
            ),
            SettingsWidgets.buildSettingItem(
              title: 'Terms & Privacy Policy',
              icon: Icons.privacy_tip_outlined,
              iconColor: Colors.grey,
              onTap: () {
                // Handle privacy policy
              },
            ),
            SettingsWidgets.buildSettingItem(
              title: 'About App',
              icon: Icons.info_outline,
              iconColor: Colors.blue,
              subtitle: 'Version 1.0.0',
              onTap: () {
                // Handle about
              },
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  // Handle logout
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
