import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:courier_app/features/home_screen/presentation/screen/home_screen.dart';
import 'package:courier_app/features/notification_screen/presentation/screen/notification_screen.dart';
import 'package:courier_app/features/settings_screen/presentation/screen/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
          colors: isDarkMode 
              ? [
                  const Color(0xFF0A1931), // Dark blue
                  const Color(0xFF152642), // Slightly lighter blue
                ]
              : [
                  const Color(0xFFF5F6FA),
                  const Color(0xFFFFFFFF),
                ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox.expand(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: const <Widget>[
              HomeScreen(),
              NotificationScreen(),
              SettingsScreen(),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF0A1931) : Colors.white,
            boxShadow: [
              BoxShadow(
                color: isDarkMode 
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavyBar(
            selectedIndex: _currentIndex,
            showElevation: false,
            backgroundColor:isDarkMode?const Color.fromARGB(255, 1, 38, 67): Colors.transparent,
            onItemSelected: (index) {
              setState(() => _currentIndex = index);
              _pageController.jumpToPage(index);
            },
            items: <BottomNavyBarItem>[
              BottomNavyBarItem(
                icon: const Icon(Icons.home),
                title: const Text('Home'),
                activeColor: isDarkMode ? Colors.blue.shade200 : Colors.blue.shade700,
                inactiveColor: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600,
                textAlign: TextAlign.center,
              ),
              BottomNavyBarItem(
                icon: const Icon(Icons.notifications_outlined),
                title: const Text('Notifications'),
                activeColor: isDarkMode ? Colors.blue.shade200 : Colors.blue.shade700,
                inactiveColor: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600,
                textAlign: TextAlign.center,
              ),
              BottomNavyBarItem(
                icon: const Icon(Icons.settings),
                title: const Text('Settings'),
                activeColor: isDarkMode ? Colors.blue.shade200 : Colors.blue.shade700,
                inactiveColor: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
