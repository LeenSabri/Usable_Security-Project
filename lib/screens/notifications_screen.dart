import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/strings.dart';
import '../widgets/custom_drawer.dart';
import '../constants/colors.dart';
import '../widgets/app_bar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // قائمة البيانات لتحويل الواجهة من ثابتة إلى ديناميكية
  final List<Map<String, dynamic>> notificationData = [
    {
      "title": "Booking Confirmed",
      "sub": "your booking for Hyundai Tucson has been confirmed.",
      "icon": Icons.check_circle,
      "color": Colors.green,
    },
    {
      "title": "Booking Rejected",
      "sub": "We're sorry, your booking for BMW 5 Series has been rejected",
      "icon": Icons.cancel,
      "color": Colors.red,
    },
    {
      "title": "Return Reminder",
      "sub": "Reminder: your rental period for Tesla Model 3 ending soon.",
      "icon": Icons.access_time_filled,
      "color": AppColors.primaryBlue,
    },
  ];

  // دالة حذف العنصر
  void _removeItem(int index) {
    setState(() {
      notificationData.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      appBar: CustomAppBar(title: AppStrings.notificationLbl),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Container(
          width: double.infinity, // لضمان أخذ العرض كامل
          decoration: BoxDecoration(
            color: AppColors.secondaryBlue,
            borderRadius: BorderRadius.circular(25),
          ),
          child: notificationData.isEmpty
              ? const Center(
                  child: Text(
                    "No notifications",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: notificationData.length,
                  itemBuilder: (context, index) {
                    final item = notificationData[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: _buildItem(
                        item["title"],
                        item["sub"],
                        item["icon"],
                        item["color"],
                        index,
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildItem(
    String title,
    String sub,
    IconData icon,
    Color color,
    int index,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  sub,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _removeItem(index), // استدعاء دالة الحذف
            child: const Padding(
              padding: EdgeInsets.only(top: 2, left: 5),
              child: Icon(Icons.close, size: 20, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
