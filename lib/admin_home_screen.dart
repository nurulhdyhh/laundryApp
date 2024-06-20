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
  List<Map<dynamic, dynamic>> filteredOrders = [];

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
              .map((entry) => {
                    'key': entry.key,
                    'orderNumber': entry.key, // Use the key as order number
                    ...Map<String, dynamic>.from(entry.value)
                  })
              .toList();
          _filterOrders(selectedCategory);
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

  void _filterOrders(String category) {
    setState(() {
      selectedCategory = category;
      if (category == 'All') {
        filteredOrders = orders;
      } else {
        filteredOrders =
            orders.where((item) => item['status'] == category).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 195, 237, 255),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Color.fromARGB(
                  162, 6, 37, 83)), // Set arrow icon color to white
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Admin Home',
          style: TextStyle(
            color: Color.fromARGB(162, 6, 37, 83), // Set text color to white
            fontWeight: FontWeight.bold, // Make text bold
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.account_circle,
              size: 40,
              color: const Color.fromARGB(
                  162, 6, 37, 83), // Corrected usage of Color.fromARGB
            ),
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
          SizedBox(height: 10), // Add space between AppBar and buttons
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
          SizedBox(height: 10), // Add space between buttons and content
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        margin: EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10), // Reduce margins
                        color: Color.fromARGB(255, 195, 237,
                            255), // Light blue color for the card
                        elevation:
                            3, // Reduce elevation to make the card smaller
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10), // Reduce padding
                          title: Text(
                            'Order ${orders.indexWhere((element) => element['key'] == order['key']) + 1}', // Use the original order number
                            style: TextStyle(
                              color: Color.fromARGB(255, 4, 23, 47),
                              fontSize: 16, // Reduce font size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Total: Rp ${order['totalPayable']} - Status: ${order['status']}',
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 48, 130),
                              fontSize: 14, // Reduce font size
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildStatusButton(order['status']),
                              IconButton(
                                icon: Icon(Icons.edit),
                                color: Colors.grey[600],
                                onPressed: () {
                                  _showUpdateStatusDialog(
                                      order['key'], order['status']);
                                },
                              ),
                            ],
                          ),
                        ),
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
        _filterOrders(category);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: EdgeInsets.symmetric(
            horizontal: 8), // Increase margin between buttons
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
    String newStatus = currentStatus;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Text('Update Status'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return DropdownButton<String>(
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
              );
            },
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
