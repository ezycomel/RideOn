import 'package:flutter/material.dart';
import 'weekly.dart'; // Ensure WeeklyFormPage is imported
import 'hourly.dart'; // Ensure HourlyFormPage is imported
import 'profile.dart'; // Import ProfilePage (make sure it's created)
import 'login_screen.dart'; // Import the LoginScreen


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});


  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Track the current index of the selected tab


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/images/newchoose.png'), // Ensure the image path is correct
          fit: BoxFit.cover, // Ensure the image covers the entire background
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Makes the scaffold background transparent
        appBar: AppBar(
          backgroundColor: Colors.black.withOpacity(0), // Semi-transparent AppBar
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle),
              iconSize: 50, // Make the profile icon bigger
              color: Colors.white,
              onPressed: () {
                // Navigate to ProfilePage when the profile icon is clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()), // Navigate to ProfilePage
                );
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.4, // Adjust position to match the first bicycle
              left: MediaQuery.of(context).size.width * 0.05, // Center horizontally
              right: MediaQuery.of(context).size.width * 0.05, // Center horizontally
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to WeeklyFormPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WeeklyFormPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40), // Adjust button size
                  backgroundColor: Colors.white.withOpacity(0.8), // Button color
                  foregroundColor: Colors.black, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                ),
                child: const Text(
                  'Weekly',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.72, // Adjust position to match the second bicycle
              left: MediaQuery.of(context).size.width * 0.05, // Center horizontally
              right: MediaQuery.of(context).size.width * 0.05, // Center horizontally
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to HourlyFormPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HourlyFormPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40), // Adjust button size
                  backgroundColor: Colors.white.withOpacity(0.8), // Button color
                  foregroundColor: Colors.black, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                ),
                child: const Text(
                  'Hourly',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex, // Set the selected index
          selectedItemColor: Colors.green, // Set the color for the selected item
          unselectedItemColor: Colors.white, // Set the color for unselected items
          backgroundColor: Colors.black, // Set the background color to green
          items: const [
            BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: "Back",
              icon: Icon(Icons.arrow_back), //  back icon
            ),
            BottomNavigationBarItem(
              label: "Logout",
              icon: Icon(Icons.exit_to_app),
            ),
          ],
          onTap: (int indexOfItem) {
            setState(() {
              _currentIndex = indexOfItem; // Update the current index
            });


            // Handle navigation based on the selected tab index
            if (indexOfItem == 0) {
              // Home tab, you can show home screen content here or navigate to another page
            } else if (indexOfItem == 1) {
              // Search tab, navigate to a search page (if needed)
            } else if (indexOfItem == 2) {
              // Logout tab, handle logout functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logging out...')),
              );
              // Navigate to LoginScreen after logout
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()), // Navigate to LoginScreen
                    (Route<dynamic> route) => false, // Remove all previous routes to prevent back navigation
              );
            }
          },
        ),
      ),
    );
  }
}