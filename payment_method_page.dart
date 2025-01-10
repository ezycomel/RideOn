import 'package:flutter/material.dart';
import 'cash_payment_page.dart';  // Import Cash Payment Page
import 'debit_card_payment_page.dart';  // Import Debit Card Payment Page
import 'home_screen.dart';  // Import Home Screen
import 'login_screen.dart';  // Import Login Screen


class PaymentMethodPage extends StatefulWidget {
  final String totalPrice;


  const PaymentMethodPage({super.key, required this.totalPrice});


  @override
  _PaymentMethodPageState createState() => _PaymentMethodPageState();
}


class _PaymentMethodPageState extends State<PaymentMethodPage> {
  int _currentIndex = 0;  // Manage current index for BottomNavigationBar


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,  // Ensure the background image fills the entire screen
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'lib/images/choosepay.png', // Replace with your image path
              fit: BoxFit.cover, // Ensure the image covers the screen
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 275),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Cash Payment Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CashPaymentPage(totalPrice: widget.totalPrice),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(200, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Cash', style: TextStyle(color: Colors.black, fontSize: 20)),
                ),
                const SizedBox(height: 160),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Debit Card Payment Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DebitCardPaymentPage(totalPrice: widget.totalPrice),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(200, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Debit Card', style: TextStyle(color: Colors.black, fontSize: 20)),
                ),
              ],
            ),
          ),
        ],
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (indexOfItem == 1) {
            Navigator.pop(context);  // Go back to the previous screen
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