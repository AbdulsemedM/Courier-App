import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_provider.dart';

enum ShipmentType {
  r4p,
  arrived,
  arriving,
  delivered,
  all,
}

class ShipmentTypeModal extends StatelessWidget {
  final Function(ShipmentType) onTypeSelected;

  const ShipmentTypeModal({
    super.key,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF5b3895) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Text(
              'Select Shipment Type',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Options
          _buildOption(
            context: context,
            isDarkMode: isDarkMode,
            icon: Icons.inventory_2_outlined,
            title: 'R4P Shipments',
            subtitle: 'Ready for pickup',
            color: Colors.orange,
            type: ShipmentType.r4p,
          ),
          _buildOption(
            context: context,
            isDarkMode: isDarkMode,
            icon: Icons.local_shipping_outlined,
            title: 'Arrived Shipments',
            subtitle: 'Shipments that have arrived',
            color: Colors.green,
            type: ShipmentType.arrived,
          ),
          _buildOption(
            context: context,
            isDarkMode: isDarkMode,
            icon: Icons.directions_transit_outlined,
            title: 'Arriving Shipments',
            subtitle: 'Shipments in transit',
            color: Colors.blue,
            type: ShipmentType.arriving,
          ),
          _buildOption(
            context: context,
            isDarkMode: isDarkMode,
            icon: Icons.check_circle_outline,
            title: 'Delivered Shipments',
            subtitle: 'Successfully delivered',
            color: Colors.teal,
            type: ShipmentType.delivered,
          ),
          _buildOption(
            context: context,
            isDarkMode: isDarkMode,
            icon: Icons.assessment_outlined,
            title: 'All Shipments',
            subtitle: 'View all shipment reports',
            color: Colors.purple,
            type: ShipmentType.all,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required bool isDarkMode,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required ShipmentType type,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            onTypeSelected(type);
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(isDarkMode ? 0.2 : 0.1),
                  color.withOpacity(isDarkMode ? 0.1 : 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: color.withOpacity(isDarkMode ? 0.3 : 0.2),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(isDarkMode ? 0.3 : 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: isDarkMode ? Colors.white : color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

