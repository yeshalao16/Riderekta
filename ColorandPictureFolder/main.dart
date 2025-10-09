import 'package:flutter/material.dart';

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

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
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
            // TabBar for top tabs
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
            // TabBarView for corresponding content
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
      // Bottom Navigation Bar for 'Start Route', 'Route History', 'Community'
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Initially set to 'Start Route'
        onTap: (index) {
          setState(() {
            // Set the index for the bottom tabs
            // You can implement navigation for each tab here
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SpecificRouteScreen()),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RouteHistoryScreen()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CommunityScreen()),
                );
                break;
            }
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bike),
            label: 'Start Route', // First Tab
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Route History', // Second Tab
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: 'Community', // Third Tab
          ),
        ],
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
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                "Safe Paths",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const Text(
              "Dedicated Cycling Lanes, Low-Traffic Roads",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Expanded(
              child: ListView(
                children: [
                  _buildSafeRouteTile(context, 'Safe Commuter Path', 'Dedicated Cycling Lane', 'Low'),
                  _buildSafeRouteTile(context, 'Downtown E-Bike Lane', 'Low-Traffic Road', 'Medium'),
                  _buildSafeRouteTile(context, 'Riverside Path', 'Dedicated Cycling Lane', 'Low'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafeRouteTile(BuildContext context, String routeName, String routeType, String riskLevel) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      title: Text(routeName, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('Type: $routeType'),
      trailing: Text('Risk: $riskLevel', style: TextStyle(color: _getRiskColor(riskLevel))),
      onTap: () {
        // Simulate real-time risk update
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Updating real-time risk for $routeName')),
        );
      },
    );
  }

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel) {
      case 'Low':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      case 'High':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}


class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

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
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Add functionality for search here
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
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
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // Community Post 1
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage('assets/profile.jpg'),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Jane Doe',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Best E-Bike Routes in Manila?',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Hey everyone! Just got a new e-bike and looking for recommendations on the best routes in Manila...',
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: const [
                              Icon(Icons.thumb_up_alt, size: 16, color: Colors.grey),
                              SizedBox(width: 4),
                              Text('45'),
                              SizedBox(width: 16),
                              Icon(Icons.comment, size: 16, color: Colors.grey),
                              SizedBox(width: 4),
                              Text('12'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Community Post 2
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage('assets/profile.jpg'),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'CommuteKing',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Any Group Rides This Weekend?',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Looking for any group rides happening this weekend! Let me know if anyone is interested...',
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: const [
                              Icon(Icons.thumb_up_alt, size: 16, color: Colors.grey),
                              SizedBox(width: 4),
                              Text('30'),
                              SizedBox(width: 16),
                              Icon(Icons.comment, size: 16, color: Colors.grey),
                              SizedBox(width: 4),
                              Text('7'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Bottom Action Button (Contact Us, Create Post)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to 'Contact Us' screen or show a dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Contact Us'),
                            content: const Text('Email us at support@riderekta.com for assistance.'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Contact Us',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to 'Create Post' screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CreatePostScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Create a Post',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle post submission
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Your post has been created!')),
                );
              },
              child: const Text('Submit Post'),
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
    return const Center(
      child: Text(
        "Welcome to Riderekta – Safe e-bike routes, every time.",
        style: TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
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
        child: Text("Your recent routes will appear here.",
            style: TextStyle(fontSize: 16)),
      ),
    );
  }
}

class SpecificRouteScreen extends StatefulWidget {
  const SpecificRouteScreen({super.key});

  @override
  State<SpecificRouteScreen> createState() => _SpecificRouteScreenState();
}

class _SpecificRouteScreenState extends State<SpecificRouteScreen> {
  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();
  String? calculatedRoute;

  void _calculateRoute() {
    final start = startController.text.trim();
    final end = endController.text.trim();

    if (start.isEmpty || end.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both locations.")),
      );
      return;
    }

    setState(() {
      calculatedRoute =
      "Safest and most efficient route from '$start' to '$end' calculated.\n"
          "Avoiding highways and unsafe roads.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("E-Bike Specific Route")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Plan Your E-Bike Trip",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: startController,
                decoration: InputDecoration(
                  labelText: "Starting Location",
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: endController,
                decoration: InputDecoration(
                  labelText: "Drop-off Location",
                  prefixIcon: const Icon(Icons.flag),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _calculateRoute,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                icon: const Icon(Icons.directions_bike, color: Colors.white),
                label: const Text(
                  "Calculate Safe Route",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 30),
              if (calculatedRoute != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF7FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.deepPurple.shade100),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Route Summary:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(calculatedRoute!),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController emailController = TextEditingController(text: 'user@example.com');
  final TextEditingController mobileController = TextEditingController(text: '123-456-7890');
  final TextEditingController passwordController = TextEditingController(text: 'password123');
  bool notifications = true;
  bool privacy = true;

  void _saveProfile() {
    setState(() {
      // Simulating saving data
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile updated")));
    });
  }

  void _toggleNotifications(bool value) {
    setState(() {
      notifications = value;
    });
  }

  void _togglePrivacy(bool value) {
    setState(() {
      privacy = value;
    });
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
                decoration: const InputDecoration(labelText: "Email"),
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
                child: const Text("Save Changes"),
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

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Login Page",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: "Username",
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              child:
              const Text("Login", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
