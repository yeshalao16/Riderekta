import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'ai_service.dart';

class RouteSafetyScreen extends StatefulWidget {
  const RouteSafetyScreen({super.key});

  @override
  State<RouteSafetyScreen> createState() => _RouteSafetyScreenState();
}

class _RouteSafetyScreenState extends State<RouteSafetyScreen> {
  final AIService aiService = AIService();
  List<String> suggestions = [];
  bool isLoading = true;

  // Chat-related variables
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  double? currentLat;
  double? currentLon;

  @override
  void initState() {
    super.initState();
    _loadSuggestions();
  }

  Future<void> _loadSuggestions() async {
    setState(() => isLoading = true);

    try {
      // ✅ Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          suggestions = ["Please enable location services on your device."];
          isLoading = false;
        });
        return;
      }

      // ✅ Check permission status
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            suggestions = ["Location permission denied. Please allow access."];
            isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          suggestions = [
            "Location permission permanently denied. Please enable it in Settings."
          ];
          isLoading = false;
        });
        return;
      }

      // ✅ Now safe to get location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentLat = position.latitude;
      currentLon = position.longitude;

      final tips = await aiService.getSafetySuggestions(
        currentLat!,
        currentLon!,
      );

      setState(() {
        suggestions = tips;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        suggestions = ["Error loading suggestions: $e"];
        isLoading = false;
      });
    }
  }


  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || currentLat == null || currentLon == null) return;

    setState(() {
      _messages.add({"role": "user", "content": text});
      _controller.clear();
    });

    // Auto scroll to bottom
    await Future.delayed(const Duration(milliseconds: 100));
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);

    try {
      final reply = await aiService.sendChatMessage(
        text,
        currentLat!,
        currentLon!,
      );

      setState(() {
        _messages.add({"role": "assistant", "content": reply});
      });

      // Scroll again after AI replies
      await Future.delayed(const Duration(milliseconds: 100));
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    } catch (e) {
      setState(() {
        _messages.add({"role": "assistant", "content": "Error: $e"});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Route Safety"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : (suggestions.isNotEmpty &&
          suggestions.first.contains("permission"))
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              suggestions.first,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadSuggestions,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Grant Location Access",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      )
          : Column(

      children: [
          // 🔹 Top half: Suggestions
          Expanded(
            flex: 1,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.directions_bike,
                        color: Colors.orange),
                    title: Text(suggestions[index]),
                  ),
                );
              },
            ),
          ),

          const Divider(height: 1),

          // 🔹 Bottom half: Chat area
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      return Align(
                        alignment: msg["role"] == "user"
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin:
                          const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(msg["content"] ?? ""),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: "Ask about route safety...",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.orange),
                        onPressed: _sendMessage,
                      ),
                    ],
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
