import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

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
  final List<Marker> markers = [];

  /// Get current GPS location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enable location services")),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission denied")),
      );
      return;
    }

    Position position =
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      startLocation = LatLng(position.latitude, position.longitude);
      markers.add(
        Marker(
          point: startLocation!,
          width: 60,
          height: 60,
          child: const Icon(Icons.location_pin, color: Colors.blue, size: 40),
        ),
      );
    });

    _mapController.move(startLocation!, 14);
  }

  /// Tap to select drop-off
  void _selectDropOff(LatLng position) {
    setState(() {
      dropOffLocation = position;
      markers.add(
        Marker(
          point: dropOffLocation!,
          width: 60,
          height: 60,
          child: const Icon(Icons.flag, color: Colors.red, size: 40),
        ),
      );
    });
    _showRoute();
  }

  /// Use OpenRouteService (free, open-source) for biking route
  Future<void> _showRoute() async {
    if (startLocation == null || dropOffLocation == null) return;

    const apiKey = 'YOUR_OPENROUTESERVICE_API_KEY'; // optional free key
    final url =
        'https://api.openrouteservice.org/v2/directions/cycling-regular?api_key=$apiKey&start=${startLocation!.longitude},${startLocation!.latitude}&end=${dropOffLocation!.longitude},${dropOffLocation!.latitude}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final coords = data['features'][0]['geometry']['coordinates'];
        setState(() {
          routePoints = coords
              .map<LatLng>((c) => LatLng(c[1].toDouble(), c[0].toDouble()))
              .toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unable to fetch route")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching route: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "E-BIKE SPECIFIC ROUTE",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(14.5995, 120.9842), // Manila default
                initialZoom: 13,
                onTap: (_, pos) => _selectDropOff(pos),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.ebikeapp',
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: routePoints,
                      strokeWidth: 5,
                      color: Colors.deepPurple,
                    ),
                  ],
                ),
                MarkerLayer(markers: markers),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _getCurrentLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text("Start",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: dropOffLocation == null
                        ? () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Tap on map to select drop-off")))
                        : _showRoute,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text("Drop-off",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
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
