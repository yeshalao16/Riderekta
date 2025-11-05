import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'ebike_specific_route.dart';
import 'admin.dart';
import 'RouteHistoryScreen.dart';
import 'RouteSafetyScreen.dart';
import 'api_endpoints.dart';
import 'content_service.dart';
import 'content_model.dart';



void main() {
  runApp(const RiderektaApp());
}


class RiderektaApp extends StatelessWidget {
  const RiderektaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riderekta',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Home Page',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,

        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Login',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'About'),
                Tab(text: 'Team'),
                Tab(text: 'Benefits'),
              ],
              labelColor: Colors.deepOrange,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.deepOrange,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  AboutScreen(key: ValueKey('about')),
                  OurTeamScreen(key: ValueKey('team')),
                  BenefitsScreen(key: ValueKey('benefits')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// LOGOUT CONFIRMATION DIALOG ADDED HERE
void _showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Are you sure you want to log out?"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              ); // Navigate to the login screen
            },
            child: const Text("Yes", style: TextStyle(color: Colors.deepOrange)),
          ),
        ],
      );
    },
  );
}

///////////////////// ABOUT US SECTION //////////////////////////////////
class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final _service = ContentService();
  AppContent? content;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    final data = await _service.fetchContent();
    setState(() {
      content = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double horizontalPadding = 16.0;
    final double containerMargin = 4.0;
    final double spacing = 8.0;
    final double totalHorizontal = (horizontalPadding * 2) + (containerMargin * 2) + spacing;
    final double imageWidth = (screenWidth - totalHorizontal) / 2;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (content == null) {
      return const Center(child: Text("Failed to load content"));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            content!.aboutTitle, // ✅ from DB
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: Colors.deepOrange,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content!.aboutSubtitle, // ✅ from DB
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF7FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFCAC4D0)),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/ebike1.jpg',
                    width: 300,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    content!.aboutText1, // ✅ from DB
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content!.aboutText2, // ✅ from DB
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Image.asset(
                    'assets/ebike2.jpg',
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Image.asset(
                    'assets/ebike3.jpg',
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height:10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              content!.aboutFooter, // ✅ from DB
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}




///////////////////// TEAM SECTION //////////////////////////////////


class OurTeamScreen extends StatelessWidget {
  const OurTeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final teamMembers = [
      {'name': 'Yesha Nicholai Lao', 'role': 'Scrum Master', 'image': 'assets/images/yesha.png'},
      {'name': 'Geraldine Kaye Novilla', 'role': 'Back-End Developer', 'image': 'assets/images/geraldine.png'},
      {'name': 'Kyla Fhe Sable', 'role': 'Front-End Developer', 'image': 'assets/images/kyla.png'},
      {'name': 'Noel Bayona', 'role': 'Quality Assurance (QA)', 'image': 'assets/images/noel.png'},
    ];

    const description =
        'Developed by a group of innovative students, Riderekta reflects our passion for technology and our commitment to improving everyday travel experiences.';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FadeInDown(
              duration: const Duration(milliseconds: 800),
              child: Column(
                children: [
                  Image.asset('assets/Riderekta.png', height: 120),
                  const SizedBox(height: 20),
                  const Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            FadeInUp(
              duration: const Duration(milliseconds: 800),
              child: const Text(
                "Riderekta is built by a dedicated team of innovators working together to create a safer and greener way to travel:",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, height: 1.6, fontWeight: FontWeight.w500, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 24),
            Column(
              children: teamMembers.asMap().entries.map((entry) {
                final index = entry.key;
                final member = entry.value;
                return FadeInUp(
                  duration: Duration(milliseconds: 600 + (index * 150)),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 3)),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(radius: 30, backgroundImage: AssetImage(member['image']!)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(member['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 4),
                              Text(member['role']!, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}




//////////// BENEFITS SECTION //////////////////////
class BenefitsScreen extends StatefulWidget {
  const BenefitsScreen({super.key});

  @override
  State<BenefitsScreen> createState() => _BenefitsScreenState();
}

class _BenefitsScreenState extends State<BenefitsScreen> {
  final _service = ContentService();
  AppContent? content;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    final data = await _service.fetchContent();
    setState(() {
      content = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color mainColor = Colors.orange.shade700;

    final List<Map<String, dynamic>> features = [
      {"icon": Icons.directions_bike, "title": "Optimized Routes", "description": "Customized routes optimized for e-bikes."},
      {"icon": Icons.map_outlined, "title": "Safe Cycling Lanes", "description": "Highlighting protected lanes and safe paths."},
      {"icon": Icons.remove_road_outlined, "title": "Avoid Unsafe Roads", "description": "Avoiding unsafe or high-traffic areas."},
      {"icon": Icons.groups_3_outlined, "title": "Community Forums", "description": "Fostering vibrant rider community forums."},
      {"icon": Icons.feedback_outlined, "title": "Feedback Channels", "description": "Engaging feedback from active riders."},
      {"icon": Icons.support_agent_outlined, "title": "Direct Support", "description": "Responsive and helpful support anytime."},
    ];

    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (content == null) return const Center(child: Text("Failed to load content"));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "BENEFITS",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                content!.benefitsIntro, // ✅ from DB
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, height: 1.6),
              ),
              const SizedBox(height: 18),
              Text(
                content!.benefitsHighlights, // ✅ from DB
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ...features.map((f) => _buildFeatureCard(
                icon: f["icon"],
                title: f["title"],
                description: f["description"],
                mainColor: mainColor,
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color mainColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 30, color: mainColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(description, style: const TextStyle(fontSize: 14, height: 1.4, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}







class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;


  final String apiUrl = ApiEndpoints.login;

  Future<void> login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please enter email and password")),
      );
      return;
    }

    // Simple Admin Login
    if (email == 'admin@admin.com' && password == 'admin') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Admin login successful!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminDashboard()),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "email": email,
          "password": password,
        },
      );

      final data = jsonDecode(response.body);

      if (data["success"] == true) {
        // ✅ Login successful
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Login successful!")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserDashboard(email: email),
          ),
        );
      } else {
        // ❌ Show any message from the server (including deactivation)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ ${data["message"]}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Error: $e")),
      );
    }
  }


  // 🚀 Quick Login (No SQL)
  void quickLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("🚀 Quick login successful!")),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const UserDashboard(email: "guest@demo.com"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 👇 Redirect back to home instead of previous dashboard
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
              (route) => false,
        );

        return false; // Prevent default back behavior
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Login")),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔹 Email field
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 🔹 Password field
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Login button
              ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),

              const SizedBox(height: 10),

              // 🔹 Quick login
              OutlinedButton.icon(
                onPressed: quickLogin,
                icon: const Icon(Icons.flash_on, color: Colors.deepOrange),
                label: const Text(
                  "Quick Login (No SQL)",
                  style: TextStyle(color: Colors.deepOrange),
                ),
              ),

              const SizedBox(height: 10),

              // 🔹 Register link
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(color: Colors.deepOrange),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// ✅ Updated Settings Screen with Editable Fields
class SettingsScreen extends StatefulWidget {
  final String email;
  const SettingsScreen({super.key, required this.email});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool notifications = true;
  bool privacy = true;


  final String getUserUrl = ApiEndpoints.getUser;
  final String updateProfileUrl = ApiEndpoints.updateProfile;


  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Load data when the screen opens
  }

  Future<void> _fetchUserData() async {
    try {
      final response = await http.post(
        Uri.parse(getUserUrl),
        body: {"email": widget.email},
      );

      final data = jsonDecode(response.body);

      if (data["success"]) {
        final user = data["user"];
        setState(() {
          emailController.text = user["email"];
          mobileController.text = user["mobile"] ?? '';
          passwordController.text = user["password"];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ ${data["message"]}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Error: $e")),
      );
    }
  }

  Future<void> _saveProfile() async {
    try {
      final response = await http.post(
        Uri.parse(updateProfileUrl),
        body: {
          "email": emailController.text.trim(),
          "mobile": mobileController.text.trim(),
          "password": passwordController.text.trim(),
        },
      );

      final data = jsonDecode(response.body);

      if (data["success"]) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Profile updated successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ ${data["message"]}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Error: $e")),
      );
    }
  }

  void _toggleNotifications(bool value) {
    setState(() => notifications = value);
  }

  void _togglePrivacy(bool value) {
    setState(() => privacy = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Profile & Settings")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text("Edit Profile", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                enabled: false,  // Prevents typing and interaction
                decoration: const InputDecoration(
                    labelText: "Email",
                    suffixIcon: Icon(Icons.lock, color: Colors.grey)
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: mobileController,
                decoration: const InputDecoration(labelText: "Mobile Number"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
                child: const Text("Save Changes", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 40),
              const Text("App Settings", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text("Enable Notifications"),
                value: notifications,
                onChanged: _toggleNotifications,
              ),
              SwitchListTile(
                title: const Text("Accept Privacy Policy"),
                value: privacy,
                onChanged: _togglePrivacy,
              ),
            ],
          ),
        ),
      ),
    );
  }
}




class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true; // Toggle for password visibility

  Future<void> register() async {
    try {
      final response = await http.post(Uri.parse(ApiEndpoints.register),
        body: {
          "name": _nameController.text.trim(),
          "email": _emailController.text.trim(),
          "mobile": _mobileController.text.trim(),
          "password": _passwordController.text.trim(),
        },
      );

      print("Register Response: ${response.body}");
      final data = jsonDecode(response.body);

      if (data["success"]) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Registration successful!")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ ${data["message"]}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Full Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _mobileController,
              decoration: InputDecoration(
                labelText: "Mobile Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: register,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
              ),
              child: const Text(
                "Sign Up",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// After successful login




class UserDashboard extends StatefulWidget {
  final String email; // email passed from login
  const UserDashboard({super.key, required this.email});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int totalRides = 0;
  double totalDistance = 0;
  double averageDuration = 0;

  @override
  void initState() {
    super.initState();
    _loadUserStats();
  }

  // Reload stats from API
  Future<void> _loadUserStats() async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.getRoute),
        body: {'email': widget.email},
      );

      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        final routes = List<Map<String, dynamic>>.from(data['routes']);
        double distanceSum = 0;
        double durationSum = 0;

        for (var route in routes) {
          distanceSum += double.tryParse(route['distance'] ?? '0') ?? 0;
          durationSum += double.tryParse(route['duration'] ?? '0') ?? 0;
        }

        double avgDuration = routes.isNotEmpty ? durationSum / routes.length : 0;

        setState(() {
          totalRides = routes.length;
          totalDistance = distanceSum;
          averageDuration = avgDuration;
        });
      }
    } catch (e) {
      debugPrint("Error loading user stats: $e");
    }
  }

  // Menu navigation
  void _handleMenuSelection(String value) async {
    switch (value) {
      case 'recent':
        await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RouteHistoryScreen(email: widget.email)),
        );
        break;
      case 'specific':
        await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  EBikeSpecificRouteScreen(userEmail: widget.email)),
        );
        break;
      case 'settings':
        await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SettingsScreen(email: widget.email)),
        );
        break;
      case 'safety':
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RouteSafetyScreen()),
        );
        if (result == true) _loadUserStats();
        break;
    }

    // Automatically refresh stats when returning from another screen
    _loadUserStats();
  }


  @override
  Widget build(BuildContext context) {
    final username = widget.email.split('@')[0];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu, color: Colors.black),
              color: const Color(0xFFFEF7FF),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              onSelected: _handleMenuSelection,
              itemBuilder: (context) => const [
                PopupMenuItem(
                    value: 'recent', child: Text('RECENT ROUTE HISTORY')),
                PopupMenuItem(
                    value: 'specific', child: Text('E-BIKE SPECIFIC ROUTE')),
                PopupMenuItem(value: 'safety', child: Text('E-BIKE ROUTE SAFETY')),
                PopupMenuItem(value: 'settings', child: Text('SETTINGS')),
              ],
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FeedbackRequestScreen()),
                );
                _loadUserStats();
              },
              child: Row(
                children: const [
                  Text(
                    "Feedback & Reqs",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.emoji_emotions_outlined,
                      color: Colors.deepOrange, size: 18),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              _showLogoutConfirmationDialog(context); // pass the context here
            },
          ),
        ],
      ),
      // Pull-to-refresh added
      body: RefreshIndicator(
        onRefresh: _loadUserStats,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.deepOrange,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text("Welcome Back,", style: TextStyle(fontSize: 20, color: Colors.grey[700])),
                Text("$username!",
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                const SizedBox(height: 25),
                GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _DashboardCard(
                      title: "Total Rides",
                      body: "$totalRides rides",
                    ),
                    _DashboardCard(
                      title: "Distance Traveled",
                      body: "${totalDistance.toStringAsFixed(2)} km",
                    ),
                    _DashboardCard(
                      title: "Average Duration",
                      body: totalRides > 0
                          ? "${averageDuration.toStringAsFixed(0)} mins"
                          : "No data yet",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) async {
          switch (index) {
            case 0:
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        EBikeSpecificRouteScreen(userEmail: widget.email)),
              );
              break;
            case 1:
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        RouteHistoryScreen(email: widget.email)),
              );
              break;
            case 2:
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => CommunityScreen(username: username)),
              );
              break;
          }

          // Refresh stats when returning from any screen
          _loadUserStats();
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.directions_bike), label: 'Start Route'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Route History'),
          BottomNavigationBarItem(icon: Icon(Icons.forum), label: 'Community'),
        ],
      ),
    );
  }
}

// Dashboard Card Widget
class _DashboardCard extends StatelessWidget {
  final String title;
  final String body;
  const _DashboardCard({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(body, style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}











class FeedbackRequestScreen extends StatefulWidget {
  const FeedbackRequestScreen({super.key});

  @override
  State<FeedbackRequestScreen> createState() => _FeedbackRequestScreenState();
}

class _FeedbackRequestScreenState extends State<FeedbackRequestScreen> {
  bool allowContact = false;
  String? attachedFilePath;
  String? attachedFileName;
  String selectedType = "";
  final TextEditingController _messageController = TextEditingController();

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        attachedFilePath = result.files.single.path;
        attachedFileName = result.files.single.name;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File attached: ${result.files.single.name}')),
      );
    }
  }

  Future<void> _submitFeedback() async {
    if (_messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your message.")),
      );
      return;
    }

    try {

      final url = Uri.parse(ApiEndpoints.submitFeed);

      var request = http.MultipartRequest('POST', url);
      request.fields['type'] = selectedType.isEmpty ? "General" : selectedType;
      request.fields['message'] = _messageController.text.trim();
      request.fields['allow_contact'] = allowContact ? "1" : "0";

      if (attachedFilePath != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'attachment',
          attachedFilePath!,
        ));
      }

      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(resBody);
        if (data["success"] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Your feedback has been submitted!")),
          );
          setState(() {
            selectedType = "";
            _messageController.clear();
            attachedFilePath = null;
            attachedFileName = null;
            allowContact = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed: ${data["message"] ?? "Unknown error"}")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Server error! Please try again.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error submitting feedback: $e")),
      );
    }
  }

  void _setType(String type) {
    setState(() {
      selectedType = type;
      _messageController.text = "$type: ";
      _messageController.selection = TextSelection.fromPosition(
        TextPosition(offset: _messageController.text.length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback & Request'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Type', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: () => _setType("Suggestion"),
                    child: const Text("I have a suggestion"),
                  ),
                  ElevatedButton(
                    onPressed: () => _setType("Bug Report"),
                    child: const Text("I found a bug"),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Your Message', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Please describe your feedback or request...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              const Text('Attach File (Optional)', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.attach_file),
                    label: const Text('Attach File'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      attachedFileName ?? 'No file selected',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(child: Text('Allow us to contact you')),
                  Switch(
                    value: allowContact,
                    onChanged: (bool value) {
                      setState(() {
                        allowContact = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF9800),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  onPressed: _submitFeedback,
                  child: const Text('Submit'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}











class CommunityScreen extends StatefulWidget {
  final String username;
  const CommunityScreen({super.key, required this.username});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  List<Map<String, dynamic>> posts = [
    {
      'author': 'Jane Doe',
      'title': 'Best E-Bike Routes in Manila?',
      'content':
      'Hey everyone! Just got a new e-bike and looking for recommendations on the best routes in Manila...',
      'likes': '45',
      'comments': '12',
    },
    {
      'author': 'CommuteKing',
      'title': 'Any Group Rides This Weekend?',
      'content':
      'Looking for any group rides happening this weekend! Let me know if anyone is interested...',
      'likes': '30',
      'comments': '7',
    },
  ];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse(ApiEndpoints.getPosts));
      final data = jsonDecode(response.body);

      if (data["success"] == true && data["posts"] != null) {
        final backendPosts =
        List<Map<String, dynamic>>.from(data["posts"] as List);

        // Combine backend posts and default ones (backend first)
        setState(() {
          posts = [...backendPosts, ...posts];
        });
      } else {
        print("⚠️ No posts found in database");
      }
    } catch (e) {
      print("Fetch error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _addNewPost(Map<String, dynamic> newPost) async {
    setState(() {
      posts.insert(0, newPost);
    });
    await _fetchPosts(); // refresh to include from DB
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Community and Forums',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchPosts,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search Topics",
                      filled: true,
                      fillColor: const Color(0xFFFEF7FF),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(),
                    )
                  else
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 20,
                                      backgroundImage:
                                      AssetImage('assets/profile.jpg'),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      post['author'] ?? 'Anonymous',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  post['title'] ?? '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Text(post['content'] ?? ''),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.thumb_up_alt,
                                        size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(post['likes']?.toString() ?? '0'),
                                    const SizedBox(width: 16),
                                    const Icon(Icons.comment,
                                        size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(post['comments']?.toString() ?? '0'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 10),

                  // ✅ SIDE-BY-SIDE BUTTONS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text(
                            "Create a Post",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            final newPost =
                            await Navigator.push<Map<String, dynamic>>(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CreatePostScreen(username: widget.username),
                              ),
                            );
                            if (newPost != null) {
                              _addNewPost(newPost);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.email, color: Colors.white),
                          label: const Text(
                            'Contact Us',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ContactUsScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CreatePostScreen extends StatefulWidget {
  final String username;
  const CreatePostScreen({super.key, required this.username});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isAnonymous = false;
  bool _isPosting = false;

  Future<void> _submitPost() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    setState(() => _isPosting = true);

    try {
      final response = await http.post(Uri.parse(ApiEndpoints.createPost),
        body: {
          "author": _isAnonymous ? "Anonymous" : widget.username,
          "title": _titleController.text.trim(),
          "content": _contentController.text.trim(),
        },
      );

      final data = jsonDecode(response.body);
      if (data["success"]) {
        Navigator.pop(context, {
          "author": _isAnonymous ? "Anonymous" : widget.username,
          "title": _titleController.text,
          "content": _contentController.text,
          "likes": "0",
          "comments": "0",
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ ${data["message"]}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Error posting: $e")),
      );
    } finally {
      setState(() => _isPosting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Post")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Content",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Post as Anonymous"),
                Switch(
                  value: _isAnonymous,
                  onChanged: (value) {
                    setState(() => _isAnonymous = value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isPosting ? null : _submitPost,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: _isPosting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                "Post",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}








class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;



  Future<void> _submitForm() async {
    final name = _nameController.text.trim();
    final surname = _surnameController.text.trim();
    final email = _emailController.text.trim();
    final message = _messageController.text.trim();

    if (name.isEmpty || surname.isEmpty || email.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please fill in all fields")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.userContact),
        body: {
          "name": name,
          "surname": surname,
          "email": email,
          "message": message,
        },
      );

      final data = jsonDecode(response.body);
      if (data["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ ${data["message"]}")),
        );
        _nameController.clear();
        _surnameController.clear();
        _emailController.clear();
        _messageController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ ${data["message"]}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Failed to send message: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter your first name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Surname', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _surnameController,
                decoration: const InputDecoration(
                  hintText: 'Enter your last name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Enter your email address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Message', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _messageController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Enter your message here',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF9800),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Submit'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
////
