import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_admin.dart'; // Pastikan Anda mengimpor halaman profil admin

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref().child('orders');

  List<Map<dynamic, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  void _fetchOrders() {
    databaseReference.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          orders = data.entries
              .map((entry) =>
                  {'key': entry.key, ...Map<String, dynamic>.from(entry.value)})
              .toList();
        });
      }
    });
  }

  void _updateOrderStatus(String orderKey, String newStatus) {
    databaseReference.child(orderKey).update({'status': newStatus}).then((_) {
      print("Status updated successfully!");
    }).catchError((error) {
      print("Failed to update status: $error");
    });
  }

  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    List<Map> filteredOrders = selectedCategory == 'All'
        ? orders
        : orders.where((item) => item['status'] == selectedCategory).toList();

    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              if (user != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileAdminScreen(user: user),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                _buildCategoryItem('All'),
                _buildCategoryItem('Pickup'),
                _buildCategoryItem('Queue'),
                _buildCategoryItem('Process'),
                _buildCategoryItem('Washing'),
                _buildCategoryItem('Dried'),
                _buildCategoryItem('Ironed'),
                _buildCategoryItem('Done'),
              ],
            ),
          ),
          Expanded(
            child: filteredOrders.isEmpty
                ? Center(
                    child: Text(
                      'No orders found in this category.',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return Card(
                        child: ListTile(
                          title: Container(
                            color: Colors.blue,
                            child: Text(
                              'Order ${index + 1}',
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          subtitle: Text(
                            'Total: Rp ${order['totalPayable']} - Status: ${order['status']}',
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildStatusButton(order['status']),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  _showUpdateStatusDialog(
                                      order['key'], order['status']);
                                },
                              ),
                            ],
                          ),
                        ),
                        color: Colors.black, // Background card color
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String category) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: selectedCategory == category
              ? Colors.blueAccent
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            category,
            style: TextStyle(
              color: selectedCategory == category ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusButton(String status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pickup':
        return Colors.orange;
      case 'Queue':
        return Colors.blue;
      case 'Process':
        return Colors.yellow;
      case 'Washing':
        return Colors.green;
      case 'Dried':
        return Colors.lightGreen;
      case 'Ironed':
        return Colors.purple;
      case 'Done':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  void _showUpdateStatusDialog(String orderKey, String currentStatus) {
    showDialog(
      context: context,
      builder: (context) {
        String newStatus = currentStatus;
        return AlertDialog(
          title: Text('Update Status'),
          content: DropdownButton<String>(
            value: newStatus,
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  newStatus = value;
                });
              }
            },
            items: <String>[
              'Pickup',
              'Queue',
              'Process',
              'Washing',
              'Dried',
              'Ironed',
              'Done'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Update'),
              onPressed: () {
                _updateOrderStatus(orderKey, newStatus);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
