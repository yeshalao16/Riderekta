import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_endpoints.dart';

class AIService {
  /// ✅ Get safety suggestions from the AI
  Future<List<String>> getSafetySuggestions(double lat, double lon) async {
    final url = Uri.parse(ApiEndpoints.aiSafety);
    print("🔹 Sending request to: $url");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "lat": lat,
          "lon": lon,
          "type": "suggestions",
        }),
      );

      print("🔹 Response (${response.statusCode}): ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // ✅ Check if there's an error from PHP
        if (data["error"] != null) {
          throw Exception(data["error"]);
        }

        final content = data["choices"]?[0]?["message"]?["content"];
        if (content is! String) {
          throw Exception("Unexpected response format");
        }

        // ✅ Split by lines into suggestion list
        return content
            .split('\n')
            .map((line) => line.trim())
            .where((line) => line.isNotEmpty)
            .toList();
      } else {
        throw Exception("HTTP ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      print("❌ AIService.getSafetySuggestions Error: $e");
      rethrow; // so the Flutter UI can show "Error loading suggestions"
    }
  }

  /// ✅ Send a chat message to the AI
  Future<String> sendChatMessage(String userMessage, double lat, double lon) async {
    final url = Uri.parse(ApiEndpoints.aiSafety);
    print("🔹 Chat request to: $url");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "lat": lat,
          "lon": lon,
          "message": userMessage,
          "type": "chat",
        }),
      );

      print("🔹 Response (${response.statusCode}): ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["error"] != null) {
          throw Exception(data["error"]);
        }

        final content = data["choices"]?[0]?["message"]?["content"];
        if (content is String) return content.trim();

        return "Sorry, I couldn’t understand the AI response.";
      } else {
        throw Exception("HTTP ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      print("❌ AIService.sendChatMessage Error: $e");
      return "Error: $e";
    }
  }
}
