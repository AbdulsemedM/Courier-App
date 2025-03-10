import 'package:courier_app/features/track_order/bloc/track_order_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/shipmet_status_model.dart';
import '../widgets/track_order_widget.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_provider.dart';

class TrackOrderScreen extends StatefulWidget {
  const TrackOrderScreen({super.key});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  @override
  void initState() {
    super.initState();
    _loadShipments();
  }

  Future<void> _loadShipments() async {
    context.read<TrackOrderBloc>().add(TrackOrder());
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
      body: RefreshIndicator(
        onRefresh: _loadShipments,
        child: BlocBuilder<TrackOrderBloc, TrackOrderState>(
          builder: (context, state) {
            if (state is TrackOrderLoading) {
              return TrackOrderWidgets.buildShimmerEffect(isDarkMode);
            }
            
            if (state is TrackOrdeFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: isDarkMode ? Colors.red[300] : Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading shipments',
                      style: TextStyle(
                        fontSize: 18,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.errorMessage,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.grey[500] : Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _loadShipments,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode ? Colors.blue[700] : Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }

            if (state is TrackOrderSuccess) {
              if (state.shipments.isEmpty) {
                return TrackOrderWidgets.buildEmptyState(isDarkMode);
              }

              return TrackOrderWidgets.buildShipmentList(
                isDarkMode,
                state.shipments,
                _onShipmentTapped,
              );
            }

            // Initial state
            return TrackOrderWidgets.buildShimmerEffect(isDarkMode);
          },
        ),
      ),
    );
  }
}
