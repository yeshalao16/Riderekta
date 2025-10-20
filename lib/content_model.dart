class AppContent {
  final String aboutTitle;
  final String aboutSubtitle;
  final String aboutText1;
  final String aboutText2;
  final String aboutFooter;
  final String teamText;
  final String benefitsIntro;
  final String benefitsHighlights;

  AppContent({
    required this.aboutTitle,
    required this.aboutSubtitle,
    required this.aboutText1,
    required this.aboutText2,
    required this.aboutFooter,
    required this.teamText,
    required this.benefitsIntro,
    required this.benefitsHighlights,
  });

  factory AppContent.fromJson(Map<String, dynamic> json) {
    return AppContent(
      aboutTitle: json['about_title'] ?? '',
      aboutSubtitle: json['about_subtitle'] ?? '',
      aboutText1: json['about_text1'] ?? '',
      aboutText2: json['about_text2'] ?? '',
      aboutFooter: json['about_footer'] ?? '',
      teamText: json['team_text'] ?? '',
      benefitsIntro: json['benefits_intro'] ?? '',
      benefitsHighlights: json['benefits_highlights'] ?? '',
    );
  }
}
