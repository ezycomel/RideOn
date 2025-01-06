import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'manage_bicycle_page.dart';
import 'payment_tracking_page.dart';


class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);


  @override
  State<AdminPage> createState() => _AdminPageState();
}


class _AdminPageState extends State<AdminPage> {
  int _currentIndex = 0;


  final List<Widget> _pages = [
    AdminHomePage(), // Placeholder for the Home page
    SearchPage(),    // Placeholder for the Search page
    const SizedBox(), // Logout functionality handled in onTap
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/images/adminfront.png"), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // The AppBar
          // Body content
          Positioned.fill(
            top: kToolbarHeight, // To avoid overlapping with AppBar
            child: _pages[_currentIndex],
          ),
          // BottomNavigationBar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              selectedItemColor: Colors.green,
              unselectedItemColor: Colors.white,
              backgroundColor: Colors.black,
              items: const [
                BottomNavigationBarItem(
                  label: "Home",
                  icon: Icon(Icons.home),
                ),
                BottomNavigationBarItem(
                  label: "Back",
                  icon: Icon(Icons.arrow_back), // back icon
                ),
                BottomNavigationBarItem(
                  label: "Logout",
                  icon: Icon(Icons.exit_to_app),
                ),
              ],
              onTap: (int indexOfItem) {
                setState(() {
                  _currentIndex = indexOfItem;
                });


                if (indexOfItem == 2) {
                  // Logout functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logging out...')),
                  );
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (Route<dynamic> route) => false,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}


class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center the buttons
        children: [
          const SizedBox(height: 260),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManageBicyclePage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              textStyle: const TextStyle(fontSize: 22),
            ),
            child: const Text(
              'Manage Bicycle',
              style: TextStyle(color: Colors.black), // Black font color
            ),
          ),
          const SizedBox(height: 250),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentTrackingPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              textStyle: const TextStyle(fontSize: 22),
            ),
            child: const Text(
              'Payment Tracking',
              style: TextStyle(color: Colors.black), // Black font color
            ),
          ),
        ],
      ),
    );
  }
}




class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Search functionality coming soon!',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

