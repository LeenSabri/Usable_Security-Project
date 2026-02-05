import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/app_bar.dart';
import '../widgets/success_popup.dart';

class MyDeliveriesScreen extends StatefulWidget {
  const MyDeliveriesScreen({super.key});

  @override
  State<MyDeliveriesScreen> createState() => _MyDeliveriesScreenState();
}

class _MyDeliveriesScreenState extends State<MyDeliveriesScreen> {
  // قائمة البيانات لتمكين الحذف الديناميكي
  final List<Map<String, String>> myDeliveries = [
    {
      "carName": "Hyundai Tucson",
      "date": "1/1/2026",
      "locationLabel": "Pickup Location:",
      "locationValue": "Ramallah Downtown",
      "phone": "0591234567",
      "imagePath": "assets/tucson.png",
    },
  ];

  // دالة لحذف الطلبية من القائمة
  void _removeDelivery(int index) {
    setState(() {
      myDeliveries.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      drawer: const CustomDrawer(viewMode: 2),
      appBar: CustomAppBar(title: "My Deliveries"),
      body: myDeliveries.isEmpty
          ? const Center(
              child: Text(
                "No deliveries assigned yet.",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              itemCount: myDeliveries.length,
              itemBuilder: (context, index) {
                final delivery = myDeliveries[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: _buildMyDeliveryCard(
                    context,
                    index: index,
                    carName: delivery['carName']!,
                    date: delivery['date']!,
                    locationLabel: delivery['locationLabel']!,
                    locationValue: delivery['locationValue']!,
                    phone: delivery['phone']!,
                    imagePath: delivery['imagePath']!,
                  ),
                );
              },
            ),
    );
  }

  Widget _buildMyDeliveryCard(
    BuildContext context, {
    required int index,
    required String carName,
    required String date,
    required String locationLabel,
    required String locationValue,
    required String phone,
    required String imagePath,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFADD8E6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(imagePath, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    Text(
                      carName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0C417A),
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      date,
                      style: const TextStyle(
                        color: Color(0xFF0C417A),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                _buildInfoRow(
                  icon: Icons.location_on,
                  iconColor: Colors.green,
                  label: locationLabel,
                  value: locationValue,
                ),
                const Divider(height: 20, thickness: 0.5),
                _buildInfoRow(
                  icon: Icons.phone_in_talk,
                  iconColor: const Color(0xFF0C417A),
                  label: "Customer Phone:",
                  value: phone,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: () async {
                // إظهار الـ popup
                await showDialog(
                  context: context,
                  builder: (context) => SuccessPopup(
                    title: "Done",
                    message:
                        "The delivery status has been successfully updated and recorded in the system",
                  ),
                );
                // بعد إغلاق الـ popup يتم حذف الطلبية
                _removeDelivery(index);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0C417A),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Mark as Delivered",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black,
              ),
            ),
            Text(
              value,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
