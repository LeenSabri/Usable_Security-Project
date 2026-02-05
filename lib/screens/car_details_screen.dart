import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/main_menu_screen.dart';
import '../widgets/custom_drawer.dart';
import 'car_booking_screen.dart';
import '../constants/strings.dart';
import '../constants/colors.dart';
import '../widgets/app_bar.dart';

class CarDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> car;
  final int isCustomer = 0;
  const CarDetailsScreen({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryBlue,
      appBar: CustomAppBar(title: AppStrings.carDetailsLbl),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildCarHeader(),
            const SizedBox(height: 20),
            _buildDetailsTable(),
            const SizedBox(height: 20),
            _buildDescription(),
            const SizedBox(height: 30),

            _buildBookButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCarHeader() {
    return Stack(
      children: [
        if (isCustomer != 1)
          const Align(
            alignment: Alignment.topLeft,
            child: Icon(
              Icons.favorite_border,
              color: AppColors.primaryWhite,
              size: 35,
            ),
          ),
        Center(
          child: Column(
            children: [
              const Icon(
                Icons.directions_car,
                size: 160,
                color: AppColors.primaryBlue,
              ),
              const SizedBox(height: 10),
              Text(
                car['name'] ?? 'Unknown Car',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsTable() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Table(
        border: TableBorder.all(color: Colors.grey.shade100, width: 1),
        children: [
          _buildTableRow('Brand', car['brand']?.toString() ?? car['type'] ?? 'Car'),
          _buildTableRow('Model', car['model']?.toString() ?? 'N/A'),
          _buildTableRow(AppStrings.passengersLbl, car['seats']?.toString() ?? '5'),
          _buildTableRow(AppStrings.colorLbl, car['color']?.toString() ?? 'N/A'),
          _buildTableRow(AppStrings.fuelLbl, car['fuel_type']?.toString() ?? 'Petrol'),
          _buildTableRow('Transmission', car['transmission']?.toString() ?? 'Automatic'),
          _buildTableRow(AppStrings.dailyPriceLbl, car['price'] ?? '\$0'),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.descriptionLbl,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              car['description']?.toString() ?? 'Quality car for rent',
              style: const TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            isCustomer == 0
                ? MaterialPageRoute(
                    builder: (context) => CarBookingScreen(car: car),
                  )
                : MaterialPageRoute(builder: (context) => MainMenuScreen()),
          );
        },

        child: Text(
          isCustomer == 0 ? AppStrings.bookNowBtn : AppStrings.backBtn,
          style: TextStyle(color: AppColors.primaryWhite, fontSize: 18),
        ),
      ),
    );
  }
}
