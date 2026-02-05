import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';
import '../constants/colors.dart';
import '../widgets/app_bar.dart';

class ManagerNotificationScreen extends StatefulWidget {
  const ManagerNotificationScreen({super.key});

  @override
  State<ManagerNotificationScreen> createState() =>
      _ManagerNotificationScreenState();
}

class _ManagerNotificationScreenState extends State<ManagerNotificationScreen> {
  final List<Map<String, String>> notifications = [
    {
      'title': 'Car Maintenance',
      'message': 'The Toyota Yaris car was sent for maintenance',
    },
    {
      'title': 'New Booking',
      'message': 'A new booking has been made for BMW X5',
    },
    {
      'title': 'Oil Change',
      'message': 'System alert: Mercedes C200 needs an oil change',
    },
  ];

  void _removeNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      drawer: const CustomDrawer(),
      appBar: CustomAppBar(title: "Notification"),
      body: Container(
        margin: const EdgeInsets.fromLTRB(15, 10, 15, 15),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.secondaryBlue,
          borderRadius: BorderRadius.circular(25),
        ),
        child: notifications.isEmpty
            ? const Center(
                child: Text(
                  "No notifications available",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return _buildNotificationCard(
                    notifications[index]['title']!,
                    notifications[index]['message']!,
                    index,
                  );
                },
              ),
      ),
    );
  }

  Widget _buildNotificationCard(String title, String message, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.build_circle_rounded,
            color: Colors.orangeAccent,
            size: 40,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _removeNotification(index),
            child: const Icon(
              Icons.close,
              color: AppColors.primaryBlue,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
