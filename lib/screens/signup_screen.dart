import 'package:flutter/material.dart';
import 'main_menu_screen.dart';
import '../constants/strings.dart';
import '../constants/colors.dart';
import '../services/api_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool obscurePass = true;
  bool obscureConfirm = true;
  bool isLoading = false;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> handleSignup() async {
    // Validation
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        fullNameController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final result = await ApiService.signup(
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        fullName: fullNameController.text.trim(),
        phone: phoneController.text.trim().isNotEmpty 
            ? phoneController.text.trim() 
            : null,
      );

      setState(() => isLoading = false);

      if (result['success'] == true) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully! Please login.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Signup failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Image.asset(
                'assets/image/logo.png',
                width: 150,
                height: 150,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.person_add,
                  size: 100,
                  color: AppColors.primaryWhite,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: 320,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: AppColors.secondaryBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Full Name *'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      'Enter your full name',
                      false,
                      null,
                      fullNameController,
                    ),
                    const SizedBox(height: 15),
                    _buildLabel(AppStrings.usernameLbl),
                    const SizedBox(height: 8),
                    _buildTextField(
                      AppStrings.usernamePlaceholder,
                      false,
                      null,
                      usernameController,
                    ),
                    const SizedBox(height: 15),
                    _buildLabel('Email *'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      'Enter your email',
                      false,
                      null,
                      emailController,
                    ),
                    const SizedBox(height: 15),
                    _buildLabel('Phone (Optional)'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      '059xxxxxxx',
                      false,
                      null,
                      phoneController,
                    ),
                    const SizedBox(height: 15),
                    _buildLabel(AppStrings.passwardLbl),
                    const SizedBox(height: 8),
                    _buildTextField(
                      '',
                      obscurePass,
                      () => setState(() => obscurePass = !obscurePass),
                      passwordController,
                    ),
                    const SizedBox(height: 15),
                    _buildLabel(AppStrings.confirmPassLbl),
                    const SizedBox(height: 8),
                    _buildTextField(
                      '',
                      obscureConfirm,
                      () => setState(() => obscureConfirm = !obscureConfirm),
                      confirmPasswordController,
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: isLoading ? null : handleSignup,
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primaryWhite,
                                  ),
                                ),
                              )
                            : const Text(
                                AppStrings.signupBtn,
                                style: TextStyle(
                                  color: AppColors.primaryWhite,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildSignInLink(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontWeight: FontWeight.bold,
      color: AppColors.primaryBlue,
      fontSize: 16,
    ),
  );

  Widget _buildTextField(
    String hint, 
    bool obscure, 
    VoidCallback? onToggle,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      enabled: !isLoading,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.primaryWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        suffixIcon: onToggle != null
            ? IconButton(
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: onToggle,
              )
            : null,
      ),
    );
  }

  Widget _buildSignInLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          AppStrings.haveAccountLbl,
          style: TextStyle(color: AppColors.primaryWhite, fontSize: 16),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Text(
            AppStrings.signinBtn,
            style: TextStyle(
              color: AppColors.secondaryBlue,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.secondaryBlue,
              decorationThickness: 2,
            ),
          ),
        ),
      ],
    );
  }
}
