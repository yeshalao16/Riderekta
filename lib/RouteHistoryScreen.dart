import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'api_endpoints.dart';

class RouteHistoryScreen extends StatefulWidget {
  final String email; // User email passed from dashboard
  const RouteHistoryScreen({Key? key, required this.email}) : super(key: key);

  @override
  _RouteHistoryScreenState createState() => _RouteHistoryScreenState();
}

class _RouteHistoryScreenState extends State<RouteHistoryScreen> {
  List<Map<String, dynamic>> _routeHistory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRouteHistory();
  }

  Future<void> _fetchRouteHistory() async {
    try {
      final url = Uri.parse(ApiEndpoints.getRoute);
      final response = await http.post(url, body: {'email': widget.email});
      debugPrint("Route history response: ${response.body}"); // ✅ Debug

      final data = jsonDecode(response.body);

      if (data['success'] == true && data['routes'] != null) {
        List routes = data['routes'];
        List<Map<String, dynamic>> parsedRoutes = [];

        for (var r in routes) {
          parsedRoutes.add({
            'id': r['id'],
            'startName': r['startName'] ?? '',
            'endName': r['endName'] ?? '',
            'distance': r['distance']?.toString() ?? '0',
            'duration': r['duration']?.toString() ?? '0',
            'timestamp': r['timestamp'] ?? '',
            'startLat': double.tryParse(r['startLat'].toString()) ?? 0,
            'startLon': double.tryParse(r['startLon'].toString()) ?? 0,
            'endLat': double.tryParse(r['endLat'].toString()) ?? 0,
            'endLon': double.tryParse(r['endLon'].toString()) ?? 0,
          });
        }

        setState(() {
          _routeHistory = parsedRoutes;
          isLoading = false;
        });

        debugPrint("Parsed ${_routeHistory.length} routes"); // ✅ Debug
      } else {
        setState(() {
          _routeHistory = [];
          isLoading = false;
        });
        debugPrint("Failed to fetch routes: ${data['message']}");
      }
    } catch (e) {
      setState(() {
        _routeHistory = [];
        isLoading = false;
      });
      debugPrint("Error fetching routes: $e");
    }
  }


  Future<void> _clearHistory() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("Clearing history from server is not implemented yet.")),
    );
  }

  String _formatTimestamp(String timestamp) {
    try {
      final dt = DateTime.parse(timestamp);
      return DateFormat('MMM dd, yyyy – hh:mm a').format(dt);
    } catch (e) {
      return timestamp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Route History"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: _routeHistory.isNotEmpty ? _clearHistory : null,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _routeHistory.isEmpty
          ? const Center(
          child: Text(
            "No routes yet.",
            style: TextStyle(fontSize: 16),
          ))
          : ListView.builder(
        itemCount: _routeHistory.length,
        itemBuilder: (context, index) {
          final route = _routeHistory[index];

          final distance = route['distance'] ?? '0';
          final duration = route['duration'] ?? '0';
          final timestamp = _formatTimestamp(route['timestamp'] ?? '');

          return Card(
            margin: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6),
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.route, color: Colors.blue),
              title: Text(
                "${route['startName']} → ${route['endName']}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Distance: $distance km\nDuration: $duration mins\nDate: $timestamp",
              ),
              onTap: () {
                // Pass all info back to EBike screen
                Navigator.pop(context, {
                  'startName': route['startName'],
                  'endName': route['endName'],
                  'startLat': route['startLat'],
                  'startLon': route['startLon'],
                  'endLat': route['endLat'],
                  'endLon': route['endLon'],
                });
              },
            ),
          );
        },
      ),
    );
  }
}
