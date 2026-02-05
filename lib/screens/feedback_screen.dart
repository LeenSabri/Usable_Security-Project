import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';
import '../constants/colors.dart';
import '../widgets/app_bar.dart';
import '../widgets/success_popup.dart';
import 'booking_details_screen.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  // الخيارات المتاحة للتقييم السريع
  Map<String, bool> options = {
    'Clean': true,
    'Easy Booking': true,
    'Good Service': true,
    'Comfortable': true,
    'On Time': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      drawer: const CustomDrawer(),
      appBar: CustomAppBar(title: "Feedback"),
      body: Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.secondaryBlue,
          borderRadius: BorderRadius.circular(25),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Icon(
                Icons.favorite,
                color: AppColors.primaryBlue,
                size: 30,
              ),
              Image.asset(
                'assets/tucson.png',
                height: 120,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.directions_car,
                  size: 80,
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
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.primaryWhite,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rate Your Experience',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    const Divider(),
                    // عرض النجوم (Stars Rating)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return Icon(
                          index < 4 ? Icons.star : Icons.star_border,
                          color: Colors.orangeAccent,
                          size: 40,
                        );
                      }),
                    ),
                    const Divider(),
                    const Text(
                      'Write your feedback',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText:
                            'share your experience with this car and service',
                        hintStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // الخيارات السريعة (Chips/Checkboxes)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: options.keys.map((String key) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE1EBF5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: options[key],
                                  activeColor: AppColors.primaryBlue,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      options[key] = value!;
                                    });
                                  },
                                ),
                              ),
                              Text(
                                key,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              // زر الإرسال مع منطق الانتقال
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () async {
                    // 1. إظهار نافذة النجاح وانتظار إغلاقها
                    await showDialog(
                      context: context,
                      barrierDismissible: false, // لا يغلق إلا بالضغط على الزر
                      builder: (context) => SuccessPopup(
                        title: "Successful!",
                        message: "Your feedback has been sent successfully.",
                      ),
                    );

                    // 2. الانتقال لصفحة BookingDetailsScreen
                    if (mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BookingDetailsScreen(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Submit Feedback',
                    style: TextStyle(
                      color: AppColors.primaryWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
