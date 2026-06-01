import 'package:flutter/material.dart';
import '../../model/shipmet_status_model.dart';
import '../widgets/track_order_widget.dart';
import 'package:courier_app/core/theme/app_palette.dart';

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
    final isDarkMode = context.isDarkMode;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkMode
            ? const Color.fromARGB(255, 75, 23, 160)
            : const Color.fromARGB(255, 75, 23, 160),
        title: Text(
          'Shipments',
          style: TextStyle(
            color: context.palette.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? TrackOrderWidgets.buildShimmerEffect(context)
          : shipments.isEmpty
              ? TrackOrderWidgets.buildEmptyState(context)
              : TrackOrderWidgets.buildShipmentList(
                  isDarkMode,
                  shipments,
                  _onShipmentTapped,
                ),
    );
  }
}
