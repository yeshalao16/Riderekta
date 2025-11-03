import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_endpoints.dart'; // your class with baseUrl

class AIService {
  // ✅ No API key here anymore

  Future<List<String>> getSafetySuggestions(double lat, double lon) async {
    final url = Uri.parse("${ApiEndpoints.aiSafety}/ai_safety.php");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "lat": lat,
        "lon": lon,
        "type": "suggestions",
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data["choices"]?[0]?["message"]?["content"];
      if (content is! String) return ["Unexpected response format."];

      return content
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();
    } else {
      throw Exception("Failed: ${response.body}");
    }
  }

  Future<String> sendChatMessage(
      String userMessage, double lat, double lon) async {
    final url = Uri.parse("${ApiEndpoints.baseUrl}/ai_safety.php");

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

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data["choices"]?[0]?["message"]?["content"];
      if (content is String) return content.trim();
      return "Sorry, I couldn’t understand the AI response.";
    } else {
      throw Exception("Failed: ${response.body}");
    }
  }
}
