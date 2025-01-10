import 'package:flutter/material.dart';
import 'payment_method_page.dart'; // Import the PaymentMethodPage
import 'login_screen.dart'; // Import the LoginScreen
import 'hourly.dart';
import 'weekly.dart';


class PaymentDetailsPage extends StatefulWidget {
  final String fullName;
  final String matricsNumber;
  final String phoneNumber;
  final String totalPrice;
  final String previousPage;


  const PaymentDetailsPage({
    super.key,
    required this.fullName,
    required this.matricsNumber,
    required this.phoneNumber,
    required this.totalPrice,
    required this.previousPage,
  });


  @override
  State<PaymentDetailsPage> createState() => _PaymentDetailsPageState();
}


class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  int _currentIndex = 0; // Manage the current index for BottomNavigationBar


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'lib/images/payment.png', // Replace with your image asset path
              fit: BoxFit.cover, // Ensures the image covers the entire background
            ),
          ),
          // Main content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 340),
                  const Text(
                    'Payment Details:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Full Name: ${widget.fullName}',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Matrics Number: ${widget.matricsNumber}',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Phone Number: ${widget.phoneNumber}',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Total Price: ${widget.totalPrice}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 80),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to PaymentMethodPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentMethodPage(totalPrice: widget.totalPrice),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(200, 50), // Width: 200, Height: 50
                        backgroundColor: const Color(0xFFDF5453), // Light beige button
                        foregroundColor: Colors.white, // Black text on button
                        textStyle: const TextStyle(fontSize: 20)
                    ),
                    child: const Text('Checkout'),
                  ),
                ],
              ),
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

          if (indexOfItem == 0) {
            // Navigate to Home (You can change this if needed)
            Navigator.pop(context);
          } else if (indexOfItem == 1) {
            // Navigate to HourlyPage or WeeklyPage based on the previousPage value
            if (widget.previousPage == 'Hourly') {
              // Navigate to HourlyPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HourlyFormPage(), // Navigate to HourlyPage
                ),
              );
            } else if (widget.previousPage == 'Weekly') {
              // Navigate to WeeklyPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WeeklyFormPage(), // Navigate to WeeklyPage
                ),
              );
            }
          } else if (indexOfItem == 2) {
            // Logout logic
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Logging out...')),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false, // Remove all previous routes
            );
          }
        },
      ),
    );
  }
}