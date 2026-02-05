import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';
import '../constants/colors.dart';
import '../services/api_service.dart';
import 'car_details_screen.dart';
import '../widgets/app_bar.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  List<dynamic> cars = [];
  List<dynamic> filteredCars = [];
  bool isLoading = true;
  String searchQuery = '';
  
  String? selectedBrand;
  String? selectedColor;
  double? minPrice;
  double? maxPrice;

  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  Future<void> _loadCars() async {
    setState(() => isLoading = true);
    
    try {
      final result = await ApiService.getCars();
      
      if (result['success'] == true) {
        setState(() {
          cars = result['cars'] ?? [];
          filteredCars = cars;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Failed to load cars'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _filterCars() {
    setState(() {
      filteredCars = cars.where((car) {
        // Search filter
        if (searchQuery.isNotEmpty) {
          final searchLower = searchQuery.toLowerCase();
          final nameMatch = car['name'].toString().toLowerCase().contains(searchLower);
          final brandMatch = car['brand'].toString().toLowerCase().contains(searchLower);
          if (!nameMatch && !brandMatch) return false;
        }

        // Brand filter
        if (selectedBrand != null && selectedBrand!.isNotEmpty && selectedBrand != 'All') {
          if (car['brand'] != selectedBrand) return false;
        }

        // Color filter
        if (selectedColor != null && selectedColor!.isNotEmpty && selectedColor != 'All') {
          if (car['color'] != selectedColor) return false;
        }

        // Price filter
        final price = double.tryParse(car['price_per_day'].toString()) ?? 0;
        if (minPrice != null && price < minPrice!) return false;
        if (maxPrice != null && price > maxPrice!) return false;

        // Status filter - only show available cars
        if (car['status'] != 'available') return false;

        return true;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      drawer: const CustomDrawer(viewMode: 0),
      appBar: CustomAppBar(title: "RentGo - Home"),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                // Search bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      searchQuery = value;
                      _filterCars();
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search cars...',
                      prefixIcon: Icon(Icons.search, size: 22),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                
                // Filters
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: const Text('Brand', style: TextStyle(fontSize: 12)),
                          value: selectedBrand,
                          underline: Container(),
                          items: ['All', 'Toyota', 'BMW', 'Mercedes-Benz', 'Honda', 'Tesla', 'Nissan']
                              .map((brand) => DropdownMenuItem(
                                    value: brand,
                                    child: Text(brand, style: const TextStyle(fontSize: 11)),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() => selectedBrand = value);
                            _filterCars();
                          },
                        ),
                      ),
                      const VerticalDivider(),
                      Expanded(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: const Text('Color', style: TextStyle(fontSize: 12)),
                          value: selectedColor,
                          underline: Container(),
                          items: ['All', 'White', 'Black', 'Silver', 'Gray']
                              .map((color) => DropdownMenuItem(
                                    value: color,
                                    child: Text(color, style: const TextStyle(fontSize: 11)),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() => selectedColor = value);
                            _filterCars();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Cars Grid
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
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryBlue,
                      ),
                    )
                  : filteredCars.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.car_rental, size: 80, color: Colors.white54),
                              SizedBox(height: 16),
                              Text(
                                'No cars available',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadCars,
                          child: GridView.builder(
                            padding: const EdgeInsets.all(15),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.68,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                            ),
                            itemCount: filteredCars.length,
                            itemBuilder: (context, index) {
                              return _buildCarCard(filteredCars[index]);
                            },
                          ),
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
          // Favorite button
          Positioned(
            top: 10,
            left: 10,
            child: FavoriteButton(carId: car['id']),
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                const SizedBox(height: 30),
                
                // Car image
                car['image_url'] != null && car['image_url'].toString().isNotEmpty
                    ? Image.network(
                        car['image_url'],
                        height: 85,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.directions_car, size: 50, color: AppColors.primaryBlue),
                      )
                    : const Icon(Icons.directions_car, size: 50, color: AppColors.primaryBlue),
                
                const SizedBox(height: 10),
                
                // Car name
                Text(
                  car['name'] ?? 'Unknown Car',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF0C417A),
                  ),
                ),
                
                const SizedBox(height: 10),
                
                // Car details
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Brand: ${car['brand'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 10, color: Colors.black87),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Type: ${car['transmission'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 10, color: Colors.black87),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Price: \$${car['price_per_day'] ?? '0'}/day',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // View Details button
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CarDetailsScreen(car: car),
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
}

class FavoriteButton extends StatefulWidget {
  final int carId;
  
  const FavoriteButton({super.key, required this.carId});
  
  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false;
  bool isLoading = false;
  
  Future<void> _toggleFavorite() async {
    if (isLoading) return;
    
    setState(() => isLoading = true);
    
    try {
      final result = isFavorite
          ? await ApiService.removeFromFavorites(widget.carId)
          : await ApiService.addToFavorites(widget.carId);
      
      if (result['success'] == true) {
        setState(() {
          isFavorite = !isFavorite;
          isLoading = false;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isFavorite 
                  ? 'Added to favorites' 
                  : 'Removed from favorites'),
              duration: const Duration(seconds: 1),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFavorite,
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: const Color(0xFF0C417A),
              size: 24,
            ),
    );
  }
}

