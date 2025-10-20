import 'dart:convert';
import 'package:http/http.dart' as http;
import 'content_model.dart';
import 'api_endpoints.dart';

class ContentService {
  Future<AppContent?> fetchContent() async {
    try {
      final response = await http.get(Uri.parse(ApiEndpoints.getContent));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body) as Map<
            String,
            dynamic>;
        if (!data.containsKey('error')) {
          return AppContent.fromJson(data);
        }
      } else {
        print("Failed to fetch content. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching content: $e");
    }
    return null;
  }

  Future<bool> updateContent(AppContent content) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.updateContent),
        body: {
          'about_title': content.aboutTitle,
          'about_subtitle': content.aboutSubtitle,
          'about_text1': content.aboutText1,
          'about_text2': content.aboutText2,
          'about_footer': content.aboutFooter,
          'team_text': content.teamText,
          'benefits_intro': content.benefitsIntro,
          'benefits_highlights': content.benefitsHighlights,
        },
      );

      final data = json.decode(response.body);
      return data['status'] == 'success';
    } catch (e) {
      print("Error updating content: $e");
      return false;
    }
  }
}