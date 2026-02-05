import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../constants/colors.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/app_bar.dart';
import '../widgets/success_popup.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({super.key});

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  List<String> selectedColors = [];
  File? _carImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _carImage = File(image.path);
      });
    }
  }

  final List<String> allColors = [
    "White",
    "Red",
    "Champagne",
    "Black",
    "Brown",
    "Lime Green",
    "Silver",
    "Beige",
    "Sky Blue",
    "Gray",
    "Orange",
    "Matte Black",
    "Blue",
    "Dark Blue",
    "Matte Gray",
    "Burgundy",
    "Yellow",
    "Metallic Gray",
    "Green",
    "Pearl White",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      drawer: const CustomDrawer(viewMode: 3),
      appBar: CustomAppBar(title: "Add Car"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFADD8E6),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputLabel("Name:"),
              _buildTextField("Input text"),

              _buildInputLabel("Type:"),
              _buildDropdownField("Type", [
                "Sedan",
                "SUV",
                "Luxury",
                "Hatchback",
              ]),

              _buildInputLabel("Fuel:"),
              _buildTextField("Input text"),

              _buildColorsSelectionField(),

              _buildInputLabel("Daily Price:"),
              _buildTextField("Input text"),

              _buildInputLabel("Description:"),
              _buildTextField("Input text", maxLines: 4),

              _buildInputLabel("Image:"),
              _buildImageUploadBox(),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => SuccessPopup(
                        title: "Successful!",
                        message: "The car  has been added successfully.",
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
                    "Add",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
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

  Widget _buildImageUploadBox() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 135, 174, 213),
          borderRadius: BorderRadius.circular(15),
          image: _carImage != null
              ? DecorationImage(image: FileImage(_carImage!), fit: BoxFit.cover)
              : null,
        ),
        child: _carImage == null
            ? const Icon(
                Icons.add_photo_alternate_outlined,
                size: 50,
                color: Color(0xFF0C417A),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildColorsSelectionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputLabel("Colors:"),
        InkWell(
          onTap: () => _showColorsDialog(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    selectedColors.isEmpty
                        ? "Select Colors"
                        : selectedColors.join(", "),
                    style: TextStyle(
                      color: selectedColors.isEmpty
                          ? Colors.grey
                          : Colors.black,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showColorsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: const Text(
                "Select Colors",
                style: TextStyle(
                  color: Color(0xFF0C417A),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Wrap(
                    children: allColors.map((color) {
                      bool isChecked = selectedColors.contains(color);
                      return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.28,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: isChecked,
                              activeColor: const Color(0xFF0C417A),
                              onChanged: (val) {
                                setDialogState(() {
                                  if (val == true) {
                                    selectedColors.add(color);
                                  } else {
                                    selectedColors.remove(color);
                                  }
                                });
                                setState(() {});
                              },
                            ),
                            Expanded(
                              child: Text(
                                color,
                                style: const TextStyle(fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "DONE",
                    style: TextStyle(
                      color: Color(0xFF0C417A),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 10),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0C417A),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 12,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDropdownField(String hint, List<String> items) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            hint,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          items: items.map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (_) {},
        ),
      ),
    );
  }
}
