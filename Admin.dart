import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      home: AdminDashboard(),
    );
  }
}

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  // Placeholder data for the user activity and reports
  final int totalUsers = 3000;
  final int userActivityIssues = 40;
  final int routeUsageIssues = 35;
  final int generalFeedback = 25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Add logout functionality here
              _logout();
            },
          )
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
        subtitle: Text("Admins can add, edit, or update app content like About Us or Benefits."),
        trailing: Icon(Icons.edit),
        onTap: () {
          // Navigate to the app content management screen
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
          // Navigate to manage users screen
          _navigateToUserManagement();
        },
      ),
    );
  }

  Widget _buildManageReports() {
    return Card(
      child: ListTile(
        title: Text("Manage Reports"),
        subtitle: Text("Admins can generate reports based on user activity, route usage, and feedback."),
        trailing: Icon(Icons.bar_chart),
        onTap: () {
          // Navigate to report generation screen
          _navigateToReports();
        },
      ),
    );
  }

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

  // Functions to navigate to different parts of the app
  void _navigateToContentManagement() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContentManagementScreen()),
    );
  }

  void _navigateToUserManagement() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserManagementScreen()),
    );
  }

  void _navigateToReports() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReportsScreen()),
    );
  }

  // Logout function
  void _logout() {
    // You can add the logout logic here, such as clearing the session.
    print("User Logged Out");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}

// Content Management Screen (Placeholder)
class ContentManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage App Content")),
      body: Center(child: Text("Manage Content Here")),
    );
  }
}

// User Management Screen (Placeholder)
class UserManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Users")),
      body: Center(child: Text("Manage Users Here")),
    );
  }
}

// Reports Screen (Placeholder)
class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Reports")),
      body: Center(child: Text("View Reports Here")),
    );
  }
}

// Login Screen (Placeholder)
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Center(child: Text("Please log in again.")),
    );
  }
}
