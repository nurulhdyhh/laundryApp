import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutterdemo/detail_screen.dart';
import 'package:flutterdemo/main.dart';
// ignore: unused_import
import 'keranjang_belanja.dart';

class ShoppingCartScreen extends StatelessWidget {
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref().child('orders');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/add-to-cart');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                leading: Icon(Icons.local_laundry_service),
                title: Text(item.laundryOption),
                subtitle: Text('${item.kg} KG'),
                trailing: Text('Rp ${item.price.toStringAsFixed(0)}'),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    double totalAmount = cartItems.fold(0.0, (sum, item) => sum + item.price);
    double deliveryCharge = 7000;
    double totalPayable = totalAmount + deliveryCharge;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Total: Rp ${totalAmount.toStringAsFixed(0)}'),
          Text('Biaya Pengiriman: Rp ${deliveryCharge.toStringAsFixed(0)}'),
          Text('Total: Rp ${totalPayable.toStringAsFixed(0)}'),
          ElevatedButton(
            onPressed: () {
              print("Button pressed");
              if (cartItems.isEmpty) {
                print("Cart is empty");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Keranjang belanja kosong')),
                );
              } else {
                print("Cart has items, placing order...");
                _placeOrder(context);
              }
            },
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _placeOrder(BuildContext context) {
    double totalAmount = cartItems.fold(
      0.0,
      (sum, item) => sum + item.price,
    );
    double deliveryCharge = 7000;
    double totalPayable = totalAmount + deliveryCharge;

    Map<String, dynamic> orderData = {
      'items': cartItems
          .map((item) => {
                'laundryOption': item.laundryOption,
                'kg': item.kg,
                'price': item.price,
              })
          .toList(),
      'totalAmount': totalAmount,
      'deliveryCharge': deliveryCharge,
      'totalPayable': totalPayable,
      'status': 'Queue',
      'timestamp': DateTime.now().toIso8601String(),
    };

    print("Order data: $orderData");

    databaseReference.push().set(orderData).then((_) {
      cartItems.clear(); // Membersihkan keranjang setelah berhasil memesan
      _showOrderSuccessDialog(context);
    }).catchError((error) {
      print("Failed to save order: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to place order. Please try again.'),
        ),
      );
    });
  }

  void _showOrderSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pesanan Berhasil'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Pesanan Anda telah berhasil dilakukan.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LaundryScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
