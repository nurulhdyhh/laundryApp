import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutterdemo/detail_screen.dart';
import 'package:flutterdemo/main.dart';

class ShoppingCartScreen extends StatefulWidget {
  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref().child('orders');

  @override
  Widget build(BuildContext context) {
    double totalAmount = cartItems.fold(0.0, (sum, item) => sum + item.price);
    double deliveryCharge = 7000;
    double totalPayable = totalAmount + deliveryCharge;

    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang'),
        backgroundColor: Colors.lightBlue[100],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 16.0),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.local_laundry_service,
                          color: Colors.lightBlue),
                      title: Text(item.laundryOption),
                      subtitle: Text('${item.kg} KG'),
                      trailing: Text('Rp ${item.price.toStringAsFixed(0)}'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomSheet:
          _buildBottomSheet(context, totalAmount, deliveryCharge, totalPayable),
    );
  }

  Widget _buildBottomSheet(BuildContext context, double totalAmount,
      double deliveryCharge, double totalPayable) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Total: Rp ${totalAmount.toStringAsFixed(0)}',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            'Biaya Pengiriman: Rp ${deliveryCharge.toStringAsFixed(0)}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Total: Rp ${totalPayable.toStringAsFixed(0)}',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              if (cartItems.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Keranjang belanja kosong')),
                );
              } else {
                _placeOrder(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue, // Background color
              padding: EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Continue', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  void _placeOrder(BuildContext context) {
    double totalAmount = cartItems.fold(0.0, (sum, item) => sum + item.price);
    double deliveryCharge = 7000;
    double totalPayable = totalAmount + deliveryCharge;

    // Hitung total berat (jumlah KG)
    int totalKg = cartItems.fold(0, (sum, item) => sum + item.kg);

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
      'totalKg': totalKg, // Tambahkan total berat ke orderData
    };

    databaseReference.push().set(orderData).then((_) {
      setState(() {
        cartItems.clear(); // Membersihkan keranjang setelah berhasil memesan
      });
      _showOrderSuccessDialog(context);
    }).catchError((error) {
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
