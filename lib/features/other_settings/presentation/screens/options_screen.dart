import 'package:courier_app/configuration/phone_number_manager.dart';
import 'package:courier_app/core/utils/app_permissions.dart';
import 'package:courier_app/features/branches/presentation/screen/branches_screen.dart';
import 'package:courier_app/features/countries/presentation/screen/countries_screen.dart';
import 'package:courier_app/features/currency/presentation/screen/currency_screen.dart';
import 'package:courier_app/features/exchange_rate/presentation/screen/exchange_rate_screen.dart';
import 'package:courier_app/features/manage_agent/presentation/screen/manage_agent_screen.dart';
import 'package:courier_app/features/manage_customers/presentation/screen/manage_customers_screen.dart';
import 'package:courier_app/features/manage_user/presentation/screen/manage_user_screen.dart';
import 'package:courier_app/features/payment_method/presentation/screen/payment_methods_screen.dart';
import 'package:courier_app/features/services_mode/presentation/screen/services_mode_screen.dart';
import 'package:courier_app/features/shipment_types/presentation/screen/shipment_types_screen.dart';
import 'package:courier_app/features/tellers/presentation/screen/teller_screen.dart';
import 'package:courier_app/features/transport_modes/presentation/screen/transport_modes_screen.dart';
import 'package:flutter/material.dart';
import 'package:courier_app/core/theme/app_palette.dart';
import '../widgets/options_widget.dart';

class OptionsScreen extends StatefulWidget {
  const OptionsScreen({super.key});

  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  List<String> permissions = [];

  @override
  void initState() {
    super.initState();
    fetchPermissions();
  }

  void fetchPermissions() async {
    final permissions = await PermissionManager().getPermissionList();
    if (!mounted) return;
    setState(() {
      this.permissions = permissions;
    });
  }

  bool _can(String permission) =>
      PermissionGuard.has(permissions, permission);

  bool _canAny(List<String> required) =>
      PermissionGuard.hasAny(permissions, required);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;

    final gridOptions = <Widget>[
      if (_can(AppPermissions.manageBranches))
        OptionCard(
          icon: Icons.account_tree_outlined,
          title: 'Branches',
          subtitle: 'Manage branches',
          color: Colors.blue,
          isDarkMode: isDarkMode,
          onTap: () => _handleOptionTap(context, 'Branches'),
        ),
      if (_can(AppPermissions.manageCountries))
        OptionCard(
          icon: Icons.public,
          title: 'Countries',
          subtitle: 'Manage locations',
          color: Colors.green,
          isDarkMode: isDarkMode,
          onTap: () => _handleOptionTap(context, 'Countries'),
        ),
      if (_can(AppPermissions.managePaymentMethods))
        OptionCard(
          icon: Icons.payment,
          title: 'Payment Methods',
          subtitle: 'Configure options',
          color: Colors.orange,
          isDarkMode: isDarkMode,
          onTap: () => _handleOptionTap(context, 'Payment methods'),
        ),
      if (_can(AppPermissions.manageShipmentTypes))
        OptionCard(
          icon: Icons.local_shipping_outlined,
          title: 'Shipment Types',
          subtitle: 'Manage types',
          color: Colors.purple,
          isDarkMode: isDarkMode,
          onTap: () => _handleOptionTap(context, 'Shipment types'),
        ),
      if (_can(AppPermissions.servicesModes))
        OptionCard(
          icon: Icons.miscellaneous_services_outlined,
          title: 'Services Modes',
          subtitle: 'Configure services',
          color: Colors.teal,
          isDarkMode: isDarkMode,
          onTap: () => _handleOptionTap(context, 'Services modes'),
        ),
      if (_can(AppPermissions.manageCurrencies))
        OptionCard(
          icon: Icons.currency_exchange,
          title: 'Currency',
          subtitle: 'Set currency options',
          color: Colors.indigo,
          isDarkMode: isDarkMode,
          onTap: () => _handleOptionTap(context, 'Currency'),
        ),
    ];

    final listOptions = <Widget>[
      if (_can(AppPermissions.manageTransportModes))
        ListOptionCard(
          icon: Icons.directions_bus_filled_outlined,
          title: 'Transport Modes',
          subtitle: 'Configure transportation options',
          color: Colors.amber,
          isDarkMode: isDarkMode,
          onTap: () => _handleOptionTap(context, 'Transport modes'),
        ),
      if (_can(AppPermissions.manageExchangeRates))
        ListOptionCard(
          icon: Icons.currency_exchange,
          title: 'Exchange Rates',
          subtitle: 'Configure exchange rates',
          color: Colors.deepPurpleAccent,
          isDarkMode: isDarkMode,
          onTap: () => _handleOptionTap(context, 'Exchange rates'),
        ),
      if (_can(AppPermissions.manageAccounting))
        ListOptionCard(
          icon: Icons.people_outline,
          title: 'Accounts Management',
          subtitle: 'Manage accounts',
          color: Colors.deepOrange,
          isDarkMode: isDarkMode,
          onTap: () => _handleOptionTap(context, 'Account management'),
        ),
      if (_canAny(AppPermissions.manageUsersAny))
        ListOptionCard(
          icon: Icons.people_outline,
          title: 'User Management',
          subtitle: 'Manage user access and permissions',
          color: Colors.cyan,
          isDarkMode: isDarkMode,
          onTap: () => _handleOptionTap(context, 'User management'),
        ),
    ];

    return Scaffold(
      backgroundColor: context.isDarkMode
          ? const Color(0xFF5B3895)
          : context.palette.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: context.palette.textPrimary,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Options',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: context.palette.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (gridOptions.isNotEmpty)
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.1,
                        children: gridOptions,
                      ),
                    if (listOptions.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text(
                        'Additional Settings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: context.palette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...listOptions,
                    ],
                    if (gridOptions.isEmpty && listOptions.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            'No settings available for your role',
                            style: TextStyle(
                              color: context.palette.textSecondary,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleOptionTap(BuildContext context, String option) {
    if (option == 'Branches') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const BranchesScreen()),
      );
    } else if (option == 'Countries') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const CountriesScreen()),
      );
    } else if (option == "Payment methods") {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const PaymentMethodsScreen()),
      );
    } else if (option == "Shipment types") {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ShipmentTypesScreen()),
      );
    } else if (option == "Services modes") {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ServicesModeScreen()),
      );
    } else if (option == "Currency") {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const CurrencyScreen()),
      );
    } else if (option == "Transport modes") {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const TransportModesScreen()),
      );
    } else if (option == "Exchange rates") {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ExchangeRateScreen()),
      );
    } else if (option == 'User management') {
      showModalBottomSheet(
        context: context,
        backgroundColor: context.isDarkMode
            ? const Color.fromARGB(255, 75, 23, 160)
            : context.palette.appBarBackground,
        isScrollControlled: true,
        builder: (context) {
          final isDarkMode = context.isDarkMode;
          final userOptions = <Widget>[
            if (_canAny(AppPermissions.manageUsersAny))
              _buildUserOption(
                context: context,
                icon: Icons.admin_panel_settings,
                title: 'Manage Users',
                subtitle: 'Staff & Admins',
                color: Colors.blue,
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.blueAccent],
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ManageUserScreen()));
                },
              ),
            if (_can(AppPermissions.manageCustomers))
              _buildUserOption(
                context: context,
                icon: Icons.people,
                title: 'Manage Customer',
                subtitle: 'Client Accounts',
                color: Colors.purple,
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.purpleAccent],
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ManageCustomersScreen()));
                },
              ),
            if (_can(AppPermissions.manageAgents))
              _buildUserOption(
                context: context,
                icon: Icons.support_agent,
                title: 'Manage Agents',
                subtitle: 'Field Staff',
                color: Colors.orange,
                gradient: const LinearGradient(
                  colors: [Colors.orange, Colors.deepOrange],
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ManageAgentScreen()));
                },
              ),
          ];

          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color.fromARGB(255, 75, 23, 160)
                  : context.palette.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              border: isDarkMode
                  ? null
                  : Border.all(color: context.palette.border),
              boxShadow: [
                BoxShadow(
                  color: context.palette.cardShadow,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.palette.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'User Management',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: context.palette.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select a category to manage',
                  style: TextStyle(
                    fontSize: 16,
                    color: context.palette.textSecondary,
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: userOptions,
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else if (option == 'Account management') {
      showModalBottomSheet(
        context: context,
        backgroundColor: context.isDarkMode
            ? const Color.fromARGB(255, 75, 23, 160)
            : context.palette.appBarBackground,
        isScrollControlled: true,
        builder: (context) {
          final isDarkMode = context.isDarkMode;
          final tiles = <Widget>[
            if (_canAny(AppPermissions.tellerAccountAny)) ...[
              _buildManagementTile(
                context: context,
                icon: Icons.admin_panel_settings,
                title: 'Teller List',
                subtitle: 'Staff & Admins',
                color: Colors.blue,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const TellerScreen(),
                  ));
                },
              ),
              const SizedBox(height: 12),
            ],
            if (_can(AppPermissions.tellersListAssign)) ...[
              _buildManagementTile(
                context: context,
                icon: Icons.people,
                title: 'Assign Tellers',
                subtitle: 'Client Accounts',
                color: Colors.purple,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ManageCustomersScreen(),
                  ));
                },
              ),
              const SizedBox(height: 12),
            ],
            if (_can(AppPermissions.accountsList)) ...[
              _buildManagementTile(
                context: context,
                icon: Icons.account_box_outlined,
                title: 'Accounts',
                subtitle: 'Field Staff',
                color: Colors.orange,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ManageAgentScreen(),
                  ));
                },
              ),
              const SizedBox(height: 12),
            ],
            if (_can(AppPermissions.tellerByBranch)) ...[
              _buildManagementTile(
                context: context,
                icon: Icons.filter_list,
                title: 'Filter by Branch',
                subtitle: 'Field Staff',
                color: Colors.red,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ManageAgentScreen(),
                  ));
                },
              ),
              const SizedBox(height: 12),
            ],
            if (_can('Teller_By_Status'))
              _buildManagementTile(
                context: context,
                icon: Icons.filter,
                title: 'Filter by Status',
                subtitle: 'Field Staff',
                color: Colors.green,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ManageAgentScreen(),
                  ));
                },
              ),
          ];

          return SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color.fromARGB(255, 75, 23, 160)
                    : context.palette.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                border: isDarkMode
                    ? null
                    : Border.all(color: context.palette.border),
                boxShadow: [
                  BoxShadow(
                    color: context.palette.cardShadow,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.palette.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Account Management',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: context.palette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select a category to manage',
                    style: TextStyle(
                      fontSize: 16,
                      color: context.palette.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(children: tiles),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildUserOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.25,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 32,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.palette.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: context.palette.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: context.palette.textSecondary,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: context.palette.textSecondary,
          size: 16,
        ),
      ),
    );
  }
}
