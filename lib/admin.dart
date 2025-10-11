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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

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
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(),
          ),
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

  Widget _buildManageAppContent() {
    return Card(
      child: ListTile(
        title: Text("Manage App Content"),
        subtitle:
        Text("Admins can add, edit, or update app content like About Us or Benefits."),
        trailing: Icon(Icons.edit),
        onTap: _navigateToContentManagement,
      ),
    );
  }

  Widget _buildManageUsers() {
    return Card(
      child: ListTile(
        title: Text("Manage Users"),
        subtitle: Text("Admins can view, update, or deactivate user accounts."),
        trailing: Icon(Icons.manage_accounts),
        onTap: _navigateToUserManagement,
      ),
    );
  }

  Widget _buildManageReports() {
    return Card(
      child: ListTile(
        title: Text("Manage Reports"),
        subtitle: Text("Admins can generate reports based on user activity, route usage, and feedback."),
        trailing: Icon(Icons.bar_chart),
        onTap: _navigateToReports,
      ),
    );
  }

  Widget _buildFeedbackOverview() {
    return Card(
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
  }

  void _navigateToContentManagement() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ContentManagementScreen()));
  }

  void _navigateToUserManagement() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => UserManagementScreen()));
  }

  void _navigateToReports() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ReportsScreen()));
  }

  void _navigateToFeedbackManagement() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FeedbackManagementScreen()));
  }

  void _logout() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}

// ✅ Feedback Management Screen (Connected to Database)

class FeedbackManagementScreen extends StatefulWidget {
  @override
  _FeedbackManagementScreenState createState() =>
      _FeedbackManagementScreenState();
}

class _FeedbackManagementScreenState extends State<FeedbackManagementScreen> {
  bool isLoading = true;
  List<dynamic> feedbackList = [];

  // ⚙️ Change this to match your local or server URL
  final String apiUrl = "http://192.168.254.116/riderekta/admin_feedback.php";
  // If on physical device: use your computer’s IP (e.g., http://192.168.1.10/riderekta/api_get_feedback.php)

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Feedback"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchFeedback,
          ),
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
            return Card(
              margin: const EdgeInsets.symmetric(
                  vertical: 8, horizontal: 12),
              child: ListTile(
                title: Text(fb["message"] ?? "No message",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("👤 ${fb["user_name"] ?? "Anonymous"}"),
                    Text("📧 ${fb["email"] ?? "No email"}"),
                    Text("🕒 ${fb["created_at"] ?? ""}"),
                  ],
                ),
                trailing: (fb["attachment"] != null &&
                    fb["attachment"].toString().isNotEmpty)
                    ? IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "Attachment: ${fb["attachment"]}"),
                      ),
                    );
                  },
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



// ✅ Content Management Screen
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

// ✅ User Management Screen
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

// ✅ Reports Screen
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

// ✅ Login Screen
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  void _login() {
    if (emailController.text == "admin@admin.com" &&
        passController.text == "admin") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AdminDashboard()),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invalid credentials")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: "Email"),
          ),
          TextField(
            controller: passController,
            obscureText: true,
            decoration: InputDecoration(labelText: "Password"),
          ),
          SizedBox(height: 20),
          ElevatedButton(onPressed: _login, child: Text("Log In")),
        ]),
      ),
    );
  }
}
