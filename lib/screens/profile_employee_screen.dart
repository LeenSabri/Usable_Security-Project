import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'update_profile_screen.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/app_bar.dart';

class ProfileEmployeeScreen extends StatelessWidget {
  const ProfileEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      drawer: const CustomDrawer(),
      appBar: CustomAppBar(title: "Profile"),
      body: Container(
        margin: const EdgeInsets.fromLTRB(15, 10, 15, 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.secondaryBlue,
          borderRadius: BorderRadius.circular(25),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  const Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.primaryBlue,
                      child: Icon(
                        Icons.person,
                        size: 100,
                        color: AppColors.primaryWhite,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.primaryBlue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UpdateProfileScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Rawan_Yahya1',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 20),
              _buildProfileField('Role', 'Delivery', isReadOnly: true),
              _buildProfileField('ID Number', '1221239'),
              _buildProfileField('Full Name', 'Rawan Waleed Yousef Yahya'),
              _buildProfileField('Email', 'Input text'),
              _buildProfileField('DOB', '2/3/2004', isDropdown: true),
              _buildProfileField('Username', 'Input text'),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField(
    String label,
    String value, {
    bool isReadOnly = false,
    bool isDropdown = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryWhite.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              readOnly: isReadOnly || isDropdown,
              controller: TextEditingController(text: value),
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 12,
                ),
                border: InputBorder.none,
                suffixIcon: isDropdown
                    ? const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.primaryBlue,
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
