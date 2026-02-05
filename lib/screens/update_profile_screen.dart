import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/colors.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/app_bar.dart';
import 'change_password_screen.dart';
import '../widgets/success_popup.dart';
class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,

      drawer: const CustomDrawer(),
      appBar: CustomAppBar(title: "Update Profile"),
      body: Container(
        margin: const EdgeInsets.fromLTRB(15, 5, 15, 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.secondaryBlue,
          borderRadius: BorderRadius.circular(25),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CircleAvatar(
                radius: 55,
                backgroundColor: Colors.white24,
                child: Icon(
                  Icons.person,
                  size: 90,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Rawan_Yahya1',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 15),

              _buildField('Role', 'Delivery', isReadOnly: true),
              _buildField('ID Number', '1221239'),
              _buildField('Full Name', 'Rawan Waleed Yousef Yahya'),
              _buildField('Email', 'Input text'),
              _buildField('DOB', '2/3/2004', isDropdown: true),
              _buildField('Username', 'Input text'),

              _buildPasswordField('Password', '............'),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordScreen(),
                        ),
                      );
                    },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Change Password',
                    style: TextStyle(
                      color: AppColors.primaryWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Row(
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
                        'Back',
                        style: TextStyle(color: AppColors.primaryWhite),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                     onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => SuccessPopup(
                              title: "Successfully",
                              message:
                                  "Your profile has been updated successfully.",
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
                        'Save',
                        style: TextStyle(color: AppColors.primaryWhite),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    String value, {
    bool isReadOnly = false,
    bool isDropdown = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            readOnly: isReadOnly || isDropdown,
            controller: TextEditingController(text: value),
            decoration: InputDecoration(
              fillColor: AppColors.primaryWhite,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              suffixIcon: isDropdown
                  ? Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.primaryBlue,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            obscureText: _obscurePassword,
            controller: TextEditingController(text: value),
            decoration: InputDecoration(
              fillColor: AppColors.primaryWhite.withOpacity(0.7),
              filled: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                  size: 20,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
