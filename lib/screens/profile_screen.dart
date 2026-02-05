import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/strings.dart';
import '../widgets/custom_drawer.dart';
import '../constants/colors.dart';
import '../widgets/app_bar.dart';
import '../widgets/success_popup.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool obs1 = true, obs2 = true, obs3 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      appBar: CustomAppBar(title: AppStrings.profileLbl),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.secondaryBlue,
            borderRadius: BorderRadius.circular(25),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primaryBlue,
                  child: Icon(
                    Icons.person,
                    size: 70,
                    color: AppColors.secondaryBlue,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Leen_Sabri1',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: 30),
                _field(
                  AppStrings.oldPassLbl,
                  obs1,
                  () => setState(() => obs1 = !obs1),
                ),
                const SizedBox(height: 15),
                _field(
                  AppStrings.newPassLbl,
                  obs2,
                  () => setState(() => obs2 = !obs2),
                ),
                const SizedBox(height: 15),
                _field(
                  AppStrings.confirmNewPassLbl,
                  obs3,
                  () => setState(() => obs3 = !obs3),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => SuccessPopup(
                        title: "Successfully",
                        message: "Your password has been updated successfully.",
                      ),
                    );
                  },
                  child: const Text(
                    AppStrings.saveBtn,
                    style: TextStyle(color: AppColors.primaryWhite),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(String label, bool obs, VoidCallback toggle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          obscureText: obs,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.primaryWhite,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(obs ? Icons.visibility_off : Icons.visibility),
              onPressed: toggle,
            ),
          ),
        ),
      ],
    );
  }
}
