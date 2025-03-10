import 'package:flutter/material.dart';
import '../../model/shipmet_status_model.dart';
import '../widgets/track_order_widget.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_provider.dart';

class ShipmentListScreen extends StatefulWidget {
  const ShipmentListScreen({super.key});

  @override
  State<ShipmentListScreen> createState() => _ShipmentListScreenState();
}

class _ShipmentListScreenState extends State<ShipmentListScreen> {
  bool _isLoading = true;
  List<ShipmentModel> shipments = [];

  @override
  void initState() {
    super.initState();
    _loadShipments();
  }

  Future<void> _loadShipments() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    // TODO: Implement actual API call
    setState(() {
      _isLoading = false;
    });
  }

  void _onShipmentTapped(ShipmentModel shipment) {
    // Handle shipment tap
    // Navigate to shipment details
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkMode
            ? const Color(0xFF0A1931).withOpacity(0.95)
            : Colors.white.withOpacity(0.8),
        title: Text(
          'Shipments',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? TrackOrderWidgets.buildShimmerEffect(isDarkMode)
          : shipments.isEmpty
              ? TrackOrderWidgets.buildEmptyState(isDarkMode)
              : TrackOrderWidgets.buildShipmentList(
                  isDarkMode,
                  shipments,
                  _onShipmentTapped,
                ),
    );
  }
}
