import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../constants/colors.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/app_bar.dart';
import '../widgets/success_popup.dart';
import 'location_picker.dart';

class AddRequestScreen extends StatefulWidget {
  final Map<String, dynamic> car;

  const AddRequestScreen({super.key, required this.car});

  @override
  State<AddRequestScreen> createState() => _AddRequestScreenState();
}

class _AddRequestScreenState extends State<AddRequestScreen> {
  String selectedColor = 'Gray';

  File? _idCardImage;
  File? _licenseImage;

  String selectedLocationText = "Select Location";
  double? selectedLat;
  double? selectedLon;

  Future<void> _pickImage(bool isIdCard) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        if (isIdCard) {
          _idCardImage = File(image.path);
        } else {
          _licenseImage = File(image.path);
        }
      });
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
      drawer: const CustomDrawer(viewMode: 0),
      appBar: CustomAppBar(title: "Add Request"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFADD8E6),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Icon(
                        Icons.favorite,
                        color: Color(0xFF0C417A),
                        size: 30,
                      ),
                    ),
                    Image.asset(
                      widget.car['image'] ?? 'assets/tucson.png',
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.car['name'] ?? 'Hyundai Tucson',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0C417A),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(Icons.calendar_month, "Rental Dates:"),
                    _buildDatePicker("Start Date:"),
                    _buildDatePicker("End Date:"),
                    const SizedBox(height: 15),

                    _buildSectionTitle(Icons.color_lens, "Color:"),
                    Row(
                      children: [
                        _buildRadioOption("White"),
                        _buildRadioOption("Gray"),
                      ],
                    ),
                    const SizedBox(height: 15),

                    _buildSectionTitle(Icons.location_on, "Location:"),
                    _buildLocationSelector(),
                    const SizedBox(height: 15),

                    _buildSectionTitle(Icons.phone, "Phone Number:"),
                    _buildTextField("0591234567"),
                    const SizedBox(height: 15),

                    _buildSectionTitle(
                      Icons.person,
                      "Image Of Personal ID Card:",
                    ),
                    _buildUploadBox(
                      imageFile: _idCardImage,
                      onTap: () => _pickImage(true),
                    ),
                    const SizedBox(height: 15),

                    _buildSectionTitle(
                      Icons.directions_car,
                      "Image Of Driving License Card:",
                    ),
                    _buildUploadBox(
                      imageFile: _licenseImage,
                      onTap: () => _pickImage(false),
                    ),
                    const SizedBox(height: 20),

                    const Divider(),
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            "TOTAL PRICE",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0C417A),
                            ),
                          ),
                          Text(
                            "${widget.car['price'] ?? '65'}\$",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => SuccessPopup(
                          title: "Request Added!",
                          message:
                              "Your request for ${widget.car['name']} has been submitted successfully.",
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0C417A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Add Request",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF0C417A)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildDatePicker(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Date",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                Icon(Icons.calendar_today, color: Colors.grey, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSelector() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 28),
      child: GestureDetector(
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
                  style: TextStyle(
                    color: selectedLat == null ? Colors.grey : Colors.black,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.map, color: Color(0xFF0C417A), size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadBox({File? imageFile, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 28),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.blue.shade100),
            image: imageFile != null
                ? DecorationImage(
                    image: FileImage(imageFile),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: imageFile == null
              ? const Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 40,
                  color: Color(0xFF0C417A),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 28),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }

  Widget _buildRadioOption(String value) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: selectedColor,
          onChanged: (val) => setState(() => selectedColor = val.toString()),
          activeColor: const Color(0xFF0C417A),
        ),
        Text(value, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
