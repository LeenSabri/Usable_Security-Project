import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../widgets/custom_drawer.dart';
import '../constants/strings.dart';
import '../constants/colors.dart';
import 'location_picker.dart';
import '../widgets/app_bar.dart';
import '../widgets/success_popup.dart';

class CarBookingScreen extends StatefulWidget {
  final Map<String, dynamic> car;
  const CarBookingScreen({super.key, required this.car});

  @override
  State<CarBookingScreen> createState() => _CarBookingScreenState();
}

class _CarBookingScreenState extends State<CarBookingScreen> {
  String selectedColor = 'Gray';
  String selectedPaymentType = 'Visa';

  File? _idCardImage;
  File? _licenseImage;

  String selectedLocationText = AppStrings.selectLocationPlaceholder;
  double? selectedLat;
  double? selectedLon;

  Future<void> _pickImage(bool isIdCard) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
      );
      if (image != null) {
        setState(() {
          if (isIdCard) {
            _idCardImage = File(image.path);
          } else {
            _licenseImage = File(image.path);
          }
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  void _openMapPicker() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LocationPickerScreen()),
    );
    if (result != null) {
      setState(() {
        selectedLat = result["lat"];
        selectedLon = result["lon"];
        selectedLocationText = result["address"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      drawer: const CustomDrawer(),
      appBar: CustomAppBar(title: AppStrings.carBookingLbl),
      body: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        decoration: BoxDecoration(
          color: AppColors.secondaryBlue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Image.asset(
                widget.car['image'],
                height: 110,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.directions_car,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              Text(
                widget.car['name'],
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.primaryWhite,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(
                      Icons.calendar_month,
                      AppStrings.rentalDatesLbl,
                    ),
                    _buildDropdownField(AppStrings.startDateLbl),
                    _buildDropdownField(AppStrings.endDateLbl),

                    _buildSectionTitle(Icons.color_lens, AppStrings.colorLbl),
                    Row(
                      children: [
                        _buildRadioOption("White"),
                        _buildRadioOption("Gray"),
                      ],
                    ),

                    _buildSectionTitle(
                      Icons.location_on,
                      AppStrings.locationLbl,
                    ),
                    _buildLocationSelector(),

                    _buildSectionTitle(Icons.phone, AppStrings.phoneLbl),
                    _buildPaymentTextField("059xxxxxxx"),

                    _buildSectionTitle(
                      Icons.person,
                      "Image Of Personal ID Card:",
                    ),
                    _buildImageUploadBox(
                      imageFile: _idCardImage,
                      onTap: () => _pickImage(true),
                    ),

                    _buildSectionTitle(
                      Icons.directions_car,
                      "Image Of Driving License Card:",
                    ),
                    _buildImageUploadBox(
                      imageFile: _licenseImage,
                      onTap: () => _pickImage(false),
                    ),

                    const Divider(height: 30, thickness: 1),

                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "TOTAL PRICE",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          Text(
                            "${widget.car['price'] ?? '65'} \$",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                    const Text(
                      "Payment Method",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildPaymentImageButton(
                          "Visa",
                          'assets/image/visa.jpg',
                        ),
                        const SizedBox(width: 40),
                        _buildPaymentImageButton(
                          "Credit",
                          'assets/image/creditCard.jpg',
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    _paymentLabel("Name on card"),
                    _buildPaymentTextField(""),

                    _paymentLabel("Card number"),
                    _buildPaymentTextField(""),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _paymentLabel("Expiry date"),
                              _buildPaymentTextField("MM / YY"),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _paymentLabel("Security code"),
                              _buildPaymentTextField("", hasInfoIcon: true),
                            ],
                          ),
                        ),
                      ],
                    ),

                    _paymentLabel("ZIP/Postal code"),
                    _buildPaymentTextField("", hasInfoIcon: true),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => SuccessPopup(
                              title: "Booking Successful!",
                              message:
                                  "Your booking for ${widget.car['name']} has been confirmed successfully.",
                            ),
                          );
                        },
                        child: const Text(
                          'Confirm Booking Request',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
    );
  }

  Widget _buildImageUploadBox({File? imageFile, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFE3F2FD),
          borderRadius: BorderRadius.circular(15),
          image: imageFile != null
              ? DecorationImage(image: FileImage(imageFile), fit: BoxFit.cover)
              : null,
        ),
        child: imageFile == null
            ? const Icon(
                Icons.add_photo_alternate_outlined,
                size: 40,
                color: AppColors.primaryBlue,
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildPaymentImageButton(String type, String imagePath) {
    bool isSelected = selectedPaymentType == type;
    return GestureDetector(
      onTap: () => setState(() => selectedPaymentType = type),
      child: Column(
        children: [
          Container(
            height: 35,
            width: 55,
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue.shade50 : Colors.white,
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryBlue
                    : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (c, e, s) => Icon(
                  Icons.credit_card,
                  color: isSelected ? AppColors.primaryBlue : Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            type,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppColors.primaryBlue : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 12),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildPaymentTextField(String hint, {bool hasInfoIcon = false}) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          border: InputBorder.none,
          suffixIcon: hasInfoIcon
              ? Icon(Icons.help_outline, color: Colors.grey.shade400, size: 18)
              : null,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primaryBlue),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSelector() {
    return GestureDetector(
      onTap: _openMapPicker,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                selectedLocationText,
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.map, color: AppColors.primaryBlue, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(String hint) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(hint, style: const TextStyle(fontSize: 12)),
          items: const [],
          onChanged: (val) {},
        ),
      ),
    );
  }

  Widget _buildRadioOption(String value) {
    return Row(
      children: [
        Radio(
          activeColor: AppColors.primaryBlue,
          value: value,
          groupValue: selectedColor,
          onChanged: (val) => setState(() => selectedColor = val!),
        ),
        Text(value, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
