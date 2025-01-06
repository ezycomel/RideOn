import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'login_screen.dart';


class CashPaymentPage extends StatefulWidget {
  final String totalPrice;


  const CashPaymentPage({super.key, required this.totalPrice});


  @override
  _CashPaymentPageState createState() => _CashPaymentPageState();
}


class _CashPaymentPageState extends State<CashPaymentPage> {
  int _currentIndex = 0;


  // Logout function
  Future<void> _logout(BuildContext context) async {
    try {
      // Sign out using FirebaseAuth
      await FirebaseAuth.instance.signOut();


      // Navigate to login page after sign out
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print("Error logging out: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/newcash.png'), // Add your image here
            fit: BoxFit.cover, // This will make the image cover the entire background
          ),
        ),
        child: Center( // Center the entire body content
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
              crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
              children: [
                const SizedBox(height: 200),
                // Display total price
                Text(
                  widget.totalPrice,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 150),
                // "Paid" button that triggers the logout and redirect
                ElevatedButton(
                  onPressed: () {
                    _logout(context); // Call the logout function
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDF5453),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(200, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Paid', style: TextStyle(color: Colors.white, fontSize: 24)),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
            icon: Icon(Icons.arrow_back),
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


          if (indexOfItem == 0) {
            // Navigate to home
          } else if (indexOfItem == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (indexOfItem == 2) {
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
    );
  }
}