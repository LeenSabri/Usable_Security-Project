import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';
import '../constants/strings.dart';
import '../constants/colors.dart';
import '../widgets/app_bar.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      appBar: CustomAppBar(title: "About Us"),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 25),
            Image.asset(
              'assets/image/logo.png',
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.secondaryBlue,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      AppStrings.aboutUsText,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 30),

                    _ContactRow(
                      icon: Icons.phone,
                      title: AppStrings.phoneLbl,
                      value: AppStrings.phoneAboutUs,
                      isSpecialColor: true,
                    ),
                    const SizedBox(height: 20),
                    _ContactRow(
                      icon: Icons.email,
                      title: AppStrings.emailLbl,
                      value: AppStrings.emailAboutUs,
                      isSpecialColor: true,
                    ),
                    const SizedBox(height: 20),
                    _ContactRow(
                      icon: Icons.location_on,
                      title: AppStrings.locationLbl,
                      value: AppStrings.locationAboutUs,
                      isSpecialColor: false,
                    ),
                    const SizedBox(height: 20),
                    _ContactRow(
                      icon: Icons.calendar_today,
                      title: "Working Hours:",
                      value: AppStrings.workingHoursAboutUs,
                      isSpecialColor: false,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isSpecialColor;

  const _ContactRow({
    required this.icon,
    required this.title,
    required this.value,
    this.isSpecialColor = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF0D47A1), size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: isSpecialColor
                      ? const Color(0xFF038C8C)
                      : Colors.black87,
                  fontSize: 14,
                  fontWeight: isSpecialColor
                      ? FontWeight.w500
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
