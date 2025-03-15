import 'package:courier_app/features/notification_screen/presentation/screen/notification_screen.dart';
import 'package:flutter/material.dart';

class ApplicationWidgets {
  static Widget buildMenuGrid({
    required bool isDarkMode,
    required List<MenuOption> options,
    required Function(Widget) onOptionSelected,
  }) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        return _buildMenuCard(
          isDarkMode: isDarkMode,
          option: option,
          onTap: () => onOptionSelected(option.screen),
        );
      },
    );
  }

  static Widget _buildMenuCard({
    required bool isDarkMode,
    required MenuOption option,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                option.color.withOpacity(isDarkMode ? 0.2 : 0.8),
                option.color.withOpacity(isDarkMode ? 0.1 : 0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: option.color.withOpacity(isDarkMode ? 0.3 : 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: option.color.withOpacity(isDarkMode ? 0.1 : 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: option.color.withOpacity(isDarkMode ? 0.2 : 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  option.icon,
                  size: 32,
                  color: isDarkMode ? Colors.white : option.color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                option.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              if (option.subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  option.subtitle!,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static Widget buildEmptyState({required bool isDarkMode}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.apps_outlined,
            size: 64,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            'No Applications Available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check back later',
            style: TextStyle(
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class MenuOption {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final Widget screen;

  const MenuOption({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.color,
    required this.screen,
  });
}

// Example menu options
final List<MenuOption> defaultMenuOptions = [
  const MenuOption(
    title: 'Track Shipment',
    subtitle: 'Track your packages',
    icon: Icons.local_shipping,
    color: Colors.blue,
    screen: NotificationScreen(),
  ),
  const MenuOption(
    title: 'Add Shipment',
    subtitle: 'Create new shipment',
    icon: Icons.add_box,
    color: Colors.green,
    screen: NotificationScreen(),
  ),
  const MenuOption(
    title: 'Scan Barcode',
    subtitle: 'Scan package barcodes',
    icon: Icons.qr_code_scanner,
    color: Colors.purple,
    screen: NotificationScreen(),
  ),
  const MenuOption(
    title: 'Delivery Run Sheet',
    subtitle: 'View shipment reports',
    icon: Icons.assessment,
    color: Colors.orange,
    screen: NotificationScreen(),
  ),
  const MenuOption(
    title: 'Update Shipments',
    subtitle: 'App preferences',
    icon: Icons.settings,
    color: Colors.grey,
    screen: NotificationScreen(),
  ),
  const MenuOption(
    title: 'Add Extra Fee',
    subtitle: 'Get help',
    icon: Icons.help_outline,
    color: Colors.teal,
    screen: NotificationScreen(),
  ),
];
