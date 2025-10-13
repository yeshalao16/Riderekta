import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
    );
  }
}

// ------------------------------------------------------------
// 🧩 ADMIN DASHBOARD
// ------------------------------------------------------------
class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final int totalUsers = 3000;
  int userActivityIssues = 40;
  int routeUsageIssues = 35;
  int generalFeedback = 25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildManageAppContent(),
            SizedBox(height: 20),
            _buildManageUsers(),
            SizedBox(height: 20),
            _buildManageReports(),
            SizedBox(height: 20),
            _buildFeedbackOverview(),
          ],
        ),
      ),
    );
  }

  Widget _buildManageAppContent() => Card(
    child: ListTile(
      title: Text("Manage App Content"),
      subtitle: Text(
          "Admins can add, edit, or update app content like About Us or Benefits."),
      trailing: Icon(Icons.edit),
      onTap: _navigateToContentManagement,
    ),
  );

  Widget _buildManageUsers() => Card(
    child: ListTile(
      title: Text("Manage Users"),
      subtitle: Text("Admins can view, update, or deactivate user accounts."),
      trailing: Icon(Icons.manage_accounts),
      onTap: _navigateToUserManagement,
    ),
  );

  Widget _buildManageReports() => Card(
    child: ListTile(
      title: Text("Manage Reports"),
      subtitle: Text(
          "Admins can generate reports based on user activity, route usage, and feedback."),
      trailing: Icon(Icons.bar_chart),
      onTap: _navigateToReports,
    ),
  );

  Widget _buildFeedbackOverview() => Card(
    child: Column(
      children: [
        ListTile(
          title: Text("Feedback Overview"),
          trailing: IconButton(
            icon: Icon(Icons.feedback),
            onPressed: _navigateToFeedbackManagement,
          ),
        ),
        ListTile(
          title: Text("User Activity Issues"),
          subtitle: Text("$userActivityIssues%"),
        ),
        ListTile(
          title: Text("Route Usage Issues"),
          subtitle: Text("$routeUsageIssues%"),
        ),
        ListTile(
          title: Text("General Feedback / Suggestions"),
          subtitle: Text("$generalFeedback%"),
        ),
      ],
    ),
  );

  void _navigateToContentManagement() => Navigator.push(
      context, MaterialPageRoute(builder: (_) => ContentManagementScreen()));

  void _navigateToUserManagement() => Navigator.push(
      context, MaterialPageRoute(builder: (_) => UserManagementScreen()));

  void _navigateToReports() => Navigator.push(
      context, MaterialPageRoute(builder: (_) => ReportsScreen()));

  void _navigateToFeedbackManagement() => Navigator.push(
      context, MaterialPageRoute(builder: (_) => FeedbackManagementScreen()));

  void _logout() => Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (_) => LoginScreen()));
}

// ------------------------------------------------------------
// 🧩 FEEDBACK MANAGEMENT
// ------------------------------------------------------------
class FeedbackManagementScreen extends StatefulWidget {
  @override
  _FeedbackManagementScreenState createState() =>
      _FeedbackManagementScreenState();
}

class _FeedbackManagementScreenState extends State<FeedbackManagementScreen> {
  bool isLoading = true;
  List<dynamic> feedbackList = [];

  // ⚙️ Replace with your actual local IP
  // If testing on Android emulator, use 10.0.2.2
// If testing on Physcial device, use 192.168.254.x
  final String apiUrl = "http://10.1.21.175/riderekta/admin_feedback.php";
  final String baseUrl = "http://10.1.21.175/riderekta/uploads/";

  Future<void> fetchFeedback() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["success"] == true) {
          setState(() {
            feedbackList = data["feedback"];
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
        }
      } else {
        print("HTTP Error: ${response.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error fetching feedback: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFeedback();
  }

  void _showAttachmentDialog(String attachmentPath) {
    final isImage = attachmentPath.endsWith('.jpg') ||
        attachmentPath.endsWith('.jpeg') ||
        attachmentPath.endsWith('.png') ||
        attachmentPath.endsWith('.gif');

    final imageUrl = attachmentPath.startsWith("http")
        ? attachmentPath
        : baseUrl + attachmentPath;

    print("🖼️ Loading image: $imageUrl");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Attachment Preview"),
        content: isImage
            ? Image.network(
          imageUrl,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
          const Text("⚠️ Failed to load image"),
        )
            : Text("📎 Attachment: $attachmentPath"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Feedback"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: fetchFeedback),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : feedbackList.isEmpty
          ? const Center(child: Text("No feedback found."))
          : RefreshIndicator(
        onRefresh: fetchFeedback,
        child: ListView.builder(
          itemCount: feedbackList.length,
          itemBuilder: (context, index) {
            final fb = feedbackList[index];
            final attachment = fb["attachment"]?.toString() ?? "";

            return Card(
              margin: const EdgeInsets.symmetric(
                  vertical: 8, horizontal: 12),
              child: ListTile(
                title: Text(
                  fb["message"] ?? "No message",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("👤 ${fb["user_name"] ?? "Anonymous"}"),
                    Text("📧 ${fb["email"] ?? "No email"}"),
                    Text("🕒 ${fb["created_at"] ?? ""}"),
                  ],
                ),
                trailing: (attachment.isNotEmpty)
                    ? IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: () =>
                      _showAttachmentDialog(attachment),
                )
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// 🧩 CONTENT MANAGEMENT
// ------------------------------------------------------------
class ContentManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage App Content")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                  labelText: "About Us", border: OutlineInputBorder()),
              maxLines: 4,
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                  labelText: "Benefits", border: OutlineInputBorder()),
              maxLines: 4,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Content Saved!"))),
              child: Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// 🧩 USER MANAGEMENT
// ------------------------------------------------------------
class UserManagementScreen extends StatefulWidget {
  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  List<Map<String, dynamic>> users = [
    {"name": "John Doe", "email": "john.doe@example.com", "isActive": true},
    {"name": "Jane Smith", "email": "jane.smith@example.com", "isActive": false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Users")),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          var user = users[index];
          return Card(
            child: ListTile(
              title: Text(user["name"]),
              subtitle: Text(user["email"]),
              trailing: Switch(
                value: user["isActive"],
                onChanged: (val) {
                  setState(() => user["isActive"] = val);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

// ------------------------------------------------------------
// 🧩 REPORTS
// ------------------------------------------------------------
class ReportsScreen extends StatelessWidget {
  final List<String> reports = ["User Activity", "Route Usage", "Feedback"];

  @override
  Widget build(BuildContext context) {
    String? selectedReport;
    return Scaffold(
      appBar: AppBar(title: Text("Generate Reports")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StatefulBuilder(builder: (context, setState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton<String>(
                hint: Text("Select Report Type"),
                value: selectedReport,
                onChanged: (value) => setState(() => selectedReport = value),
                items: reports
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: selectedReport == null
                    ? null
                    : () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text("$selectedReport Report Generated!")),
                ),
                child: Text("Generate Report"),
              )
            ],
          );
        }),
      ),
    );
  }
}

// ------------------------------------------------------------
// 🧩 LOGIN SCREEN
// ------------------------------------------------------------
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool _obscurePassword = true;

  void _login() {
    if (emailController.text.trim() == "admin@admin.com" &&
        passController.text.trim() == "admin") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Admin login successful!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AdminDashboard()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Invalid credentials")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Login"),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email Field
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Password Field with Eye Toggle
            TextField(
              controller: passController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.deepOrange,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Login Button
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding:
                const EdgeInsets.symmetric(horizontal: 80, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Log In",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
