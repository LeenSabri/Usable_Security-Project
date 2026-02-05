import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/app_bar.dart';

class FavoriteCarsScreen extends StatefulWidget {
  const FavoriteCarsScreen({super.key});

  @override
  State<FavoriteCarsScreen> createState() => _FavoriteCarsScreenState();
}

class _FavoriteCarsScreenState extends State<FavoriteCarsScreen> {
  // 1. قائمة البيانات الديناميكية للمفضلة
  final List<Map<String, String>> favoriteCars = [
    {
      'name': 'Hyundai Tucson',
      'type': 'SUV',
      'price': '65\$',
      'image': 'assets/tucson.png',
    },
    {
      'name': 'Toyota Yaris',
      'type': 'Sedan',
      'price': '45\$',
      'image': 'assets/yaris.png',
    },
    {
      'name': 'BMW 5 Series',
      'type': 'Luxury',
      'price': '120\$',
      'image': 'assets/tucson.png',
    },
    {
      'name': 'Tesla Model 3',
      'type': 'Electric',
      'price': '100\$',
      'image': 'assets/tucson.png',
    },
  ];

  final Map<String, List<String>> filterOptions = {
    'Type': ['SUV', 'Sedan', 'Hatchback', 'Luxury', 'Electric', 'Van', 'Truck'],
    'Color': [
      'White',
      'Black',
      'Silver',
      'Gray',
      'Blue',
      'Burgundy',
      'Green',
      'Red',
      'Brown',
      'Beige',
      'Orange',
      'Dark Blue',
      'Yellow',
      'Pearl White',
      'Champagne',
      'Lime Green',
      'Sky Blue',
      'Matte Black',
      'Matte Gray',
    ],
    'Size': ['2 Seats', '4 Seats', '5 Seats', '7 Seats'],
    'Fuel': ['Petrol', 'Diesel', 'Electric', 'Hybrid'],
    'Price': ['Low to High', 'High to Low', 'Under 50\$', 'Above 100\$'],
  };

  Map<String, String> selectedFilters = {
    'Type': 'Type',
    'Size': 'Size',
    'Fuel': 'Fuel',
    'Price': 'Price',
  };

  List<String> selectedColors = [];

  // دالة حذف السيارة من المفضلة وتحديث الواجهة
  void _removeFromFavorites(int index) {
    setState(() {
      favoriteCars.removeAt(index);
    });

    // إشعار بسيط أسفل الشاشة عند الحذف (اختياري)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Removed from favorites"),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      drawer: const CustomDrawer(),
      appBar: CustomAppBar(title: "Favorite Cars"),
      body: Column(
        children: [
          // قسم البحث والفلاتر
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search, size: 22),
                      suffixIcon: Icon(
                        Icons.manage_search,
                        color: Colors.blueGrey,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        _buildFilterDropdown('Type', true),
                        _buildFilterDropdown('Color', true),
                        _buildFilterDropdown('Size', true),
                        _buildFilterDropdown('Fuel', true),
                        _buildFilterDropdown('Price', false),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // قسم عرض السيارات (GridView)
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                color: Color(0xFFADD8E6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: favoriteCars.isEmpty
                  ? const Center(
                      child: Text(
                        "No favorite cars yet",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(15),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                          ),
                      itemCount: favoriteCars.length,
                      itemBuilder: (context, index) {
                        return _buildCarCard(context, index);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarCard(BuildContext context, int index) {
    final car = favoriteCars[index];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // أيقونة القلب قابلة للضغط للحذف
          Positioned(
            top: 5,
            left: 5,
            child: IconButton(
              onPressed: () => _removeFromFavorites(index),
              icon: const Icon(
                Icons.favorite,
                color: Color(0xFF0C417A),
                size: 24,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                const SizedBox(height: 35),
                Image.asset(
                  car['image']!,
                  height: 80,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.directions_car, size: 50),
                ),
                const SizedBox(height: 10),
                Text(
                  car['name']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF0C417A),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Type: ${car['type']}',
                    style: const TextStyle(fontSize: 10, color: Colors.black87),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Daily Price: ${car['price']}',
                    style: const TextStyle(fontSize: 10, color: Colors.black87),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFADD8E6),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'View Details',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF0C417A),
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
    );
  }

  // دالة بناء الـ Dropdown للفلاتر
  Widget _buildFilterDropdown(String key, bool showDivider) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: showDivider
              ? const Border(right: BorderSide(color: Colors.grey, width: 0.5))
              : null,
        ),
        child: PopupMenuButton<String>(
          offset: const Offset(0, 45),
          constraints: const BoxConstraints(maxHeight: 300, minWidth: 150),
          onSelected: (value) {
            if (key != 'Color') {
              setState(() {
                selectedFilters[key] = value;
              });
            }
          },
          itemBuilder: (BuildContext context) {
            return filterOptions[key]!.map((String option) {
              return PopupMenuItem<String>(
                value: option,
                enabled: key != 'Color',
                child: key == 'Color'
                    ? StatefulBuilder(
                        builder: (context, setPopupState) {
                          return InkWell(
                            onTap: () {
                              setPopupState(() {
                                if (selectedColors.contains(option)) {
                                  selectedColors.remove(option);
                                } else {
                                  selectedColors.add(option);
                                }
                              });
                              setState(() {});
                            },
                            child: Row(
                              children: [
                                Checkbox(
                                  value: selectedColors.contains(option),
                                  activeColor: AppColors.primaryBlue,
                                  onChanged: (bool? value) {
                                    setPopupState(() {
                                      if (value == true) {
                                        selectedColors.add(option);
                                      } else {
                                        selectedColors.remove(option);
                                      }
                                    });
                                    setState(() {});
                                  },
                                ),
                                Expanded(
                                  child: Text(
                                    option,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : Text(option, style: const TextStyle(fontSize: 13)),
              );
            }).toList();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    key == 'Color'
                        ? (selectedColors.isEmpty
                              ? 'Color'
                              : 'Col(${selectedColors.length})')
                        : selectedFilters[key]!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, size: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
