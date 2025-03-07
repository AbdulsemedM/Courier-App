import 'package:flutter/material.dart';
import '../widget/home_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Courier App',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none_rounded,
                size: 28, color: Colors.grey.shade800),
            onPressed: () {
              // Handle notifications
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
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade500, Colors.blue.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 36, color: Colors.blue),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
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
                  color: Colors.grey.shade800,
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
                ),
                HomeWidgets.buildQuickActionButton(
                  icon: Icons.track_changes,
                  label: 'Track Order',
                  onTap: () {
                    // Handle track order
                  },
                ),
                HomeWidgets.buildQuickActionButton(
                  icon: Icons.history,
                  label: 'History',
                  onTap: () {
                    // Handle history
                  },
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
                      color: Colors.grey.shade800,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle view all
                    },
                    child: Text(
                      'View All',
                      style: TextStyle(
                        color: Colors.blue.shade700,
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
            ),
            const SizedBox(height: 16),
            HomeWidgets.buildDeliveryCard(
              orderNumber: 'ORDER #5678',
              status: 'Pending Pickup',
              address: '456 Oak Ave, Town',
              date: '2024-03-21',
            ),
          ],
        ),
      ),
    );
  }
}
