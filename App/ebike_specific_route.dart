import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'RouteHistoryScreen.dart';

class EBikeSpecificRouteScreen extends StatefulWidget {
  const EBikeSpecificRouteScreen({super.key});

  @override
  State<EBikeSpecificRouteScreen> createState() =>
      _EBikeSpecificRouteScreenState();
}

class _EBikeSpecificRouteScreenState extends State<EBikeSpecificRouteScreen> {
  final MapController _mapController = MapController();

  LatLng? startLocation;
  LatLng? dropOffLocation;
  List<LatLng> routePoints = [];

  String? distanceText;
  String? durationText;

  bool isLoadingRoute = false;

  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  List<Map<String, dynamic>> _startSuggestions = [];
  List<Map<String, dynamic>> _endSuggestions = [];

  // 🌍 Fetch autocomplete suggestions
  Future<List<Map<String, dynamic>>> _fetchSuggestions(String query) async {
    if (query.isEmpty) return [];
    final url =
        "https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=5";
    final response = await http.get(Uri.parse(url), headers: {
      'User-Agent': 'flutter-ebike-app',
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    }
    return [];
  }

  // 🔍 When a suggestion is tapped
  void _onSuggestionTap(Map<String, dynamic> place, bool isStart) {
    final lat = double.parse(place['lat']);
    final lon = double.parse(place['lon']);
    final location = LatLng(lat, lon);
    setState(() {
      if (isStart) {
        startLocation = location;
        _startController.text = place['display_name'];
        _startSuggestions = [];
      } else {
        dropOffLocation = location;
        _endController.text = place['display_name'];
        _endSuggestions = [];
      }
    });
    if (startLocation != null && dropOffLocation != null) {
      _showEBikeRoute();
    }
  }

  // 🧭 Get current user location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enable location services')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    final pos = await Geolocator.getCurrentPosition();
    final loc = LatLng(pos.latitude, pos.longitude);

    setState(() {
      startLocation = loc;
      _startController.text = "📍 My Current Location";
      _startSuggestions = [];
    });

    _mapController.move(loc, 15);
  }

  // 📍 User taps destination
  void _onMapTap(LatLng pos) {
    if (startLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Set your starting location first!')),
      );
      return;
    }

    setState(() {
      dropOffLocation = pos;
    });
    _showEBikeRoute();
  }

  // 🚲 Fetch OSRM route
  Future<void> _showEBikeRoute() async {
    if (startLocation == null || dropOffLocation == null) return;

    setState(() {
      isLoadingRoute = true;
      routePoints.clear();
      distanceText = null;
      durationText = null;
    });

    try {
      final start = "${startLocation!.longitude},${startLocation!.latitude}";
      final end = "${dropOffLocation!.longitude},${dropOffLocation!.latitude}";
      final url = Uri.parse(
          "https://router.project-osrm.org/route/v1/bike/$start;$end?overview=full&geometries=geojson");

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["routes"] != null && data["routes"].isNotEmpty) {
          final route = data["routes"][0];
          final coords = route["geometry"]["coordinates"];
          final distance = route["distance"] / 1000; // meters → km
          final duration = route["duration"] / 60; // seconds → minutes

          setState(() {
            routePoints = coords
                .map<LatLng>((c) => LatLng(c[1].toDouble(), c[0].toDouble()))
                .toList();
            distanceText = "${distance.toStringAsFixed(2)} km";
            durationText = "${duration.toStringAsFixed(0)} min";
          });

          _mapController.fitCamera(CameraFit.bounds(
            bounds: LatLngBounds.fromPoints([startLocation!, dropOffLocation!]),
            padding: const EdgeInsets.all(50),
          ));

          await _saveRouteToHistory(distance, duration);
        } else {
          _handleRouteError();
        }
      } else {
        _handleRouteError();
      }
    } catch (e) {
      debugPrint("Route error: $e");
      _handleRouteError();
    } finally {
      setState(() => isLoadingRoute = false);
    }
  }

  void _handleRouteError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Failed to fetch route")),
    );
  }

  // 💾 Save route history
  Future<void> _saveRouteToHistory(double distance, double duration) async {
    try {
      String startName = await _reverseGeocode(startLocation!);
      String endName = await _reverseGeocode(dropOffLocation!);

      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString('route_history');
      List<Map<String, dynamic>> routes =
      stored != null ? List<Map<String, dynamic>>.from(json.decode(stored)) : [];

      routes.insert(0, {
        'startName': startName,
        'endName': endName,
        'distance': distance.toStringAsFixed(2),
        'duration': duration.toStringAsFixed(0),
        'timestamp': DateTime.now().toString(),
      });

      if (routes.length > 20) routes = routes.sublist(0, 20);
      await prefs.setString('route_history', json.encode(routes));
    } catch (e) {
      debugPrint("Save history error: $e");
    }
  }

  Future<String> _reverseGeocode(LatLng location) async {
    final url =
        "https://nominatim.openstreetmap.org/reverse?lat=${location.latitude}&lon=${location.longitude}&format=json";
    final response = await http.get(Uri.parse(url), headers: {
      'User-Agent': 'flutter-ebike-app',
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["display_name"] ?? "Unknown location";
    }
    return "Unknown location";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("E-Bike Route Finder"),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RouteHistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search + Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildSearchField(
                  controller: _startController,
                  hint: "Enter starting point or use current location",
                  onChanged: (v) async {
                    final results = await _fetchSuggestions(v);
                    setState(() => _startSuggestions = results);
                  },
                  suggestions: _startSuggestions,
                  isStart: true,
                ),
                _buildSearchField(
                  controller: _endController,
                  hint: "Enter destination or tap map",
                  onChanged: (v) async {
                    final results = await _fetchSuggestions(v);
                    setState(() => _endSuggestions = results);
                  },
                  suggestions: _endSuggestions,
                  isStart: false,
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _getCurrentLocation,
                  icon: const Icon(Icons.my_location),
                  label: const Text("Use My Current Location"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          if (isLoadingRoute) const LinearProgressIndicator(),

          if (distanceText != null && durationText != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "🚴 Distance: $distanceText | ⏱ Duration: $durationText",
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),

          // Map
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: const LatLng(14.5995, 120.9842),
                initialZoom: 13,
                onTap: (_, pos) => _onMapTap(pos),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                  "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: routePoints,
                      strokeWidth: 5.0,
                      color: Colors.deepPurple,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    if (startLocation != null)
                      Marker(
                        point: startLocation!,
                        width: 40,
                        height: 40,
                        child: const Icon(Icons.electric_bike,
                            color: Colors.green, size: 40),
                      ),
                    if (dropOffLocation != null)
                      Marker(
                        point: dropOffLocation!,
                        width: 40,
                        height: 40,
                        child:
                        const Icon(Icons.flag, color: Colors.red, size: 40),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Custom small dropdown UI
  Widget _buildSearchField({
    required TextEditingController controller,
    required String hint,
    required Function(String) onChanged,
    required List<Map<String, dynamic>> suggestions,
    required bool isStart,
  }) {
    return Stack(
      children: [
        Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                prefixIcon: Icon(
                    isStart ? Icons.electric_bike_outlined : Icons.flag),
                border: const OutlineInputBorder(),
              ),
              onChanged: onChanged,
            ),
            const SizedBox(height: 5),
          ],
        ),
        if (suggestions.isNotEmpty)
          Positioned(
            left: 0,
            right: 0,
            top: 55,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 150),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final s = suggestions[index];
                  return ListTile(
                    dense: true,
                    title: Text(
                      s['display_name'],
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    onTap: () => _onSuggestionTap(s, isStart),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
