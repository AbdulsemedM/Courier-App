import 'package:courier_app/features/add_shipment/presentation/screens/add_shipment_screen.dart';
import 'package:courier_app/features/barcode_reader/presentation/screen/barcode_reader_screen.dart';
import 'package:courier_app/features/other_settings/presentation/screens/options_screen.dart';
import 'package:courier_app/features/track_order/presentation/screens/track_order_screen.dart';
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
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // final customColors = Theme.of(context).extension<CustomColors>()!;
    final isDarkMode = themeProvider.isDarkMode;

    return Container(
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
                  const Color(0xFFF5F6FA),
                  const Color(0xFFFFFFFF),
                ],
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF5b3895),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: isDarkMode
              ? const Color.fromARGB(255, 91, 19, 207)
              : const Color(0xFF5b3895),
          title: Text(
            'Courier App',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.notifications_none_rounded,
                size: 28,
                color: isDarkMode ? Colors.white70 : Colors.grey.shade800,
              ),
              onPressed: () {
                // Handle notifications
              },
            ),
            IconButton(
              icon: Icon(
                isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: isDarkMode ? Colors.white70 : Colors.grey.shade800,
              ),
              onPressed: () {
                themeProvider.toggleTheme();
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User welcome section with enhanced design
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 239, 146, 96),
                      const Color(0xFFFF5A00),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode
                          ? Colors.black.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white.withOpacity(0.9),
                        child: Icon(
                          Icons.person,
                          size: 36,
                          color: isDarkMode
                              ? Colors.blue.shade200
                              : Colors.blue.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back,',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Amin M.',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Quick action buttons with enhanced design
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.grey.shade800,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
                children: [
                  HomeWidgets.buildEnhancedActionCard(
                    context: context,
                    icon: Icons.add_box_outlined,
                    label: 'Add Shipment',
                    description: 'Create new shipment',
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddShipmentScreen())),
                    isDarkMode: isDarkMode,
                  ),
                  HomeWidgets.buildEnhancedActionCard(
                    context: context,
                    icon: Icons.track_changes,
                    label: 'Track Order',
                    description: 'Track status',
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TrackOrderScreen())),
                    isDarkMode: isDarkMode,
                  ),
                  HomeWidgets.buildEnhancedActionCard(
                    context: context,
                    icon: Icons.barcode_reader,
                    label: 'Scan Barcode',
                    description: 'Scan Bar code',
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BarcodeReaderScreen())),
                    isDarkMode: isDarkMode,
                  ),
                  // HomeWidgets.buildEnhancedActionCard(
                  //   context: context,
                  //   icon: Icons.analytics_outlined,
                  //   label: 'Reports',
                  //   description: 'View reports',
                  //   onTap: () => Navigator.pushNamed(context, '/reports'),
                  //   isDarkMode: isDarkMode,
                  // ),
                  // HomeWidgets.buildEnhancedActionCard(
                  //   context: context,
                  //   icon: Icons.settings,
                  //   label: 'Settings',
                  //   description: 'App settings',
                  //   onTap: () => Navigator.pushNamed(context, '/settings'),
                  //   isDarkMode: isDarkMode,
                  // ),
                ],
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OptionsScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: isDarkMode
                        ? const Color(0xFFFF5A00)
                        : const Color(0xFFFF5A00),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    shadowColor: isDarkMode ? Colors.black54 : Colors.blue[200],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.settings,
                        size: 24,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Other Settings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Statistics Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.grey[850]!.withOpacity(0.5)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode
                          ? Colors.black.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today\'s Statistics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        HomeWidgets.buildStatisticItem(
                          icon: Icons.local_shipping,
                          label: 'Deliveries',
                          value: '24',
                          isDarkMode: isDarkMode,
                        ),
                        HomeWidgets.buildStatisticItem(
                          icon: Icons.pending_actions,
                          label: 'Pending',
                          value: '12',
                          isDarkMode: isDarkMode,
                        ),
                        HomeWidgets.buildStatisticItem(
                          icon: Icons.done_all,
                          label: 'Completed',
                          value: '36',
                          isDarkMode: isDarkMode,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
