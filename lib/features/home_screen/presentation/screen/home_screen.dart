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
    final customColors = Theme.of(context).extension<CustomColors>()!;
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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: isDarkMode
              ? const Color(0xFF0A1931).withOpacity(0.95)
              : Colors.white.withOpacity(0.8),
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
              // User welcome section
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      customColors.gradientStart,
                      customColors.gradientEnd,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 36,
                        color: isDarkMode
                            ? Colors.blue.shade200
                            : Colors.blue.shade700,
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
                          'John Doe',
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

              // Quick action buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.grey.shade800,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  HomeWidgets.buildQuickActionButton(
                    icon: Icons.local_shipping,
                    label: 'Send Package',
                    onTap: () {
                      // Handle send package
                    },
                    isDarkMode: isDarkMode,
                  ),
                  HomeWidgets.buildQuickActionButton(
                    icon: Icons.track_changes,
                    label: 'Track Order',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TrackOrderScreen()));
                    },
                    isDarkMode: isDarkMode,
                  ),
                  HomeWidgets.buildQuickActionButton(
                    icon: Icons.history,
                    label: 'History',
                    onTap: () {
                      // Handle history
                    },
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Active deliveries section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Active Deliveries',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.grey.shade800,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle view all
                      },
                      child: Text(
                        'View All',
                        style: TextStyle(
                          color: isDarkMode
                              ? Colors.blue.shade200
                              : Colors.blue.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              HomeWidgets.buildDeliveryCard(
                orderNumber: 'ORDER #1234',
                status: 'In Transit',
                address: '123 Main St, City',
                date: '2024-03-20',
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 16),
              HomeWidgets.buildDeliveryCard(
                orderNumber: 'ORDER #5678',
                status: 'Pending Pickup',
                address: '456 Oak Ave, Town',
                date: '2024-03-21',
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ),
        // bottomNavigationBar: Theme(
        //   data: Theme.of(context).copyWith(
        //     splashColor: Colors.transparent,
        //     highlightColor: Colors.transparent,
        //   ),
        //   child: BottomNavigationBar(
        //     currentIndex: 0,
        //     backgroundColor: isDarkMode ? const Color(0xFF1F1F1F) : Colors.white,
        //     selectedItemColor: isDarkMode ? Colors.blue.shade200 : Colors.blue.shade700,
        //     unselectedItemColor: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
        //     items: const [
        //       BottomNavigationBarItem(
        //         icon: Icon(Icons.home_rounded),
        //         label: 'Home',
        //       ),
        //       BottomNavigationBarItem(
        //         icon: Icon(Icons.map_rounded),
        //         label: 'Map',
        //       ),
        //       BottomNavigationBarItem(
        //         icon: Icon(Icons.person_rounded),
        //         label: 'Profile',
        //       ),
        //     ],
        //     onTap: (index) {
        //       // Handle navigation
        //     },
      ),
    );
    // );
  }
}
