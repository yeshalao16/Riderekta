import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  final String apiKey = "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"; // replace safely

  // Stores the chat history
  final List<Map<String, String>> _messages = [
    {"role": "system", "content": "You are a helpful e-bike route safety assistant."}
  ];

  // Keeps the existing suggestion function
  Future<List<String>> getSafetySuggestions(double lat, double lon) async {
    final url = Uri.parse("https://api.openai.com/v1/chat/completions");

    final prompt = """
You are a safety assistant for e-bike riders.
Current location: ($lat, $lon)
Give 3 short, practical route safety suggestions for e-bike riders nearby.
Each suggestion should be one sentence.
""";

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "gpt-4o-mini",
        "messages": [
          {"role": "system", "content": "You are a helpful e-bike safety assistant."},
          {"role": "user", "content": prompt}
        ],
        "temperature": 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data["choices"]?[0]?["message"]?["content"];

      if (content is! String) return ["Unexpected response format from AI."];

      return content
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();
    } else {
      throw Exception("Failed to fetch suggestions: ${response.body}");
    }
  }

  // 🔹 New: Chat method that remembers conversation
  Future<String> sendChatMessage(String userMessage, double lat, double lon) async {
    final url = Uri.parse("https://api.openai.com/v1/chat/completions");

    // Add the user message to the conversation
    _messages.add({
      "role": "user",
      "content":
      "User's current location: ($lat, $lon)\nUser says: $userMessage"
    });

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "gpt-4o-mini",
        "messages": _messages,
        "temperature": 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data["choices"]?[0]?["message"]?["content"];

      if (content is String) {
        _messages.add({"role": "assistant", "content": content});
        return content.trim();
      } else {
        return "Sorry, I couldn’t understand the AI response.";
      }
    } else {
      throw Exception("Failed to send message: ${response.body}");
    }
  }
}
