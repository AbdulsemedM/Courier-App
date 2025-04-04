import 'package:courier_app/features/branches/presentation/screen/branches_screen.dart';
import 'package:courier_app/features/countries/presentation/screen/countries_screen.dart';
import 'package:courier_app/features/payment_method/presentation/screen/payment_methods_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/options_widget.dart';

class OptionsScreen extends StatefulWidget {
  const OptionsScreen({super.key});

  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Options'),
      ),
      body: ListView(
        children: [
          OptionItem(
            icon: Icons.account_tree_outlined,
            title: 'Branches',
            onTap: () => _handleOptionTap(context, 'Branches'),
            isDarkMode: isDarkMode,
          ),
          OptionItem(
            icon: Icons.public,
            title: 'Countries',
            onTap: () => _handleOptionTap(context, 'Countries'),
            isDarkMode: isDarkMode,
          ),
          OptionItem(
            icon: Icons.payment,
            title: 'Payment methods',
            onTap: () => _handleOptionTap(context, 'Payment methods'),
            isDarkMode: isDarkMode,
          ),
          OptionItem(
            icon: Icons.local_shipping_outlined,
            title: 'Shipment types',
            onTap: () => _handleOptionTap(context, 'Shipment types'),
            isDarkMode: isDarkMode,
          ),
          OptionItem(
            icon: Icons.miscellaneous_services_outlined,
            title: 'Services modes',
            onTap: () => _handleOptionTap(context, 'Services modes'),
            isDarkMode: isDarkMode,
          ),
          OptionItem(
            icon: Icons.currency_exchange,
            title: 'Currency',
            onTap: () => _handleOptionTap(context, 'Currency'),
            isDarkMode: isDarkMode,
          ),
          OptionItem(
            icon: Icons.directions_bus_filled_outlined,
            title: 'Transport modes',
            onTap: () => _handleOptionTap(context, 'Transport modes'),
            isDarkMode: isDarkMode,
          ),
          OptionItem(
            icon: Icons.currency_exchange_outlined,
            title: 'Exchange Rates',
            onTap: () => _handleOptionTap(context, 'Exchange Rates'),
            isDarkMode: isDarkMode,
          ),
          OptionItem(
            icon: Icons.people_outline,
            title: 'Manage Users',
            onTap: () => _handleOptionTap(context, 'Manage Users'),
            isDarkMode: isDarkMode,
          ),
          OptionItem(
            icon: Icons.support_agent,
            title: 'Manage Agents',
            onTap: () => _handleOptionTap(context, 'Manage Agents'),
            isDarkMode: isDarkMode,
          ),
          OptionItem(
            icon: Icons.groups_outlined,
            title: 'Manage Customers',
            onTap: () => _handleOptionTap(context, 'Manage Customers'),
            isDarkMode: isDarkMode,
          ),
        ],
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
    }
  }
}
