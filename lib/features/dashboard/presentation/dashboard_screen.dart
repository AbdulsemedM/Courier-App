import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:courier_app/configuration/auth_service.dart';
import 'package:courier_app/features/analytics/presentation/screens/analytics_screen.dart';
import 'package:courier_app/features/applications/presentation/screens/applications_screen.dart';
import 'package:courier_app/features/home_screen/presentation/screen/home_screen.dart';
// import 'package:courier_app/features/notification_screen/presentation/screen/notification_screen.dart';
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
  PageController? _pageController;
  bool _isAdmin = false;
  bool _isLoading = true;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkAdminRole();
  }

  Future<void> _checkAdminRole() async {
    final roleName = await _authService.getRoleName();
    setState(() {
      _isAdmin = roleName?.toLowerCase() == 'admin';
      _pageController = PageController();
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    // final customColors = Theme.of(context).extension<CustomColors>()!;

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
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SizedBox.expand(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentIndex = index);
                  },
                  children: _isAdmin
                      ? const <Widget>[
                          HomeScreen(),
                          ApplicationsScreen(),
                          AnalyticsScreen(),
                          SettingsScreen(),
                        ]
                      : const <Widget>[
                          HomeScreen(),
                          ApplicationsScreen(),
                          SettingsScreen(),
                        ],
                ),
              ),
        bottomNavigationBar: _isLoading
            ? null
            : Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF5b3895) : Colors.white,
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
                  backgroundColor: isDarkMode
                      ? const Color(0xFF5b3895)
                      : const Color(0xFF5b3895),
                  onItemSelected: (index) {
                    setState(() => _currentIndex = index);
                    _pageController!.jumpToPage(index);
                  },
                  items: _isAdmin
                      ? <BottomNavyBarItem>[
                          BottomNavyBarItem(
                            icon: const Icon(Icons.home),
                            title: const Text('Home'),
                            activeColor: isDarkMode
                                ? const Color(0xFFFF5A00)
                                : const Color(0xFFFF5A00),
                            inactiveColor: isDarkMode
                                ? Colors.grey.shade500
                                : Colors.grey.shade600,
                            textAlign: TextAlign.center,
                          ),
                          BottomNavyBarItem(
                            icon: const Icon(Icons.app_shortcut_rounded),
                            title: const Text('Application'),
                            activeColor: isDarkMode
                                ? const Color(0xFFFF5A00)
                                : const Color(0xFFFF5A00),
                            inactiveColor: isDarkMode
                                ? Colors.grey.shade500
                                : Colors.grey.shade600,
                            textAlign: TextAlign.center,
                          ),
                          BottomNavyBarItem(
                            icon: const Icon(Icons.analytics),
                            title: const Text('Analytics'),
                            activeColor: isDarkMode
                                ? const Color(0xFFFF5A00)
                                : const Color(0xFFFF5A00),
                            inactiveColor: isDarkMode
                                ? Colors.grey.shade500
                                : Colors.grey.shade600,
                            textAlign: TextAlign.center,
                          ),
                          BottomNavyBarItem(
                            icon: const Icon(Icons.settings),
                            title: const Text('Settings'),
                            activeColor: isDarkMode
                                ? const Color(0xFFFF5A00)
                                : const Color(0xFFFF5A00),
                            inactiveColor: isDarkMode
                                ? Colors.grey.shade500
                                : Colors.grey.shade600,
                            textAlign: TextAlign.center,
                          ),
                        ]
                      : <BottomNavyBarItem>[
                          BottomNavyBarItem(
                            icon: const Icon(Icons.home),
                            title: const Text('Home'),
                            activeColor: isDarkMode
                                ? const Color(0xFFFF5A00)
                                : const Color(0xFFFF5A00),
                            inactiveColor: isDarkMode
                                ? Colors.grey.shade500
                                : Colors.grey.shade600,
                            textAlign: TextAlign.center,
                          ),
                          BottomNavyBarItem(
                            icon: const Icon(Icons.app_shortcut_rounded),
                            title: const Text('Application'),
                            activeColor: isDarkMode
                                ? const Color(0xFFFF5A00)
                                : const Color(0xFFFF5A00),
                            inactiveColor: isDarkMode
                                ? Colors.grey.shade500
                                : Colors.grey.shade600,
                            textAlign: TextAlign.center,
                          ),
                          BottomNavyBarItem(
                            icon: const Icon(Icons.settings),
                            title: const Text('Settings'),
                            activeColor: isDarkMode
                                ? const Color(0xFFFF5A00)
                                : const Color(0xFFFF5A00),
                            inactiveColor: isDarkMode
                                ? Colors.grey.shade500
                                : Colors.grey.shade600,
                            textAlign: TextAlign.center,
                          ),
                        ],
                ),
              ),
      ),
    );
  }
}
