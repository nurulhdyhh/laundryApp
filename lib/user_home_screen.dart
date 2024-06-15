import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserHomeScreen extends StatefulWidget {
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref().child('orders');

  List<Map<dynamic, dynamic>> userOrders = [];

  @override
  void initState() {
    super.initState();
    _fetchUserOrders();
  }

  void _fetchUserOrders() {
    if (user != null) {
      databaseReference
          .orderByChild('userId')
          .equalTo(user!.uid)
          .onValue
          .listen((event) {
        final data = event.snapshot.value;
        if (data != null) {
          setState(() {
            final Map<dynamic, dynamic> ordersMap =
                data as Map<dynamic, dynamic>;
            userOrders = ordersMap.values
                .map((order) => order as Map<dynamic, dynamic>)
                .toList();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      body: userOrders.isEmpty
          ? Center(child: Text('No orders found'))
          : ListView.builder(
              itemCount: userOrders.length,
              itemBuilder: (context, index) {
                final order = userOrders[index];
                return Card(
                  child: ListTile(
                    title: Text('Order ${index + 1}'),
                    subtitle: Text(
                      'Total: Rp ${order['totalPayable']} - Status: ${order['status']}',
                    ),
                  ),
                );
              },
            ),
    );
  }
}
