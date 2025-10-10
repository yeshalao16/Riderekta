import 'package:flutter/material.dart';

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
      home: LoginScreen(), // Start with the login screen
    );
  }
}

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final int totalUsers = 3000;
  int userActivityIssues = 40; // Percentage for user activity issues
  int routeUsageIssues = 35; // Percentage for route usage issues
  int generalFeedback = 25; // Percentage for general feedback

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _logout();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildManageAppContent(),
            SizedBox(height: 20),
            _buildManageUsers(),
            SizedBox(height: 20),
            _buildManageReports(), // Reports Section
            SizedBox(height: 20),
            _buildFeedbackOverview(), // Feedback Overview Section
          ],
        ),
      ),
    );
  }

  Widget _buildManageAppContent() {
    return Card(
      child: ListTile(
        title: Text("Manage App Content"),
        subtitle: Text("Admins can add, edit, or update app content like About Us or Benefits."),
        trailing: Icon(Icons.edit),
        onTap: () {
          _navigateToContentManagement();
        },
      ),
    );
  }

  Widget _buildManageUsers() {
    return Card(
      child: ListTile(
        title: Text("Manage Users"),
        subtitle: Text("Admins can view, update, or deactivate user accounts."),
        trailing: Icon(Icons.manage_accounts),
        onTap: () {
          _navigateToUserManagement();
        },
      ),
    );
  }

  // Manage Reports Section
  Widget _buildManageReports() {
    return Card(
      child: ListTile(
        title: Text("Manage Reports"),
        subtitle: Text("Admins can generate reports based on user activity, route usage, and feedback."),
        trailing: Icon(Icons.bar_chart),
        onTap: () {
          _navigateToReports();
        },
      ),
    );
  }

  // Feedback Overview Section
  Widget _buildFeedbackOverview() {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text("Feedback Overview"),
          ),
          ListTile(
            title: Text("User Activity Issues"),
            subtitle: Text("$userActivityIssues%"),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _editFeedbackPercentage("User Activity Issues", userActivityIssues, (newValue) {
                  setState(() {
                    userActivityIssues = newValue;
                  });
                });
              },
            ),
          ),
          ListTile(
            title: Text("Route Usage Issues"),
            subtitle: Text("$routeUsageIssues%"),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _editFeedbackPercentage("Route Usage Issues", routeUsageIssues, (newValue) {
                  setState(() {
                    routeUsageIssues = newValue;
                  });
                });
              },
            ),
          ),
          ListTile(
            title: Text("General Feedback / Suggestions"),
            subtitle: Text("$generalFeedback%"),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _editFeedbackPercentage("General Feedback / Suggestions", generalFeedback, (newValue) {
                  setState(() {
                    generalFeedback = newValue;
                  });
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // Function to allow admin to edit the percentage for feedback issues
  void _editFeedbackPercentage(String feedbackType, int currentValue, Function(int) onSave) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController(text: currentValue.toString());
        return AlertDialog(
          title: Text("Edit $feedbackType"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: feedbackType,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                int newValue = int.tryParse(controller.text) ?? currentValue;
                onSave(newValue); // Update the value
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  // Navigate to content management screen
  void _navigateToContentManagement() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContentManagementScreen()),
    );
  }

  // Navigate to user management screen
  void _navigateToUserManagement() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserManagementScreen()),
    );
  }

  // Navigate to reports screen
  void _navigateToReports() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReportsScreen()),
    );
  }

  // Logout function
  void _logout() {
    print("User Logged Out");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}

// Content Management Screen
class ContentManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage App Content")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Edit About Us Content", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              decoration: InputDecoration(
                labelText: "About Us",
                hintText: "Enter content for About Us section...",
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            Text("Edit Benefits Content", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              decoration: InputDecoration(
                labelText: "Benefits",
                hintText: "Enter content for Benefits section...",
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save content logic goes here
                print("Content Saved!");
              },
              child: Text("Save Content"),
            ),
          ],
        ),
      ),
    );
  }
}

// User Management Screen
class UserManagementScreen extends StatefulWidget {
  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  List<Map<String, dynamic>> users = [
    {"name": "John Doe", "email": "john.doe@example.com", "isActive": true},
    {"name": "Jane Smith", "email": "jane.smith@example.com", "isActive": false},
    {"name": "Mike Johnson", "email": "mike.johnson@example.com", "isActive": true},
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
              title: Text(user['name']),
              subtitle: Text(user['email']),
              trailing: Wrap(
                spacing: 12, // space between icons
                children: [
                  IconButton(
                    icon: Icon(Icons.visibility),
                    onPressed: () {
                      _showUserDetails(context, user);
                    },
                  ),
                  Switch(
                    value: user['isActive'],
                    onChanged: (value) {
                      setState(() {
                        user['isActive'] = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showUserDetails(BuildContext context, Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController nameController = TextEditingController(text: user['name']);
        TextEditingController emailController = TextEditingController(text: user['email']);
        return AlertDialog(
          title: Text("Edit User"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "User Name"),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  user['name'] = nameController.text;
                  user['email'] = emailController.text;
                });
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}

// Reports Screen - Dropdown for report type selection
class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String? selectedReportType;
  final List<String> reportTypes = ['User Activity', 'Route Usage', 'Feedback'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Reports")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Generate Reports",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            // Dropdown for report types
            DropdownButton<String>(
              hint: Text("Select Report Type"),
              value: selectedReportType,
              onChanged: (String? newValue) {
                setState(() {
                  selectedReportType = newValue;
                });
              },
              items: reportTypes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            // Generate report button
            ElevatedButton(
              onPressed: () {
                if (selectedReportType != null) {
                  // Navigate to a new screen with the report details
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportDetailsScreen(reportType: selectedReportType!),
                    ),
                  );
                } else {
                  // If the user hasn't selected a report type
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please select a report type.")),
                  );
                }
              },
              child: Text("Generate Report"),
            ),
          ],
        ),
      ),
    );
  }
}

// New screen to display the report details
class ReportDetailsScreen extends StatelessWidget {
  final String reportType;

  ReportDetailsScreen({required this.reportType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Report Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Generated Report: $reportType",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              _generateReport(reportType),
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  String _generateReport(String reportType) {
    switch (reportType) {
      case 'User Activity':
        return "User Activity Report: 40% of users have issues.";
      case 'Route Usage':
        return "Route Usage Report: 35% of routes are having issues.";
      case 'Feedback':
        return "Feedback Report: 25% of users submitted feedback.";
      default:
        return "No report available.";
    }
  }
}

// Login Screen
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // A simple login validation (you can replace it with real authentication)
  void _login() {
    if (_emailController.text == 'admin@admin.com' && _passwordController.text == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminDashboard()),
      );
    } else {
      // Display an error message if login fails
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Invalid credentials. Please try again."),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text("Log In"),
            ),
            SizedBox(height: 20),
            Text("Please log in again."),
          ],
        ),
      ),
    );
  }
}