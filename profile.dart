import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Initialize text controllers with default values
  final TextEditingController _fullNameController =
  TextEditingController(text: 'John Doe');
  final TextEditingController _matricsNumberController =
  TextEditingController(text: '123456789');
  final TextEditingController _phoneNumberController =
  TextEditingController(text: '0123456789');

  final CollectionReference _userProfileCollection =
  FirebaseFirestore.instance.collection('UserProfile');

  int _currentIndex = 0; // Add this line to define _currentIndex

  Future<void> _saveUserProfile() async {
    try {
      // Save the data to Firebase
      await _userProfileCollection.doc('currentUser').set({
        'fullName': _fullNameController.text,
        'matricsNumber': _matricsNumberController.text,
        'phoneNumber': _phoneNumberController.text,
      });

      // Show success message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFFF3EFE0),
            title: const Text(
              'Profile Updated',
              style: TextStyle(color: Colors.black),
            ),
            content: Text(
              'Full Name: ${_fullNameController.text}\n'
                  'Matrics Number: ${_matricsNumberController.text}\n'
                  'Phone Number: ${_phoneNumberController.text}',
              style: const TextStyle(color: Colors.black),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving profile: $e')),
      );
    }
  }

  Future<void> _loadUserProfile() async {
    try {
      DocumentSnapshot snapshot =
      await _userProfileCollection.doc('currentUser').get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          _fullNameController.text = data['fullName'] ?? '';
          _matricsNumberController.text = data['matricsNumber'] ?? '';
          _phoneNumberController.text = data['phoneNumber'] ?? '';
        });
      }
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserProfile(); // Load data when the page is opened
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0c7c59),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/profile.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Center(  // Wrap the Column inside Center to align everything in the middle
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  // Center the column vertically
            crossAxisAlignment: CrossAxisAlignment.center,  // Center the items horizontally
            children: [
              const SizedBox(height: 260),
              const Text(
                'Personal Information:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Container(
                width: 300, // Set the width of the text fields
                child: TextField(
                  controller: _fullNameController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Color(0xFFF3EFE0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 300, // Set the width of the text fields
                child: TextField(
                  controller: _matricsNumberController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: 'Matrics Number',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Color(0xFFF3EFE0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 300, // Set the width of the text fields
                child: TextField(
                  controller: _phoneNumberController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Color(0xFFF3EFE0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveUserProfile, // Call the save function
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Set the background color to red
                    foregroundColor: Colors.black, // Set the text color to black
                  ),
                  child: const Text('Save Changes'),
                ),
              )
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
