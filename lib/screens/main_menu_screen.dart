import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';
import '../constants/colors.dart';
import 'car_details_screen.dart';
import '../widgets/app_bar.dart';
import '../services/api_service.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int favoriteFlag = 0;
  bool isLoading = true;
  List<Map<String, dynamic>> cars = [];
  
  final Map<String, List<String>> filterOptions = {
    'Type': [
      'SUV',
      'Sedan',
      'Hatchback',
      'Luxury',
      'Electric',
      'Van',
      'Truck',
      'Sport',
    ],
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
      'Metallic Gray',
    ],
    'Size': ['2 Seats', '4 Seats', '5 Seats', '7 Seats', '8 Seats', '9 Seats'],
    'Fuel': ['Petrol', 'Diesel', 'Electric', 'Hybrid', 'Gas'],
    'Price': [
      'Low to High',
      'High to Low',
      'Under 50\$',
      '50\$ - 100\$',
      'Above 100\$',
    ],
  };

  Map<String, String> selectedFilters = {
    'Type': 'Type',
    'Size': 'Size',
    'Fuel': 'Fuel',
    'Price': 'Price',
  };

  List<String> selectedColors = [];

  @override
  void initState() {
    super.initState();
    _loadCarsFromAPI();
  }

  Future<void> _loadCarsFromAPI() async {
    try {
      final result = await ApiService.getCars();
      if (result['success'] == true && result['cars'] != null) {
        setState(() {
          // تحويل البيانات من API للفورمات المطلوب
          cars = (result['cars'] as List).map((car) {
            return {
              'name': car['name'] ?? 'Unknown',
              'type': car['brand'] ?? 'Car',
              'price': '\$${car['price_per_day']?.toString() ?? '0'}',
              'image': car['image_url'] ?? '',
              'id': car['id'],
              'brand': car['brand'],
              'model': car['model'],
              'year': car['year'],
              'color': car['color'],
              'seats': car['seats'],
              'transmission': car['transmission'],
              'fuel_type': car['fuel_type'],
              'description': car['description'],
              'status': car['status'],
            };
          }).toList();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error loading cars: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      drawer: const CustomDrawer(viewMode: 0),
      appBar: CustomAppBar(title: "Home"),
      body: Column(
        children: [
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
              child: isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                  : cars.isEmpty
                      ? const Center(
                          child: Text(
                            'No cars available',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(15),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.68,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                          ),
                          itemCount: cars.length,
                          itemBuilder: (context, index) {
                            return _buildCarCard(cars[index]);
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarCard(Map<String, dynamic> car) {
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
          if (favoriteFlag != 1)
            const Positioned(top: 10, left: 10, child: FavoriteButton()),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                const SizedBox(height: 30),
                // أيقونة السيارة
                const Icon(
                  Icons.directions_car,
                  size: 85,
                  color: Color(0xFF0C417A),
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CarDetailsScreen(
                            car: car,
                          ),
                        ),
                      );
                    },
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
              setState(() => selectedFilters[key] = value);
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
                                selectedColors.contains(option)
                                    ? selectedColors.remove(option)
                                    : selectedColors.add(option);
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
                                      value == true
                                          ? selectedColors.add(option)
                                          : selectedColors.remove(option);
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

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key});
  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => isFavorite = !isFavorite),
      child: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: const Color(0xFF0C417A),
        size: 24,
      ),
    );
  }
}
