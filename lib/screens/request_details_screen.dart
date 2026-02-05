import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';
import '../constants/colors.dart';
import '../widgets/app_bar.dart';
import '../widgets/success_popup.dart';

class RequestDetailsScreen extends StatelessWidget {
  const RequestDetailsScreen({super.key});

  void _showApproveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SuccessPopup(
        title: "Successful!",
        message:
            "The request has been approved successfully and the customer will be notified .",
      ),
    );
  }

  void _showRejectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFEBEE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.report_problem_rounded,
                    color: Colors.redAccent,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Request Rejected',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Are you sure you want to reject this request? This action will notify the user.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Reject',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      drawer: const CustomDrawer(),
      appBar: CustomAppBar(title: "Request Details"),
      body: Container(
        margin: const EdgeInsets.fromLTRB(15, 5, 15, 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.secondaryBlue,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          children: [
            Image.asset(
              'assets/images/tucson.png',
              height: 140,
              fit: BoxFit.contain,
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
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow(Icons.copy, 'Rental ID:', '1345'),
                      _buildDetailRow(
                        Icons.directions_car,
                        'Car ID:',
                        '658347244',
                      ),
                      _buildDetailRow(
                        Icons.calendar_month,
                        'Rental Dates:',
                        'Start Date: 4-3-2026\nEnd Date: 5-5-2026',
                      ),
                      _buildDetailRow(
                        Icons.palette_outlined,
                        'Color:',
                        'White',
                      ),
                      _buildDetailRow(
                        Icons.location_on_outlined,
                        'Location:',
                        'Ramallah',
                      ),
                      _buildDetailRow(
                        Icons.phone_outlined,
                        'Phone Number:',
                        '0591234567',
                      ),
                      _buildImageSection(
                        Icons.person_outline,
                        'Image Of Personal ID Card:',
                        'assets/images/id_card.png',
                      ),
                      _buildImageSection(
                        Icons.minor_crash_outlined,
                        'Image Of Driving License Card:',
                        'assets/images/license.png',
                      ),
                      _buildDetailRow(
                        Icons.attach_money,
                        'Total Price:',
                        '\$ 85',
                      ),
                      _buildDetailRow(
                        Icons.payment,
                        'Payment Method:',
                        'Visa Card',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showRejectDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFF4aa1b9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Reject',
                      style: TextStyle(
                        color: AppColors.primaryWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showApproveDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Approve',
                      style: TextStyle(
                        color: AppColors.primaryWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(IconData icon, String label, String imagePath) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 22),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
