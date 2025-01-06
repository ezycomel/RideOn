import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';
import 'login_screen.dart';


class DebitCardPaymentPage extends StatefulWidget {
  final String totalPrice;


  const DebitCardPaymentPage({super.key, required this.totalPrice});


  @override
  _DebitCardPaymentPageState createState() => _DebitCardPaymentPageState();
}


class _DebitCardPaymentPageState extends State<DebitCardPaymentPage> {
  String? selectedBank;
  int _currentIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Add SingleChildScrollView to handle overflow
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/images/card.png'), // Replace with your image asset path
              fit: BoxFit.cover, // Make sure the image covers the entire screen
              alignment: Alignment.center, // Align the image to the center of the screen
            ),
          ),
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: DropdownButtonFormField<String>(
                  value: selectedBank,
                  decoration: const InputDecoration(
                    labelText: 'Choose Your Bank',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  style: const TextStyle(color: Colors.black),
                  items: const [
                    DropdownMenuItem(value: 'Maybank', child: Text('Maybank (Malayan Banking Berhad)')),
                    DropdownMenuItem(value: 'CIMB', child: Text('CIMB Bank')),
                    DropdownMenuItem(value: 'Public Bank', child: Text('Public Bank')),
                    DropdownMenuItem(value: 'RHB', child: Text('RHB Bank')),
                    DropdownMenuItem(value: 'Hong Leong', child: Text('Hong Leong Bank')),
                    DropdownMenuItem(value: 'Affin', child: Text('Affin Bank')),
                    DropdownMenuItem(value: 'Bank Islam', child: Text('Bank Islam Malaysia Berhad')),
                    DropdownMenuItem(value: 'Bank Rakyat', child: Text('Bank Rakyat')),
                    DropdownMenuItem(value: 'AmBank', child: Text('AmBank (AMMB Holdings)')),
                    DropdownMenuItem(value: 'UOB', child: Text('UOB Malaysia (United Overseas Bank)')),
                    DropdownMenuItem(value: 'Standard Chartered', child: Text('Standard Chartered Bank Malaysia')),
                    DropdownMenuItem(value: 'OCBC', child: Text('OCBC Bank (Oversea-Chinese Banking Corporation)')),
                    DropdownMenuItem(value: 'Alliance', child: Text('Alliance Bank Malaysia')),
                    DropdownMenuItem(value: 'KLK Bank', child: Text('Kuala Lumpur Kepong Berhad (KLK) Bank')),
                    DropdownMenuItem(value: 'Bank Muamalat', child: Text('Bank Muamalat Malaysia')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedBank = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Card Number',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: TextFormField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(3),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    labelText: 'CVV',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: TextFormField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(5),
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9/]+')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Expiry Date (MM/YY)',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Payment Successful', style: TextStyle(color: Colors.white)),
                      content: Text(
                        'Total: ${widget.totalPrice}\nThank you for your payment.',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: const Color(0xFF0c7c59),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                          child: const Text('OK', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDF5453),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Confirm Payment', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ],
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