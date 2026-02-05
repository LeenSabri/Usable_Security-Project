import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';
import '../constants/strings.dart';
import '../constants/colors.dart';
import '../widgets/app_bar.dart';
import '../widgets/success_popup.dart';

class CreateEmployeeScreen extends StatefulWidget {
  const CreateEmployeeScreen({super.key});

  @override
  State<CreateEmployeeScreen> createState() => _CreateEmployeeScreenState();
}

class _CreateEmployeeScreenState extends State<CreateEmployeeScreen> {
  String _selectedRole = 'Delivery';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      drawer: const CustomDrawer(),
      appBar: CustomAppBar(title: "Create Employee Account"),
      body: Container(
        margin: const EdgeInsets.fromLTRB(15, 10, 15, 15),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.secondaryBlue,
          borderRadius: BorderRadius.circular(25),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Role"),
              _buildRoleOption("Delivery"),
              _buildRoleOption("Customer Service"),
              _buildRoleOption("Online Booking Officer"),

              const SizedBox(height: 15),
              _buildInputField("ID Number", "Input text"),

              const SizedBox(height: 15),
              _buildInputField("Full Name", "Input text"),

              const SizedBox(height: 15),
              _buildInputField("Email", "Input text"),

              const SizedBox(height: 15),
              _buildSectionTitle("DOB"),
              _buildDatePickerField(),

              const SizedBox(height: 15),
              _buildInputField("Username", "Input text"),

              const SizedBox(height: 15),
              _buildInputField("Password", "••••••••••••", isPassword: true),

              const SizedBox(height: 30),
              _buildCreateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.primaryBlue,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRoleOption(String role) {
    return Theme(
      data: Theme.of(
        context,
      ).copyWith(unselectedWidgetColor: AppColors.primaryBlue),
      child: RadioListTile<String>(
        title: Text(role, style: const TextStyle(color: AppColors.primaryBlue)),
        value: role,
        groupValue: _selectedRole,
        activeColor: AppColors.primaryBlue,
        contentPadding: EdgeInsets.zero,
        dense: true,
        onChanged: (value) {
          setState(() {
            _selectedRole = value!;
          });
        },
      ),
    );
  }

  Widget _buildInputField(
    String label,
    String hint, {
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(label),
        TextField(
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            suffixIcon: isPassword
                ? const Icon(Icons.visibility_off_outlined, color: Colors.grey)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(border: InputBorder.none),
        hint: const Text("Date"),
        items: const [],
        onChanged: (value) {},
      ),
    );
  }

  Widget _buildCreateButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => SuccessPopup(
              title: "Successful!",
              message: "The employee was successfully added.",
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          "Create",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
