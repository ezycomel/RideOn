import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_page.dart';
import 'payment_tracking_page.dart';
import 'login_screen.dart';

class WeeklyTrackingPage extends StatefulWidget {
  @override
  _WeeklyTrackingPageState createState() => _WeeklyTrackingPageState();
}

class _WeeklyTrackingPageState extends State<WeeklyTrackingPage> {
  final CollectionReference weeklyCollection =
  FirebaseFirestore.instance.collection('Weekly');

  int _currentIndex = 0; // Track the current index of the BottomNavigationBar
  String _selectedFilter = 'All Data'; // Default filter

  Stream<QuerySnapshot> _getFilteredStream() {
    final now = DateTime.now();
    if (_selectedFilter == 'Last 7 Days') {
      final last7Days = now.subtract(Duration(days: 7));
      return weeklyCollection
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(last7Days))
          .orderBy('createdAt', descending: true)
          .snapshots();
    } else if (_selectedFilter == 'Last 30 Days') {
      final last30Days = now.subtract(Duration(days: 30));
      return weeklyCollection
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(last30Days))
          .orderBy('createdAt', descending: true)
          .snapshots();
    } else {
      return weeklyCollection.orderBy('createdAt', descending: true).snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weekly Rentals Data',
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
              isExpanded: true,
              items: [
                'All Data',
                'Last 7 Days',
                'Last 30 Days'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFilter = newValue!;
                });
              },
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
                            Text(
                              'Start Date: ${data['Start Date'] != null ? (data['Start Date'] as Timestamp).toDate().toLocal().toString().split(' ')[0] : 'N/A'}',
                            ),
                            Text(
                              'End Date: ${data['End Date'] != null ? (data['End Date'] as Timestamp).toDate().toLocal().toString().split(' ')[0] : 'N/A'}',
                            ),
                            Text('Weeks of Rental: ${data['Weeks of rental'] ?? 0}'),
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
                  (Route<dynamic> route) => false, // Remove all previous routes
            );
          }
        },
      ),
    );
  }
}
