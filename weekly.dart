import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'paymentdetailspage.dart'; // Import PaymentDetailsPage
import 'login_screen.dart';
import 'home_screen.dart';


class WeeklyFormPage extends StatefulWidget {
  const WeeklyFormPage({super.key});


  @override
  _WeeklyFormPageState createState() => _WeeklyFormPageState();
}


class _WeeklyFormPageState extends State<WeeklyFormPage> {
  int _currentIndex = 0;


  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController matricsNumberController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();


  DateTime? startDate;
  DateTime? endDate;


  // Function to pick a date
  Future<void> pickDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );


    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
          // Reset endDate if it's earlier than startDate
          if (endDate != null && endDate!.isBefore(startDate!)) {
            endDate = null;
          }
        } else {
          endDate = picked;
        }
      });
    }
  }


  // Function to calculate the number of weeks between dates
  int calculateWeeks() {
    if (startDate == null || endDate == null) {
      return 0;
    }
    final difference = endDate!.difference(startDate!).inDays;
    return (difference / 7).ceil(); // Rounds up to the nearest week
  }


  // Function to add user data to Firestore
  void submitData() async {
    final String fullName = fullNameController.text;
    final String matricsNumber = matricsNumberController.text;
    final String phoneNumber = phoneNumberController.text;
    final int weeks = calculateWeeks();
    final String totalPrice = 'RM${weeks * 7}'; // Assume RM7 per week


    if (weeks <= 0 || startDate == null || endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select valid dates.')),
      );
      return;
    }


    try {
      await FirebaseFirestore.instance.collection('Weekly').add({
        'Full Name': fullName,
        'Matrics Number': matricsNumber,
        'Phone Number': phoneNumber,
        'Start Date': startDate,
        'End Date': endDate,
        'Weeks of rental': weeks,
        'Total Price': totalPrice,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('User data added to Firestore successfully!');
    } catch (error) {
      print('Error adding user data to Firestore: $error');
    }


    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentDetailsPage(
          fullName: fullName,
          matricsNumber: matricsNumber,
          phoneNumber: phoneNumber,
          totalPrice: totalPrice,
          previousPage: 'Weekly',
        ),
      ),
    );
  }


  // Helper widget to build date picker rows
  Widget buildDateRow(String label, DateTime? date, bool isStartDate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.68, // Adjust box width
          child: TextFormField(
            readOnly: true,
            controller: TextEditingController(
              text: date != null ? DateFormat('dd-MM-yyyy').format(date) : '',
            ),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: Colors.black),
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: const Color(0x80FFFFFF),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.calendar_today, color: Colors.black),
          onPressed: () => pickDate(context, isStartDate),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/weekly.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 170),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: fullNameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color(0x80FFFFFF),
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: matricsNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Matrics Number',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color(0x80FFFFFF),
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: phoneNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color(0x80FFFFFF),
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 20),
                buildDateRow('Start Date', startDate, true),
                const SizedBox(height: 20),
                buildDateRow('End Date', endDate, false),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: submitData,
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 50),
                    backgroundColor: const Color(0xFFDF5453),
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: const Text('Confirm'),
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



