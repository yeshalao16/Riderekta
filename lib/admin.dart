import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';

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
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Disable back navigation only on the AdminDashboard
        return false;  // Returning false disables the default back action
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Admin Dashboard"),
          automaticallyImplyLeading: false, // This removes the back arrow
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => _showLogoutConfirmationDialog(), // Call the dialog
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
              SizedBox(height: 20),
              _buildContactMessages(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManageAppContent() => Card(
    child: ListTile(
      title: const Text("Manage App Content"),
      subtitle: const Text(
          "Admins can add, edit, or update app content like About Us or Benefits."),
      trailing: const Icon(Icons.edit),
      onTap: _navigateToContentManagement,
    ),
  );

  Widget _buildManageUsers() => Card(
    child: ListTile(
      title: const Text("Manage Users"),
      subtitle:
      const Text("Admins can view, update, or deactivate user accounts."),
      trailing: const Icon(Icons.manage_accounts),
      onTap: _navigateToUserManagement,
    ),
  );

  Widget _buildManageReports() => Card(
    child: ListTile(
      title: const Text("Manage Reports"),
      subtitle: const Text(
          "Admins can generate reports based on user activity, route usage, and feedback."),
      trailing: const Icon(Icons.bar_chart),
      onTap: _navigateToReports,
    ),
  );

  Widget _buildFeedbackOverview() => Card(
    child: ListTile(
      title: const Text("Feedback Overview"),
      subtitle: const Text("View user feedback with optional attachments."),
      trailing: const Icon(Icons.feedback),
      onTap: _navigateToFeedbackManagement,
    ),
  );

  Widget _buildContactMessages() => Card(
    child: ListTile(
      title: const Text("Contact Messages"),
      subtitle:
      const Text("View all contact form submissions from users."),
      trailing: const Icon(Icons.contact_mail),
      onTap: _navigateToContactMessages,
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

  void _navigateToContactMessages() => Navigator.push(
      context, MaterialPageRoute(builder: (_) => ContactMessagesScreen()));



  // Logout Confirmation Dialog
  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context, // Use the widget's context
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Are you sure you want to log out?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext); // Close the dialog
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext); // Close the dialog first
                Navigator.pushReplacement(
                  context, // Use the outer widget's context for navigation
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              },
              child: const Text("Yes", style: TextStyle(color: Colors.deepOrange)),
            ),
          ],
        );
      },
    );
  }
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

  final String apiUrl = "http://10.147.196.1/riderekta/admin_feedback.php";
  final String baseUrl = "http://10.147.196.1/riderekta/uploads/";

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

// LOGOUT CONFIRMATION DIALOG MOVED INSIDE ADMIN DASHBOARD CLASS (REMOVED FROM HERE)

// ------------------------------------------------------------
// 🧩 CONTACT MESSAGES WITH REPLY FUNCTION
// ------------------------------------------------------------
class ContactMessagesScreen extends StatefulWidget {
  @override
  _ContactMessagesScreenState createState() => _ContactMessagesScreenState();
}

class _ContactMessagesScreenState extends State<ContactMessagesScreen> {
  bool isLoading = true;
  List<dynamic> contactList = [];

  final String apiUrl = "http://10.147.196.1/riderekta/admin_getcontact.php";
  final String replyUrl = "http://10.147.196.1/riderekta/admin_replycontact.php";

  Future<void> fetchContacts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["success"] == true) {
          setState(() {
            contactList = data["contacts"];
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
        }
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error fetching contact messages: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> sendReply(int id, String reply) async {
    try {
      final response = await http.post(
        Uri.parse(replyUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": id, "reply": reply}),
      );

      final data = jsonDecode(response.body);
      if (data["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Reply sent successfully!")),
        );
        fetchContacts();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${data["message"]}")),
        );
      }
    } catch (e) {
      print("Error sending reply: $e");
    }
  }

  void _showReplyDialog(int id, String userEmail, String? currentReply) {
    final TextEditingController replyController =
    TextEditingController(text: currentReply ?? "");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Reply to $userEmail"),
        content: TextField(
          controller: replyController,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: "Your reply",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              sendReply(id, replyController.text);
            },
            child: const Text("Send Reply"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Messages"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: fetchContacts),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : contactList.isEmpty
          ? const Center(child: Text("No contact messages found."))
          : RefreshIndicator(
        onRefresh: fetchContacts,
        child: ListView.builder(
          itemCount: contactList.length,
          itemBuilder: (context, index) {
            final contact = contactList[index];
            return Card(
              margin: const EdgeInsets.symmetric(
                  vertical: 8, horizontal: 12),
              child: ListTile(
                title: Text(
                  "${contact["name"] ?? "No name"} ${contact["surname"] ?? ""}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("📧 ${contact["email"] ?? "No email"}"),
                    const SizedBox(height: 4),
                    Text("💬 ${contact["message"] ?? "No message"}"),
                    const SizedBox(height: 4),
                    if (contact["reply"] != null &&
                        contact["reply"].toString().isNotEmpty)
                      Container(
                        margin:
                        const EdgeInsets.only(top: 8, bottom: 4),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Admin Reply: ${contact["reply"]}",
                          style: const TextStyle(
                              color: Colors.black87,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    Text("🕒 ${contact["created_at"] ?? ""}"),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.reply),
                  onPressed: () => _showReplyDialog(
                    int.parse(contact["id"].toString()),
                    contact["email"] ?? "",
                    contact["reply"],
                  ),
                ),
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
      appBar: AppBar(title: const Text("Manage App Content")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                  labelText: "About Us", border: OutlineInputBorder()),
              maxLines: 4,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                  labelText: "Benefits", border: OutlineInputBorder()),
              maxLines: 4,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("Content Saved!"))),
              child: const Text("Save"),
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
      appBar: AppBar(title: const Text("Manage Users")),
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
      appBar: AppBar(title: const Text("Generate Reports")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StatefulBuilder(builder: (context, setState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton<String>(
                hint: const Text("Select Report Type"),
                value: selectedReport,
                onChanged: (value) => setState(() => selectedReport = value),
                items: reports
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: selectedReport == null
                    ? null
                    : () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                      Text("$selectedReport Report Generated!")),
                ),
                child: const Text("Generate Report"),
              )
            ],
          );
        }),
      ),
    );
  }
}
