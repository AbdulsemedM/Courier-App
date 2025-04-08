import 'package:courier_app/features/branches/presentation/screen/branches_screen.dart';
import 'package:courier_app/features/countries/presentation/screen/countries_screen.dart';
import 'package:courier_app/features/currency/presentation/screen/currency_screen.dart';
import 'package:courier_app/features/payment_method/presentation/screen/payment_methods_screen.dart';
import 'package:courier_app/features/services_mode/presentation/screen/services_mode_screen.dart';
import 'package:courier_app/features/shipment_types/presentation/screen/shipment_types_screen.dart';
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
    }
  }
}
