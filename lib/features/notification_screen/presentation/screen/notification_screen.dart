import 'package:flutter/material.dart';
import 'package:courier_app/core/theme/app_palette.dart';
import '../widget/notification_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.palette.appBarBackground,
        title: Text(
          'Notifications',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: context.palette.textPrimary,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              // Handle mark all as read
            },
            icon: Icon(Icons.done_all,
                color:
                    isDarkMode ? Colors.blue.shade200 : Colors.blue.shade700),
            label: Text(
              'Mark all as read',
              style: TextStyle(
                color: isDarkMode ? Colors.blue.shade200 : Colors.blue.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          NotificationWidgets.buildDateHeader(
            'Today',
            context: context,
          ),
          NotificationWidgets.buildNotificationItem(
            context: context,
            icon: Icons.local_shipping,
            color: Colors.green,
            title: 'Package Delivered',
            description: 'Your package #1234 has been delivered successfully',
            time: '2 hours ago',
            isUnread: true,
            onTap: () {
              // Handle notification tap
            },
          ),
          NotificationWidgets.buildNotificationItem(
            context: context,
            icon: Icons.warning_rounded,
            color: Colors.orange,
            title: 'Delivery Delayed',
            description:
                'Package #5678 delivery is delayed due to heavy traffic',
            time: '4 hours ago',
            isUnread: true,
            onTap: () {
              // Handle notification tap
            },
          ),
          NotificationWidgets.buildDateHeader(
            'Yesterday',
            context: context,
          ),
          NotificationWidgets.buildNotificationItem(
            context: context,
            icon: Icons.location_on,
            color: Colors.blue,
            title: 'Out for Delivery',
            description: 'Package #9012 is out for delivery to your location',
            time: '1 day ago',
            isUnread: false,
            onTap: () {
              // Handle notification tap
            },
          ),
          NotificationWidgets.buildNotificationItem(
            context: context,
            icon: Icons.receipt_long,
            color: Colors.purple,
            title: 'New Invoice',
            description: 'Invoice for package #3456 has been generated',
            time: '1 day ago',
            isUnread: false,
            onTap: () {
              // Handle notification tap
            },
          ),
          NotificationWidgets.buildDateHeader(
            'Older',
            context: context,
          ),
          NotificationWidgets.buildNotificationItem(
            context: context,
            icon: Icons.discount_rounded,
            color: Colors.pink,
            title: 'Special Offer',
            description: 'Get 20% off on your next international shipment',
            time: '3 days ago',
            isUnread: false,
            onTap: () {
              // Handle notification tap
            },
          ),
          NotificationWidgets.buildNotificationItem(
            context: context,
            icon: Icons.rate_review,
            color: Colors.teal,
            title: 'Rate Your Experience',
            description: 'How was your experience with delivery #7890?',
            time: '5 days ago',
            isUnread: false,
            onTap: () {
              // Handle notification tap
            },
          ),
        ],
      ),
    );
  }
}
