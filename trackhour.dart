import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';
import 'payment_tracking_page.dart';
import 'admin_page.dart';

class HourlyTrackingPage extends StatefulWidget {
  @override
  _HourlyTrackingPageState createState() => _HourlyTrackingPageState();
}

class _HourlyTrackingPageState extends State<HourlyTrackingPage> {
  final CollectionReference hourlyCollection =
  FirebaseFirestore.instance.collection('Hourly');

  int _currentIndex = 0; // Track the current index of the BottomNavigationBar
  String _selectedFilter = "All"; // Default filter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hourly Rentals',
          style: TextStyle(color: Colors.white), // AppBar text color
        ),
        backgroundColor: Colors.black, // AppBar background color
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _selectedFilter,
              items: [
                DropdownMenuItem(value: "All", child: Text("Display All Data")),
                DropdownMenuItem(value: "7", child: Text("Last 7 Days")),
                DropdownMenuItem(value: "30", child: Text("Last 30 Days")),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
              },
              underline: Container(),
              isExpanded: true,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getFilteredStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No data available.'));
                }

                final List<DocumentSnapshot> docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Full Name: ${data['Full Name'] ?? 'N/A'}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text('Matrics Number: ${data['Matrics Number'] ?? 'N/A'}'),
                            Text('Phone Number: ${data['Phone Number'] ?? 'N/A'}'),
                            Text('Start Time: ${data['Start Time'] ?? 'N/A'}'),
                            Text('End Time: ${data['End Time'] ?? 'N/A'}'),
                            Text('Hours of Rental: ${data['Hours of rental'] ?? 0}'),
                            Text('Total Price: ${data['Total Price'] ?? 'N/A'}'),
                            Text(
                              'Created At: ${data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate().toString() : 'N/A'}',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Set the selected index
        selectedItemColor: Colors.green, // Set the color for the selected item
        unselectedItemColor: Colors.white, // Set the color for unselected items
        backgroundColor: Colors.black, // Set the background color
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "Back",
            icon: Icon(Icons.arrow_back), // Back icon
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

          if (indexOfItem == 0) {
            // Navigate to home
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminPage()),
            );
          } else if (indexOfItem == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PaymentTrackingPage()),
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
    );
  }

  Stream<QuerySnapshot> _getFilteredStream() {
    if (_selectedFilter == "7") {
      return hourlyCollection
          .where('createdAt', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days: 7)))
          .orderBy('createdAt', descending: true)
          .snapshots();
    } else if (_selectedFilter == "30") {
      return hourlyCollection
          .where('createdAt', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days: 30)))
          .orderBy('createdAt', descending: true)
          .snapshots();
    } else {
      return hourlyCollection.orderBy('createdAt', descending: true).snapshots();
    }
  }
}
