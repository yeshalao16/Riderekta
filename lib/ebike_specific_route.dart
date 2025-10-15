import 'dart:async';
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
  String? userCountryCode;

  bool isLoadingRoute = false;

  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  List<Map<String, dynamic>> _startSuggestions = [];
  List<Map<String, dynamic>> _endSuggestions = [];

  String routeStatus = "Start Route";
  StreamSubscription<Position>? _positionSubscription;

  @override
  void initState() {
    super.initState();
    _getUserCountry();
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }

  Future<void> _getUserCountry() async {
    try {
      final pos = await Geolocator.getCurrentPosition();
      final url =
          "https://nominatim.openstreetmap.org/reverse?lat=${pos.latitude}&lon=${pos.longitude}&format=json";
      final response = await http.get(Uri.parse(url),
          headers: {'User-Agent': 'flutter-ebike-app'});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final countryCode = data["address"]?["country_code"];
        if (mounted) setState(() => userCountryCode = countryCode);
      }
    } catch (e) {
      debugPrint("Failed to get user country: $e");
    }
  }

  Future<List<Map<String, dynamic>>> _fetchSuggestions(String query) async {
    if (query.isEmpty) return [];
    final countryParam =
    userCountryCode != null ? "&countrycodes=$userCountryCode" : "";
    final url =
        "https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=5$countryParam";
    final response = await http.get(Uri.parse(url),
        headers: {'User-Agent': 'flutter-ebike-app'});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    }
    return [];
  }

  void _onStartSuggestionTap(Map<String, dynamic> place) {
    final lat = double.parse(place['lat']);
    final lon = double.parse(place['lon']);
    final location = LatLng(lat, lon);
    setState(() {
      startLocation = location;
      _startController.text = place['display_name'];
      _startSuggestions = [];
    });

    _mapController.move(location, 15);
    if (startLocation != null && dropOffLocation != null) _showEBikeRoute();
  }

  void _onEndSuggestionTap(Map<String, dynamic> place) {
    final lat = double.parse(place['lat']);
    final lon = double.parse(place['lon']);
    final location = LatLng(lat, lon);
    setState(() {
      dropOffLocation = location;
      _endController.text = place['display_name'];
      _endSuggestions = [];
    });

    _mapController.move(location, 15);
    if (startLocation != null && dropOffLocation != null) _showEBikeRoute();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enable location services')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
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

  Future<void> _showEBikeRoute() async {
    if (startLocation == null || dropOffLocation == null) return;

    setState(() {
      isLoadingRoute = true;
      routePoints.clear();
      distanceText = null;
      durationText = null;
      routeStatus = "Start Route";
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
          final distance = route["distance"] / 1000;
          final duration = route["duration"] / 60;

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
        'startLat': startLocation!.latitude,
        'startLon': startLocation!.longitude,
        'endLat': dropOffLocation!.latitude,
        'endLon': dropOffLocation!.longitude,
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
    final response = await http.get(Uri.parse(url),
        headers: {'User-Agent': 'flutter-ebike-app'});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["display_name"] ?? "Unknown location";
    }
    return "Unknown location";
  }

  void _resetRoute() {
    setState(() {
      startLocation = null;
      dropOffLocation = null;
      routePoints.clear();
      distanceText = null;
      durationText = null;
      routeStatus = "Start Route";
      _startController.clear();
      _endController.clear();
      _startSuggestions.clear();
      _endSuggestions.clear();
    });
    _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  Future<void> _startRouteTracking() async {
    if (routePoints.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a route first")),
      );
      return;
    }
    if (routeStatus == "Route in Progress") return;
    setState(() => routeStatus = "Route in Progress");

    _positionSubscription?.cancel();

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5,
      ),
    ).listen((pos) {
      if (mounted && dropOffLocation != null) {
        final distance = Geolocator.distanceBetween(
          pos.latitude,
          pos.longitude,
          dropOffLocation!.latitude,
          dropOffLocation!.longitude,
        );
        if (distance < 30) {
          setState(() => routeStatus = "Destination Arrived");
          _positionSubscription?.cancel();
          _positionSubscription = null;
        }
      }
    });
  }

  // 🆕 Load a route from history
  void _loadRouteFromHistory(Map<String, dynamic> route) {
    final start = LatLng(route['startLat'], route['startLon']);
    final end = LatLng(route['endLat'], route['endLon']);

    setState(() {
      startLocation = start;
      dropOffLocation = end;
      _startController.text = route['startName'];
      _endController.text = route['endName'];
    });

    _showEBikeRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("E-Bike Route Finder"),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: "View Route History",
            onPressed: () async {
              final selectedRoute = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RouteHistoryScreen()),
              );

              if (selectedRoute != null) {
                _loadRouteFromHistory(selectedRoute);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Reset Route",
            onPressed: _resetRoute,
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
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
                      color: Colors.deepOrange,
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
                        child: const Icon(Icons.flag,
                            color: Colors.red, size: 40),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            left: 8,
            right: 8,
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
                const SizedBox(height: 8),
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
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    elevation: 4,
                  ),
                ),
              ],
            ),
          ),
          if (distanceText != null && durationText != null)
            Positioned(
              bottom: 15,
              left: 15,
              right: 15,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 6,
                  children: [
                    const Icon(Icons.directions_bike, color: Colors.deepOrange),
                    Text(
                      "Distance: $distanceText",
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    const Icon(Icons.timer, color: Colors.deepOrange),
                    Text(
                      "Duration: $durationText",
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            bottom: 130,
            left: 15,
            right: 15,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _startRouteTracking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(routeStatus,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 80,
            right: 15,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.linear_scale, color: Colors.deepOrange, size: 20),
                  SizedBox(width: 6),
                  Text("E-Bike Route", style: TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField({
    required TextEditingController controller,
    required String hint,
    required Function(String) onChanged,
    required List<Map<String, dynamic>> suggestions,
    required bool isStart,
  }) {
    return Column(
      children: [
        Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(
                  isStart ? Icons.electric_bike_outlined : Icons.flag),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: onChanged,
          ),
        ),
        if (suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            constraints: const BoxConstraints(maxHeight: 180),
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
                  onTap: () => isStart
                      ? _onStartSuggestionTap(s)
                      : _onEndSuggestionTap(s),
                );
              },
            ),
          ),
      ],
    );
  }
}
