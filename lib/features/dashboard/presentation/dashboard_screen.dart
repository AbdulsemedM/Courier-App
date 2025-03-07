import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:courier_app/features/home_screen/presentation/screen/home_screen.dart';
import 'package:courier_app/features/notification_screen/presentation/screen/notification_screen.dart';
import 'package:courier_app/features/settings_screen/presentation/screen/settings_screen.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      // appBar: AppBar(title: Text("Bottom Nav Bar")),
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
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              title: const Text('Home'), icon: const Icon(Icons.home)),
          BottomNavyBarItem(
              title: const Text('Notification'), icon: const Icon(Icons.apps)),
          BottomNavyBarItem(
              title: const Text('Settings'), icon: const Icon(Icons.settings)),
        ],
      ),
    );
  }
}
