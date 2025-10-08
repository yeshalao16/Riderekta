import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// 🔗 Backend API URL
const String apiUrl = "http://10.0.2.2/riderekta/login.php";

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'recent':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RouteHistoryScreen()),
        );
        break;
      case 'specific':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SpecificRouteScreen()),
        );
        break;
      case 'safety':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RouteSafetyScreen()),
        );
        break;
      case 'settings':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsScreen()),
        );
        break;
    }
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
        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.menu, color: Colors.black),
          color: const Color(0xFFFEF7FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          onSelected: _handleMenuSelection,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'recent',
              child: Text('RECENT ROUTE HISTORY'),
            ),
            const PopupMenuItem(
              value: 'specific',
              child: Text('E-BIKE SPECIFIC ROUTE'),
            ),
            const PopupMenuItem(
              value: 'safety',
              child: Text('E-BIKE ROUTE SAFETY'),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: Text('SETTINGS'),
            ),
          ],
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.account_circle, color: Colors.black),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.deepPurple,
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
              labelColor: Colors.deepPurple,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.deepPurple,
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

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double horizontalPadding = 16.0;
    final double containerMargin = 4.0;
    final double spacing = 8.0;
    final double totalHorizontal = (horizontalPadding * 2) + (containerMargin * 2) + spacing;
    final double imageWidth = (screenWidth - totalHorizontal) / 2;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 30),
          const Text(
            "RIDEREKTA",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: Colors.deepPurple,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Subtitle",
            style: TextStyle(color: Colors.grey, fontSize: 16),
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
                    'assets/ebike1.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Eco-Friendly Navigation',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Get safe and legal e-bike routes that avoid highways and unsafe roads.',
                    style: TextStyle(fontSize: 12),
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
                    'assets/ebike2.png',
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Image.asset(
                    'assets/ebike3.png',
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Continuous Improvement: Give feedback directly and help us improve Riderekta for everyone.',
              textAlign: TextAlign.center,
              style: TextStyle(
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

class OurTeamScreen extends StatelessWidget {
  const OurTeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Meet our awesome team!",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class BenefitsScreen extends StatelessWidget {
  const BenefitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Enjoy the benefits of safe, eco-friendly e-bike navigation.",
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}

class RouteHistoryScreen extends StatelessWidget {
  const RouteHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recent Route History")),
      body: const Center(
        child: Text("Your recent routes will appear here.", style: TextStyle(fontSize: 16)),
      ),
    );
  }
}

class SpecificRouteScreen extends StatelessWidget {
  const SpecificRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("E-Bike Specific Route")),
      body: const Center(
        child: Text("Plan a specific e-bike route here.", style: TextStyle(fontSize: 16)),
      ),
    );
  }
}

class RouteSafetyScreen extends StatelessWidget {
  const RouteSafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("E-Bike Route Safety")),
      body: const Center(
        child: Text("Check route safety information here.", style: TextStyle(fontSize: 16)),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: const Center(
        child: Text("Customize your Riderekta experience.", style: TextStyle(fontSize: 16)),
      ),
    );
  }
}

//  Login Screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> login() async {
    try {
      // ✅ send as form-data (NOT JSON) to match PHP $_POST
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "email": _emailController.text.trim(),
          "password": _passwordController.text.trim(),
        },
      );

      // Debugging: check what the backend actually returns
      print("Response: ${response.body}");

      final data = jsonDecode(response.body);

      if (data["success"]) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Login successful!")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NextPage()),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple),
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ Placeholder page shown after successful login
class NextPage extends StatelessWidget {
  const NextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Welcome")),
      body: const Center(
        child: Text(
          "🎉 You have successfully logged in!",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
