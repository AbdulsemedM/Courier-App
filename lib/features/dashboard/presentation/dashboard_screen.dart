import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:courier_app/configuration/auth_service.dart';
import 'package:courier_app/configuration/phone_number_manager.dart';
import 'package:courier_app/core/theme/app_palette.dart';
import 'package:courier_app/features/analytics/presentation/screens/analytics_screen.dart';
import 'package:courier_app/features/applications/presentation/screens/applications_screen.dart';
import 'package:courier_app/features/home_screen/presentation/screen/home_screen.dart';
import 'package:courier_app/features/login/presentation/screen/login_screen.dart';
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
      await _authService.deleteToken();
      await _authService.deleteUserId();
      await _authService.deleteBranch();
      await _authService.deleteRoleName();
      await _authService.deleteRoleNames();
      await PermissionManager().setPermission([]);

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
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
    final palette = context.palette;

    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: palette.surface,
          title: Text(
            'Logout',
            style: TextStyle(
              color: palette.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: palette.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: TextStyle(color: palette.textSecondary),
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
    }
    return false;
  }

  BottomNavyBarItem _navItem({
    required IconData icon,
    required String title,
    required AppPalette palette,
  }) {
    return BottomNavyBarItem(
      icon: Icon(icon),
      title: Text(title),
      activeColor: palette.navActive,
      inactiveColor: palette.navInactive,
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          await _onWillPop();
        }
      },
      child: Container(
        color: palette.background,
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
                    color: palette.navBarBackground,
                    border: Border(
                      top: BorderSide(color: palette.border),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: palette.cardShadow,
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: BottomNavyBar(
                    selectedIndex: _currentIndex,
                    showElevation: false,
                    backgroundColor: palette.navBarBackground,
                    onItemSelected: (index) {
                      setState(() => _currentIndex = index);
                      _pageController!.jumpToPage(index);
                    },
                    items: _isAdmin
                        ? [
                            _navItem(
                              icon: Icons.home,
                              title: 'Home',
                              palette: palette,
                            ),
                            _navItem(
                              icon: Icons.app_shortcut_rounded,
                              title: 'Application',
                              palette: palette,
                            ),
                            _navItem(
                              icon: Icons.analytics,
                              title: 'Analytics',
                              palette: palette,
                            ),
                            _navItem(
                              icon: Icons.settings,
                              title: 'Settings',
                              palette: palette,
                            ),
                          ]
                        : [
                            _navItem(
                              icon: Icons.home,
                              title: 'Home',
                              palette: palette,
                            ),
                            _navItem(
                              icon: Icons.app_shortcut_rounded,
                              title: 'Application',
                              palette: palette,
                            ),
                            _navItem(
                              icon: Icons.settings,
                              title: 'Settings',
                              palette: palette,
                            ),
                          ],
                  ),
                ),
        ),
      ),
    );
  }
}
