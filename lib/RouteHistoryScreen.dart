import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RouteHistoryScreen extends StatefulWidget {
  const RouteHistoryScreen({Key? key}) : super(key: key);

  @override
  _RouteHistoryScreenState createState() => _RouteHistoryScreenState();
}

class _RouteHistoryScreenState extends State<RouteHistoryScreen> {
  List<Map<String, dynamic>> _routeHistory = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? stored = prefs.getString('route_history');
    if (stored != null) {
      setState(() {
        _routeHistory = List<Map<String, dynamic>>.from(json.decode(stored));
      });
    }
  }

  Future<void> _clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('route_history');
    setState(() {
      _routeHistory.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Route History"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: _routeHistory.isNotEmpty
                ? () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Clear History?"),
                  content: const Text(
                      "This will remove all your saved route history."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _clearHistory();
                      },
                      child: const Text("Clear"),
                    ),
                  ],
                ),
              );
            }
                : null,
          )
        ],
      ),
      body: _routeHistory.isEmpty
          ? const Center(
        child: Text(
          "No routes yet.",
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: _routeHistory.length,
        itemBuilder: (context, index) {
          final route = _routeHistory[index];
          return Card(
            margin:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                "Distance: ${route['distance']} km\n"
                    "Duration: ${route['duration']} mins\n"
                    "Date: ${route['timestamp']}",
              ),
              onTap: () {
                Navigator.pop(context, route);
              },
            ),
          );
        },
      ),
    );
  }
}
