import 'package:flutter/material.dart';
import 'feedback_screen.dart';
import '../widgets/custom_drawer.dart';
import '../constants/strings.dart';
import '../constants/colors.dart';
import '../widgets/app_bar.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      drawer: const CustomDrawer(),
      appBar: CustomAppBar(title: AppStrings.bookingDetailsTitle),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.secondaryBlue,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  Image.asset(
                    'assets/tucson.png',
                    height: 150,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.directions_car,
                      size: 100,
                      color: AppColors.primaryWhite,
                    ),
                  ),

                  const Text(
                    'Hyundai Tucson',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primaryWhite,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildDetailRow(
                              Icons.copy,
                              AppStrings.rentalIDLbl,
                              '1345',
                            ),
                            _buildDetailRow(
                              Icons.directions_car_filled_outlined,
                              AppStrings.carIDLbl,
                              '658347244',
                            ),
                            _buildDetailRow(
                              Icons.calendar_month,
                              AppStrings.rentalDatesLbl,
                              '${AppStrings.startDateLbl} 4-3-2025\n${AppStrings.endDateLbl} 5-5-2025',
                            ),
                            _buildDetailRow(
                              Icons.color_lens_outlined,
                              AppStrings.colorLbl,
                              'White',
                            ),
                            _buildDetailRow(
                              Icons.location_on_outlined,
                              AppStrings.locationLbl,
                              'Ramallah',
                            ),
                            _buildDetailRow(
                              Icons.phone_outlined,
                              AppStrings.phoneLbl,
                              '0591234567',
                            ),
                            _buildImageSection(
                              Icons.person_outline,
                              AppStrings.imageOfPersonalIDCardLbl,
                              'assets/id_card.png',
                            ),
                            _buildImageSection(
                              Icons.directions_car_outlined,
                              AppStrings.imageOfDrivingLicenseCardLbl,
                              'assets/license.png',
                            ),
                            _buildDetailRow(
                              Icons.attach_money,
                              AppStrings.totalPriceLbl,
                              '\$ 65',
                            ),
                            _buildDetailRow(
                              Icons.payment,
                              AppStrings.paymentMethodLbl,
                              'Visa Card',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              AppStrings.backBtn,
                              style: TextStyle(color: AppColors.primaryWhite),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FeedbackScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              AppStrings.feedbackBtn,
                              style: TextStyle(color: AppColors.primaryWhite),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: Colors.black87),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(IconData icon, String title, String assetPath) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 22, color: Colors.black87),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              assetPath,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 100,
                color: Colors.grey[200],
                child: const Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
