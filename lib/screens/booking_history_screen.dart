import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';
import 'booking_details_screen.dart';
import '../constants/strings.dart';
import '../constants/colors.dart';
import '../widgets/app_bar.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> bookingHistory = [
      {
        'name': 'Hyundai Tucson',
        'type': 'SUV',
        'total': '\$30',
        'image': 'assets/tucson.png',
      },
      {
        'name': 'Toyota Rush',
        'type': 'Family / 7-Seater',
        'total': '\$40',
        'image': 'assets/rush.png',
      },
      {
        'name': 'BMW 5 Series',
        'type': 'Luxury Sedan',
        'total': '\$50',
        'image': 'assets/bmw.png',
      },
      {
        'name': 'Tesla Model 3',
        'type': 'Electric',
        'total': '\$30',
        'image': 'assets/tesla.png',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      drawer: const CustomDrawer(),
      appBar: CustomAppBar(title: AppStrings.bookingHistoryTitle),
      body: Container(
        margin: const EdgeInsets.fromLTRB(15, 10, 15, 15),
        padding: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: AppColors.secondaryBlue,
          borderRadius: BorderRadius.circular(25),
        ),
        child: ListView.builder(
          itemCount: bookingHistory.length,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          itemBuilder: (context, index) {
            final item = bookingHistory[index];
            return _buildBookingCard(context, item);
          },
        ),
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppStrings.carLbl} ${item['name']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${AppStrings.typeLbl} ${item['type']}',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  '${AppStrings.totalPaidLbl} ${item['total']}',
                  style: const TextStyle(color: Colors.black87, fontSize: 13),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Image.asset(
                  item['image'],
                  height: 50,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.directions_car,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 30,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BookingDetailsScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryBlue,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      AppStrings.viewDetailsBtn,
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
