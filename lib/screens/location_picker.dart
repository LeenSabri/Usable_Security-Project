import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart' as geo;

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  /// Default Location = Ramallah
  LatLng currentPoint = LatLng(31.95, 35.91);

  String address = "Move the marker to pick location";

  TextEditingController searchCtrl = TextEditingController();
  bool isSearching = false;

  final MapController _mapController = MapController();

  Future<void> getAddress() async {
    try {
      final placemarks = await geo.placemarkFromCoordinates(
        currentPoint.latitude,
        currentPoint.longitude,
      );

      final p = placemarks.first;

      setState(() {
        address = "${p.street ?? ""}, ${p.locality ?? ""}, ${p.country ?? ""}";
      });
    } catch (e) {
      setState(() => address = "Unknown location");
    }
  }

  Future<void> searchLocation(String query) async {
    if (query.isEmpty) return;

    try {
      setState(() => isSearching = true);

      final results = await geo.locationFromAddress(query);
      final res = results.first;

      /// النقطة الجديدة
      final newPoint = LatLng(res.latitude, res.longitude);

      setState(() {
        currentPoint = newPoint;
      });

      _mapController.move(newPoint, 15);

      await getAddress();
    } catch (_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Location not found")));
    } finally {
      setState(() => isSearching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pick Location")),

      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,

            options: MapOptions(
              initialCenter: currentPoint,
              initialZoom: 14,

              onTap: (tapPos, latlng) async {
                setState(() => currentPoint = latlng);
                await getAddress();
              },
            ),

            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              ),

              MarkerLayer(
                markers: [
                  Marker(
                    point: currentPoint,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),

          Positioned(
            top: 15,
            left: 15,
            right: 15,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    color: Colors.black.withOpacity(0.2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchCtrl,
                      decoration: const InputDecoration(
                        hintText: "Search location…",
                        border: InputBorder.none,
                      ),
                      onSubmitted: searchLocation,
                    ),
                  ),

                  isSearching
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () => searchLocation(searchCtrl.text),
                        ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 90,
            left: 15,
            right: 15,
            child: Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              child: Text(address),
            ),
          ),

          Positioned(
            bottom: 20,
            left: 15,
            right: 15,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  "lat": currentPoint.latitude,
                  "lon": currentPoint.longitude,
                  "address": address,
                });
              },
              child: const Text("Confirm Location"),
            ),
          ),
        ],
      ),
    );
  }
}
