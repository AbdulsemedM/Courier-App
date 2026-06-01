import 'package:courier_app/app/utils/dialog_utils.dart';
import 'package:courier_app/app/utils/responsive_helper.dart';
import 'package:courier_app/configuration/auth_service.dart';
import 'package:courier_app/configuration/phone_number_manager.dart';
import 'package:courier_app/features/accounting/presentation/screens/accounting_screen.dart';
import 'package:courier_app/features/add_shipment/presentation/screens/add_shipment_screen.dart';
import 'package:courier_app/features/barcode_reader/presentation/screen/barcode_reader_screen.dart';
import 'package:courier_app/features/other_settings/presentation/screens/options_screen.dart';
import 'package:courier_app/features/track_shipment/presentation/screens/track_shipment_screen.dart';
import 'package:courier_app/features/reports/presentation/screens/reports_screen.dart';
import 'package:courier_app/core/utils/role_display_helper.dart';
import 'package:courier_app/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_provider.dart';
import '../widget/home_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> permissions = [];
  final AuthService _authService = AuthService();
  bool _hasAccountingAccess = false;
  bool _isLoadingRole = true;
  String _displayRole = '...';

  @override
  void initState() {
    super.initState();
    fetchPermissions();
    _checkAccountingAccess();
  }

  void fetchPermissions() async {
    final permissions = await PermissionManager().getPermission();
    if (permissions != null) {
      setState(() => this.permissions = permissions);
    }
  }

  Future<void> _checkAccountingAccess() async {
    final roleInfo = await RoleDisplayHelper.loadRoleDisplayInfo(
      authService: _authService,
    );
    if (!mounted) return;
    setState(() {
      _hasAccountingAccess = _hasAccountingAccessRole(roleInfo.primaryRole);
      _displayRole = roleInfo.formattedRole;
      _isLoadingRole = false;
    });
  }

  bool _hasAccountingAccessRole(String? roleName) {
    if (roleName == null) return false;
    final role = roleName.toLowerCase().trim();
    return role == 'admin' || role == 'teller' || role == 'branch manager';
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final palette = context.palette;
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: palette.background,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Home',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none_rounded,
              color: palette.textSecondary,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              color: palette.textSecondary,
            ),
            onPressed: themeProvider.toggleTheme,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: HomeWidgets.buildPageBackground(
        isDarkMode: isDarkMode,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ResponsiveHelper.getMaxContentWidth(context),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: ResponsiveHelper.getResponsivePadding(
                context,
                mobile: const EdgeInsets.fromLTRB(16, 0, 16, 28),
                tablet: const EdgeInsets.fromLTRB(24, 0, 24, 36),
                desktop: const EdgeInsets.fromLTRB(32, 0, 32, 40),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HomeWidgets.buildWelcomeHero(
                    context: context,
                    isDarkMode: isDarkMode,
                    displayRole: _displayRole,
                    isLoadingRole: _isLoadingRole,
                  ),
                  HomeWidgets.buildSectionHeader(
                    context: context,
                    title: 'Quick actions',
                    subtitle: 'Daily courier workflows',
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(
                      context,
                      mobile: 3,
                      tablet: 3,
                      desktop: 3,
                    ),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.78,
                    children: [
                      HomeWidgets.buildQuickActionCard(
                        context: context,
                        icon: Icons.add_box_rounded,
                        label: 'Add Shipment',
                        description: 'New package',
                        color: const Color(0xFFEA580C),
                        gradientStart: const Color(0xFFFFF7ED),
                        gradientEnd: const Color(0xFFFFEDD5),
                        isDarkMode: isDarkMode,
                        onTap: () => _openWithPermission(
                          'add_shipment',
                          'You do not have permission to add shipment',
                          const AddShipmentScreen(),
                        ),
                      ),
                      HomeWidgets.buildQuickActionCard(
                        context: context,
                        icon: Icons.radar_rounded,
                        label: 'Track Order',
                        description: 'Find AWB',
                        color: const Color(0xFF2563EB),
                        gradientStart: const Color(0xFFEFF6FF),
                        gradientEnd: const Color(0xFFDBEAFE),
                        isDarkMode: isDarkMode,
                        onTap: () => _openWithPermission(
                          'Track_Shipment',
                          'You do not have permission to track shipment',
                          const TrackShipmentScreen(),
                        ),
                      ),
                      HomeWidgets.buildQuickActionCard(
                        context: context,
                        icon: Icons.qr_code_scanner_rounded,
                        label: 'Change Status',
                        description: 'Scan barcode',
                        color: const Color(0xFF0D9488),
                        gradientStart: const Color(0xFFF0FDFA),
                        gradientEnd: const Color(0xFFCCFBF1),
                        isDarkMode: isDarkMode,
                        onTap: () => _openWithPermission(
                          'Change_Shipment_Status',
                          'You do not have permission to change status',
                          const BarcodeReaderScreen(),
                        ),
                      ),
                    ],
                  ),
                  HomeWidgets.buildSectionHeader(
                    context: context,
                    title: 'Explore more',
                    subtitle: 'Reports, settings & finance',
                  ),
                  HomeWidgets.buildFeatureTile(
                    context: context,
                    icon: Icons.analytics_rounded,
                    title: 'Reports',
                    subtitle: 'Branch and admin insights',
                    accentColor: palette.accent,
                    isDarkMode: isDarkMode,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReportsScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  HomeWidgets.buildFeatureTile(
                    context: context,
                    icon: Icons.tune_rounded,
                    title: 'Other Settings',
                    subtitle: 'Branches, fees & configuration',
                    accentColor: const Color(0xFF6366F1),
                    isDarkMode: isDarkMode,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OptionsScreen(),
                      ),
                    ),
                  ),
                  if (!_isLoadingRole && _hasAccountingAccess) ...[
                    const SizedBox(height: 10),
                    HomeWidgets.buildFeatureTile(
                      context: context,
                      icon: Icons.account_balance_wallet_rounded,
                      title: 'Accounting',
                      subtitle: 'Ledgers, balances & closeout',
                      accentColor: const Color(0xFF059669),
                      isDarkMode: isDarkMode,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AccountingScreen(),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openWithPermission(
    String permission,
    String deniedMessage,
    Widget screen,
  ) {
    if (permissions.contains(permission)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    } else {
      displaySnack(context, deniedMessage, Colors.red);
    }
  }
}
