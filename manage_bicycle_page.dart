import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';
import 'admin_page.dart';

class ManageBicyclePage extends StatefulWidget {
  const ManageBicyclePage({Key? key}) : super(key: key);

  @override
  _ManageBicyclePageState createState() => _ManageBicyclePageState();
}

class _ManageBicyclePageState extends State<ManageBicyclePage> {
  int totalBicycles = 10;
  int totalAvailable = 8;
  int bicyclesToRemove = 0;
  int _currentIndex = 0;

  final CollectionReference adminCollection =
  FirebaseFirestore.instance.collection('admin');

  @override
  void initState() {
    super.initState();
    _fetchBicycleData();
  }

  void _fetchBicycleData() async {
    try {
      DocumentSnapshot snapshot = await adminCollection.doc('bicycleData').get();
      if (snapshot.exists) {
        setState(() {
          totalBicycles = snapshot.get('totalBicycles');
          totalAvailable = snapshot.get('totalAvailable');
          bicyclesToRemove = snapshot.get('bicyclesToRemove');
        });
      }
    } catch (error) {
      print('Error fetching bicycle data: $error');
    }
  }

  void _updateBicycleData() async {
    try {
      await adminCollection.doc('bicycleData').set({
        'totalBicycles': totalBicycles,
        'totalAvailable': totalAvailable,
        'bicyclesToRemove': bicyclesToRemove,
      });
      print('Bicycle data updated successfully!');
    } catch (error) {
      print('Error updating bicycle data: $error');
    }
  }

  void incrementTotalBicycles() {
    setState(() {
      totalBicycles++;
    });
    _updateBicycleData();
  }

  void decrementTotalBicycles() {
    if (totalBicycles > 0 && totalAvailable <= totalBicycles - 1) {
      setState(() {
        totalBicycles--;
      });
      _updateBicycleData();
    } else {
      _showErrorMessage('Cannot reduce total bicycles below available bicycles.');
    }
  }

  void incrementAvailableBicycles() {
    if (totalAvailable < totalBicycles) {
      setState(() {
        totalAvailable++;
      });
      _updateBicycleData();
    } else {
      _showErrorMessage('Cannot exceed total bicycles.');
    }
  }

  void decrementAvailableBicycles() {
    if (totalAvailable > 0) {
      setState(() {
        totalAvailable--;
      });
      _updateBicycleData();
    }
  }

  void incrementBicyclesToRemove() {
    if (bicyclesToRemove < totalBicycles) {
      setState(() {
        bicyclesToRemove++;
      });
    } else {
      _showErrorMessage('Cannot remove more than the total bicycles.');
    }
  }

  void decrementBicyclesToRemove() {
    if (bicyclesToRemove > 0) {
      setState(() {
        bicyclesToRemove--;
      });
    }
  }

  void applyBicycleRemoval() {
    if (bicyclesToRemove > 0) {
      setState(() {
        totalBicycles -= bicyclesToRemove;
        if (totalAvailable > totalBicycles) {
          totalAvailable = totalBicycles;
        }
        bicyclesToRemove = 0;
      });
      _updateBicycleData();
    } else {
      _showErrorMessage('No bicycles selected for removal.');
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/images/update.png'), // Ensure the image path is correct
          fit: BoxFit.cover, // Ensure the image covers the entire background
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Makes the scaffold background transparent
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 260),
                _buildCard(
                  child: _buildCounter(
                    label: 'Total Bicycles',
                    count: totalBicycles,
                    onIncrement: incrementTotalBicycles,
                    onDecrement: decrementTotalBicycles,
                  ),
                ),
                const SizedBox(height: 20),
                _buildCard(
                  child: _buildCounter(
                    label: 'Total Available Bicycles',
                    count: totalAvailable,
                    onIncrement: incrementAvailableBicycles,
                    onDecrement: decrementAvailableBicycles,
                  ),
                ),
                const SizedBox(height: 120),
                _buildCard(
                  child: _buildCounter(
                    label: 'Bicycles to Remove',
                    count: bicyclesToRemove,
                    onIncrement: incrementBicyclesToRemove,
                    onDecrement: decrementBicyclesToRemove,
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: applyBicycleRemoval,
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

            if (indexOfItem == 1) {
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
                    (Route<dynamic> route) => false,
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildCounter({
    required String label,
    required int count,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            IconButton(
              onPressed: onDecrement,
              icon: const Icon(Icons.remove),
            ),
            Text(
              count.toString(),
              style: const TextStyle(fontSize: 18),
            ),
            IconButton(
              onPressed: onIncrement,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}