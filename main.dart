import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'login_screen.dart';
import 'home_screen.dart'; // Assuming this is your home screen


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  // Initialize Firebase
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyC0XjDizqLdpbY67kYL0nNWwCPfzNsTO_0",
        authDomain: "rideon-ce21b.firebaseapp.com",
        projectId: "rideon-ce21b",
        storageBucket: "rideon-ce21b.firebasestorage.app",
        messagingSenderId: "1084713973217",
        appId: "1:1084713973217:web:b32156beb6ea4a14674ea0",
        measurementId: "G-6HDKL1705W",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }


  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modern Firebase Auth Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0c7c59), // Green background
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Arial', fontSize: 16, color: Colors.black),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SignUpScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const BottomNavExample(),
      },
    );
  }
}


class BottomNavExample extends StatefulWidget {
  const BottomNavExample({super.key});


  @override
  _BottomNavExampleState createState() => _BottomNavExampleState();
}


class _BottomNavExampleState extends State<BottomNavExample> {
  int _currentIndex = 0; // Tracks the selected tab index
  final List<Widget> _pages = [
    const HomeScreen(),
    const Center(
      child: Text(
        'Search Page',
        style: TextStyle(fontSize: 24, color: Colors.black),
      ),
    ),
    const Center(
      child: Text(
        'Profile Page',
        style: TextStyle(fontSize: 24, color: Colors.black),
      ),
    ),
  ];


  void _onLogout() {
    // Placeholder for logout functionality
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0c7c59), // Green background
          title: const Text(
            'Logout',
            style: TextStyle(color: Colors.black),
          ),
          content: const Text(
            'You have been logged out.',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: const Color(0xFFF3EFE0), // Button color
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Drawer Navigation Example",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFFF3EFE0), // Button color
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _pages[_currentIndex],
      drawer: Drawer(
        backgroundColor: const Color(0xFF0c7c59), // Drawer background
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF0c7c59),
              ),
              child: Text(
                'App Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Search'),
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: _onLogout, // Add logout functionality here
            ),
          ],
        ),
      ),
    );
  }
}
