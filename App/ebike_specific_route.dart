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
  bool isLoadingRoute = false;

  // 🧭 Get user's current location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enable location services')),
      );
      return;
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    // Get position
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      startLocation = LatLng(position.latitude, position.longitude);
      markers.clear();
      markers.add(
        Marker(
          point: startLocation!,
          width: 50,
          height: 50,
          child: const Icon(Icons.pedal_bike, color: Colors.deepPurple, size: 35),
        ),
      );
    });

    _mapController.move(startLocation!, 15);
  }

  // 🗺️ Select drop-off location
  void _selectDropOff(LatLng pos) {
    if (startLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please set your starting location first!')),
      );
      return;
    }

    setState(() {
      dropOffLocation = pos;
      markers.removeWhere((m) => m.child is Icon && (m.child as Icon).icon == Icons.flag);
      markers.add(
        Marker(
          point: pos,
          width: 50,
          height: 50,
          child: const Icon(Icons.flag, color: Colors.red, size: 35),
        ),
      );
    });

    _showEBikeRoute();
  }

  Future<void> _showEBikeRoute() async {
    if (startLocation == null || dropOffLocation == null) return;

    setState(() {
      isLoadingRoute = true;
      routePoints.clear();
    });

    try {
      const apiKey =
          "eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6ImQ5Mzc3MjVkZjY3ZTRhNjI5MGEyZGEzOGQxZTA0Zjc5IiwiaCI6Im11cm11cjY0In0=";

      final url = Uri.parse(
          "https://api.openrouteservice.org/v2/directions/cycling-electric");

      final body = jsonEncode({
        "coordinates": [
          [startLocation!.longitude, startLocation!.latitude],
          [dropOffLocation!.longitude, dropOffLocation!.latitude],
        ]
      });

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': apiKey,
        },
        body: body,
      );

      debugPrint("ORS response code: ${response.statusCode}");
      debugPrint("ORS response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List coords = data["features"][0]["geometry"]["coordinates"];
        setState(() {
          routePoints = coords
              .map((c) => LatLng(c[1].toDouble(), c[0].toDouble()))
              .toList();
        });
        _mapController.fitCamera(CameraFit.bounds(
          bounds: LatLngBounds.fromPoints([startLocation!, dropOffLocation!]),
          padding: const EdgeInsets.all(50),
        ));
      } else {
        _handleRouteError();
      }
    } catch (e) {
      debugPrint("Exception while fetching route: $e");
      _handleRouteError();
    }

    setState(() {
      isLoadingRoute = false;
    });
  }



  void _handleRouteError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to fetch route. Try again!')),
    );
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
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: const LatLng(14.5995, 120.9842),
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
                        if (startLocation != null && dropOffLocation != null)
                          Polyline(
                            points: [startLocation!, dropOffLocation!],
                            strokeWidth: 4,
                            color: Colors.grey,
                          ),
                        if (routePoints.isNotEmpty)
                          Polyline(
                            points: routePoints,
                            strokeWidth: 8,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        if (routePoints.isNotEmpty)
                          Polyline(
                            points: routePoints,
                            strokeWidth: 6,
                            color: Colors.deepPurple,
                          ),
                      ],
                    ),

                    MarkerLayer(markers: markers),
                  ],
                ),
                if (isLoadingRoute)
                  const Center(
                    child: CircularProgressIndicator(color: Colors.deepPurple),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (startLocation == null)
                  const Text(
                    "Press 'Start' to use your current location, then tap the map for drop-off.",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                if (startLocation != null && dropOffLocation == null)
                  const Text(
                    "Tap the map to select drop-off (e-bike route will appear automatically!)",
                    style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                if (routePoints.isNotEmpty)
                  const Text(
                    "✅ Route ready! Follow the purple dashed line for e-bike safe path.",
                    style: TextStyle(fontSize: 14, color: Colors.deepPurple, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _getCurrentLocation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        icon: const Icon(Icons.location_on, color: Colors.white),
                        label: const Text("Start", style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed:
                        dropOffLocation == null ? null : () => _showEBikeRoute(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        label: const Text("Refresh Route",
                            style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
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
}
