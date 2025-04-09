import 'package:courier_app/features/branches/presentation/screen/branches_screen.dart';
import 'package:courier_app/features/countries/presentation/screen/countries_screen.dart';
import 'package:courier_app/features/currency/presentation/screen/currency_screen.dart';
import 'package:courier_app/features/exchange_rate/presentation/screen/exchange_rate_screen.dart';
import 'package:courier_app/features/manage_agent/presentation/screen/manage_agent_screen.dart';
import 'package:courier_app/features/manage_customers/presentation/screen/manage_customers_screen.dart';
import 'package:courier_app/features/payment_method/presentation/screen/payment_methods_screen.dart';
import 'package:courier_app/features/services_mode/presentation/screen/services_mode_screen.dart';
import 'package:courier_app/features/shipment_types/presentation/screen/shipment_types_screen.dart';
import 'package:courier_app/features/transport_modes/presentation/screen/transport_modes_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/options_widget.dart';

class OptionsScreen extends StatelessWidget {
  const OptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [
                    const Color(0xFF1A1C2E),
                    const Color(0xFF2D3250),
                  ]
                : [
                    const Color(0xFFF0F4FF),
                    const Color(0xFFFFFFFF),
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Options',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Main Options Grid
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.1,
                        children: [
                          OptionCard(
                            icon: Icons.account_tree_outlined,
                            title: 'Branches',
                            subtitle: 'Manage branches',
                            color: Colors.blue,
                            isDarkMode: isDarkMode,
                            onTap: () => _handleOptionTap(context, 'Branches'),
                          ),
                          OptionCard(
                            icon: Icons.public,
                            title: 'Countries',
                            subtitle: 'Manage locations',
                            color: Colors.green,
                            isDarkMode: isDarkMode,
                            onTap: () => _handleOptionTap(context, 'Countries'),
                          ),
                          OptionCard(
                            icon: Icons.payment,
                            title: 'Payment Methods',
                            subtitle: 'Configure options',
                            color: Colors.orange,
                            isDarkMode: isDarkMode,
                            onTap: () =>
                                _handleOptionTap(context, 'Payment methods'),
                          ),
                          OptionCard(
                            icon: Icons.local_shipping_outlined,
                            title: 'Shipment Types',
                            subtitle: 'Manage types',
                            color: Colors.purple,
                            isDarkMode: isDarkMode,
                            onTap: () =>
                                _handleOptionTap(context, 'Shipment types'),
                          ),
                          OptionCard(
                            icon: Icons.miscellaneous_services_outlined,
                            title: 'Services Modes',
                            subtitle: 'Configure services',
                            color: Colors.teal,
                            isDarkMode: isDarkMode,
                            onTap: () =>
                                _handleOptionTap(context, 'Services modes'),
                          ),
                          OptionCard(
                            icon: Icons.currency_exchange,
                            title: 'Currency',
                            subtitle: 'Set currency options',
                            color: Colors.indigo,
                            isDarkMode: isDarkMode,
                            onTap: () => _handleOptionTap(context, 'Currency'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Additional Settings Section
                      Text(
                        'Additional Settings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListOptionCard(
                        icon: Icons.directions_bus_filled_outlined,
                        title: 'Transport Modes',
                        subtitle: 'Configure transportation options',
                        color: Colors.amber,
                        isDarkMode: isDarkMode,
                        onTap: () =>
                            _handleOptionTap(context, 'Transport modes'),
                      ),
                      ListOptionCard(
                        icon: Icons.currency_exchange,
                        title: 'Exchange Rates',
                        subtitle: 'Configure exchange rates',
                        color: Colors.deepPurpleAccent,
                        isDarkMode: isDarkMode,
                        onTap: () =>
                            _handleOptionTap(context, 'Exchange rates'),
                      ),
                      ListOptionCard(
                        icon: Icons.people_outline,
                        title: 'User Management',
                        subtitle: 'Manage user access and permissions',
                        color: Colors.cyan,
                        isDarkMode: isDarkMode,
                        onTap: () =>
                            _handleOptionTap(context, 'User management'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) {
          final isDarkMode = Theme.of(context).brightness == Brightness.dark;
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1A1C2E) : Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[600] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                // Title
                Text(
                  'User Management',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select a category to manage',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 40),
                // Options Grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
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
                          // Navigate to user management screen
                        },
                      ),
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
                              builder: (context) =>
                                  const ManageCustomersScreen()));
                          // Navigate to customer management screen
                        },
                      ),
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
                          // Navigate to agent management screen
                        },
                      ),
                    ],
                  ),
                ),
              ],
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
    // final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
}
