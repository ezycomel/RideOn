import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'trackhour.dart';
import 'trackweek.dart';
import 'profile.dart';
import 'admin_page.dart';


class PaymentTrackingPage extends StatefulWidget {
  const PaymentTrackingPage({Key? key}) : super(key: key);


  @override
  _PaymentTrackingPageState createState() => _PaymentTrackingPageState();
}


class _PaymentTrackingPageState extends State<PaymentTrackingPage> {
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
                    MaterialPageRoute(builder: (context) => HourlyTrackingPage()),
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
            Positioned(
              top: MediaQuery.of(context).size.height * 0.72, // Adjust position to match the second bicycle
              left: MediaQuery.of(context).size.width * 0.05, // Center horizontally
              right: MediaQuery.of(context).size.width * 0.05, // Center horizontally
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to HourlyFormPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WeeklyTrackingPage()),
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
              // Navigate to home
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminPage()),
              );
            } else if (indexOfItem == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminPage()),
              );
            } else if (indexOfItem == 2) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logging out...')),
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (Route<dynamic> route) => false, // Remove all previous routes to prevent back navigation
              );
            }
          },
        ),
      ),
    );
  }
}