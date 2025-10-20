class ApiEndpoints {
  // 🔗 Base URL (change this once if your server IP or folder changes)
  static const String baseUrl = "http://192.168.254.116/riderekta";

  // 🟢 Authentication
  static const String login = "$baseUrl/login.php";
  static const String register = "$baseUrl/register.php";

  // 👤 User-related
  static const String updateProfile = "$baseUrl/update_profile.php";
  static const String getUser = "$baseUrl/get_user.php";

  // 📝 Posts
  static const String createPost = "$baseUrl/create_post.php";
  static const String getPosts = "$baseUrl/get_posts.php";

  // 🧩 Admin: Feedback Management
  static const String adminFeedback = "$baseUrl/admin_feedback.php";
  static const String uploadBase = "$baseUrl/uploads/";

  static const String submitFeed = "$baseUrl/submit_feedback.php";

  // 👥 Admin: User Management
  static const String adminGetUsers = "$baseUrl/admin_getuser.php";
  static const String updateUserStatus = "$baseUrl/update_user_status.php";
  static const String updateUser = "$baseUrl/update_user.php";

  // 📬 Admin: Contact Management
  static const String adminGetContact = "$baseUrl/admin_getcontact.php";
  static const String adminReplyContact = "$baseUrl/admin_replycontact.php";

  static const String userContact = "$baseUrl/contact.php";

  // 📊 Reports / Misc
  static const String generateReports = "$baseUrl/generate_reports.php";

  // Content Managament
  static const String getContent = "$baseUrl/get_content.php";
  static const String updateContent = "$baseUrl/update_content.php";
}
