import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:courier_app/configuration/auth_service.dart';
import 'package:courier_app/configuration/phone_number_manager.dart';
import 'package:courier_app/features/analytics/presentation/screens/analytics_screen.dart';
import 'package:courier_app/features/applications/presentation/screens/applications_screen.dart';
import 'package:courier_app/features/home_screen/presentation/screen/home_screen.dart';
import 'package:courier_app/features/login/presentation/screen/login_screen.dart';
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

  Future<void> _handleLogout() async {
    try {
      // Clear all authentication data
      await _authService.deleteToken();
      await _authService.deleteUserId();
      await _authService.deleteBranch();
      await _authService.deleteRoleName();
      
      // Clear permissions
      await PermissionManager().setPermission([]);
      
      // Navigate to login screen
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      // Handle any errors during logout
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error during logout: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<bool> _onWillPop() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;
    
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1A1F37) : Colors.white,
          title: Text(
            'Logout',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      await _handleLogout();
      return false; // Prevent default back button behavior
    }
    return false; // Prevent default back button behavior
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    // final customColors = Theme.of(context).extension<CustomColors>()!;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          await _onWillPop();
        }
      },
      child: Container(
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
      ),
    );
  }
}
