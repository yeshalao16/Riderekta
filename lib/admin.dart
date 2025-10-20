import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'api_endpoints.dart';
import 'content_service.dart';
import 'content_model.dart';



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

  final String apiUrl = ApiEndpoints.adminFeedback;
  final String baseUrl = ApiEndpoints.uploadBase;



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



  Future<void> fetchContacts() async {
    try {
      final response = await http.get(Uri.parse(ApiEndpoints.adminGetContact));
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
        Uri.parse(ApiEndpoints.adminReplyContact),
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




class ContentManagementScreen extends StatefulWidget {
  const ContentManagementScreen({super.key});

  @override
  State<ContentManagementScreen> createState() => _ContentManagementScreenState();
}

class _ContentManagementScreenState extends State<ContentManagementScreen> {
  final _service = ContentService();
  AppContent? content;
  bool isLoading = true;

  final _controllers = <String, TextEditingController>{};

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    final data = await _service.fetchContent();
    if (data != null) {
      setState(() {
        content = data;
        isLoading = false;
        _initControllers(data);
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  void _initControllers(AppContent c) {
    _controllers['aboutTitle'] = TextEditingController(text: c.aboutTitle);
    _controllers['aboutSubtitle'] = TextEditingController(text: c.aboutSubtitle);
    _controllers['aboutText1'] = TextEditingController(text: c.aboutText1);
    _controllers['aboutText2'] = TextEditingController(text: c.aboutText2);
    _controllers['aboutFooter'] = TextEditingController(text: c.aboutFooter);
    _controllers['teamText'] = TextEditingController(text: c.teamText);
    _controllers['benefitsIntro'] = TextEditingController(text: c.benefitsIntro);
    _controllers['benefitsHighlights'] = TextEditingController(text: c.benefitsHighlights);
  }

  Future<void> _saveContent() async {
    if (content == null) return;
    setState(() => isLoading = true);

    final updated = AppContent(
      aboutTitle: _controllers['aboutTitle']!.text,
      aboutSubtitle: _controllers['aboutSubtitle']!.text,
      aboutText1: _controllers['aboutText1']!.text,
      aboutText2: _controllers['aboutText2']!.text,
      aboutFooter: _controllers['aboutFooter']!.text,
      teamText: _controllers['teamText']!.text,
      benefitsIntro: _controllers['benefitsIntro']!.text,
      benefitsHighlights: _controllers['benefitsHighlights']!.text,
    );

    final success = await _service.updateContent(updated);

    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? "✅ Content updated!" : "❌ Failed to update"),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit App Content")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : content == null
          ? const Center(child: Text("No content found."))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildField("About Title", 'aboutTitle'),
            _buildField("About Subtitle", 'aboutSubtitle'),
            _buildField("About Text 1", 'aboutText1'),
            _buildField("About Text 2", 'aboutText2'),
            _buildField("About Footer", 'aboutFooter'),
            _buildField("Team Description", 'teamText'),
            _buildField("Benefits Intro", 'benefitsIntro'),
            _buildField("Benefits Highlights", 'benefitsHighlights'),
            const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _saveContent,
            icon: const Icon(Icons.save, color: Colors.white), // icon color
            label: const Text(
              "Save Changes",
              style: TextStyle(color: Colors.white), // ✅ text color
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange, // button background
              foregroundColor: Colors.white, // ✅ default text/icon color
              padding: const EdgeInsets.symmetric(vertical: 14),
             ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, String key) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: _controllers[key],
        maxLines: null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}





// ------------------------------------------------------------
// 🧩 USER MANAGEMENT
// ------------------------------------------------------------
class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  List<dynamic> users = [];
  bool isLoading = false;
  Map<int, bool> updating = {}; // Track which user's switch is updating

  final String baseUrl = ApiEndpoints.baseUrl;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() => isLoading = true);

    try {
      final res = await http.get(Uri.parse(ApiEndpoints.adminGetUsers));
      print("🟨 [DEBUG] Response code: ${res.statusCode}");
      print("🟨 [DEBUG] Response body: ${res.body}");

      if (res.statusCode == 200) {
        setState(() {
          users = json.decode(res.body);
        });
        print("🟩 [DEBUG] Loaded ${users.length} users");
      } else {
        _showSnackBar("Failed to load users");
      }
    } catch (e, stack) {
      print("🟥 [DEBUG] Exception while fetching users: $e");
      print(stack);
      _showSnackBar("Error connecting to server: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _updateStatus(int id, bool newStatus) async {
    setState(() => updating[id] = true);

    final url = Uri.parse(ApiEndpoints.updateUserStatus);
    final bodyData = {"id": id, "isActive": newStatus ? 1 : 0};

    print("🟦 [DEBUG] Sending status update request...");
    print("➡️ URL: $url");
    print("➡️ Headers: {Content-Type: application/json}");
    print("➡️ Body: ${jsonEncode(bodyData)}");

    try {
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bodyData),
      );

      print("🟨 [DEBUG] HTTP Status Code: ${res.statusCode}");
      print("🟨 [DEBUG] Raw Response Body: ${res.body}");

      if (res.statusCode != 200) {
        _showSnackBar("Server error: ${res.statusCode}");
        return;
      }

      final data = jsonDecode(res.body);
      print("🟩 [DEBUG] Decoded Response: $data");

      if (data["success"] == true) {
        _showSnackBar("✅ User status updated successfully!");
      } else {
        _showSnackBar("⚠️ Update failed: ${data['error'] ?? 'Unknown error'}");
        print("🟥 [DEBUG] Update failed. Response: $data");

        // Revert local change
        setState(() {
          final index = users.indexWhere((u) => u["id"] == id);
          if (index != -1) {
            users[index]["isActive"] = newStatus ? 0 : 1;
          }
        });
      }
    } catch (e, stack) {
      print("🟥 [DEBUG] Exception occurred: $e");
      print("🧱 [STACK TRACE]\n$stack");
      _showSnackBar("❌ Error connecting to server: $e");

      // Revert local change
      setState(() {
        final index = users.indexWhere((u) => u["id"] == id);
        if (index != -1) {
          users[index]["isActive"] = newStatus ? 0 : 1;
        }
      });
    } finally {
      setState(() => updating[id] = false);
      print("🟢 [DEBUG] Finished updating user ID: $id\n");
    }
  }

  Future<void> _editUser(Map user) async {
    final nameController = TextEditingController(text: user["name"]);
    final emailController = TextEditingController(text: user["email"]);
    final mobileController = TextEditingController(text: user["mobile"]);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit User"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: mobileController,
                decoration: const InputDecoration(labelText: "Mobile"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final body = {
                  "id": user["id"],
                  "name": nameController.text.trim(),
                  "email": emailController.text.trim(),
                  "mobile": mobileController.text.trim(),
                };

                try {
                  final res = await http.post(
                    Uri.parse(ApiEndpoints.updateUser),
                    headers: {"Content-Type": "application/json"},
                    body: jsonEncode(body),
                  );

                  print("🟦 [DEBUG] Edit response: ${res.body}");
                  final data = jsonDecode(res.body);

                  if (data["success"] == true) {
                    _showSnackBar("✅ User updated successfully!");
                    Navigator.pop(context);
                    _fetchUsers(); // Refresh list after editing
                  } else {
                    _showSnackBar("⚠️ Failed: ${data["error"] ?? 'Unknown error'}");
                  }
                } catch (e) {
                  _showSnackBar("❌ Error updating user: $e");
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }



  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Users")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
          ? const Center(child: Text("No users found."))
          : RefreshIndicator(
        onRefresh: _fetchUsers,
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            bool isActive =
                user["isActive"] == 1 || user["isActive"] == "1";
            bool isUpdating = updating[user["id"]] == true;

            return Card(
              margin: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
              child: ListTile(
                leading: Icon(
                  isActive ? Icons.check_circle : Icons.block,
                  color: isActive ? Colors.green : Colors.red,
                ),
                title: Text(user["name"] ?? "No name"),
                subtitle: Text(user["email"] ?? ""),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    isUpdating
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : Switch(
                      value: isActive,
                      onChanged: (val) async {
                        setState(() => user["isActive"] = val ? 1 : 0);
                        await _updateStatus(user["id"], val);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editUser(user),
                    ),
                  ],
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
