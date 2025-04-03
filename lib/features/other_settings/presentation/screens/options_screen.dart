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
          ),
          OptionItem(
            icon: Icons.public,
            title: 'Countries',
            onTap: () => _handleOptionTap(context, 'Countries'),
          ),
          OptionItem(
            icon: Icons.payment,
            title: 'Payment methods',
            onTap: () => _handleOptionTap(context, 'Payment methods'),
          ),
          OptionItem(
            icon: Icons.local_shipping_outlined,
            title: 'Shipment types',
            onTap: () => _handleOptionTap(context, 'Shipment types'),
          ),
          OptionItem(
            icon: Icons.miscellaneous_services_outlined,
            title: 'Services modes',
            onTap: () => _handleOptionTap(context, 'Services modes'),
          ),
          OptionItem(
            icon: Icons.currency_exchange,
            title: 'Currency',
            onTap: () => _handleOptionTap(context, 'Currency'),
          ),
          OptionItem(
            icon: Icons.directions_bus_filled_outlined,
            title: 'Transport modes',
            onTap: () => _handleOptionTap(context, 'Transport modes'),
          ),
          OptionItem(
            icon: Icons.currency_exchange_outlined,
            title: 'Exchange Rates',
            onTap: () => _handleOptionTap(context, 'Exchange Rates'),
          ),
          OptionItem(
            icon: Icons.people_outline,
            title: 'Manage Users',
            onTap: () => _handleOptionTap(context, 'Manage Users'),
          ),
          OptionItem(
            icon: Icons.support_agent,
            title: 'Manage Agents',
            onTap: () => _handleOptionTap(context, 'Manage Agents'),
          ),
          OptionItem(
            icon: Icons.groups_outlined,
            title: 'Manage Customers',
            onTap: () => _handleOptionTap(context, 'Manage Customers'),
          ),
        ],
      ),
    );
  }

  void _handleOptionTap(BuildContext context, String option) {
    // You can implement specific navigation logic here
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(option)),
          body: Center(child: Text('$option content goes here')),
        ),
      ),
    );
  }
}
