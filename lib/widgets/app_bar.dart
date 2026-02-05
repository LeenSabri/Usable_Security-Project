
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../screens/profile_employee_screen.dart';
import '../screens/profile_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
   /// 0 -> Customer
  /// 1 -> Booking Office Employee
  /// 2 -> Delivery
  /// 3 -> Online request Approver
  /// 4 -> Manager
  final int viewMode;
  const CustomAppBar({super.key, required this.title, this.viewMode = 0});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryBlue,
      elevation: 0,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.primaryWhite,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.primaryWhite),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: IconButton(
            icon: const Icon(
              Icons.account_circle,
              size: 35,
              color: AppColors.primaryWhite,
            ),
            onPressed: () {
              if (viewMode != 4) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileEmployeeScreen(),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
