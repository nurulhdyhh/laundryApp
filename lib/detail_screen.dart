import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutterdemo/keranjang_belanja.dart';

class OrderItem {
  final String laundryOption;
  final int kg;
  final double price;

  OrderItem({
    required this.laundryOption,
    required this.kg,
    required this.price,
  });
}

List<OrderItem> cartItems = [];

class DetailScreen extends StatelessWidget {
  final String name;
  final String rating;
  final String address;
  final String description;
  final String imageUrl;
  final String price;

  const DetailScreen({
    Key? key,
    required this.name,
    required this.rating,
    required this.address,
    required this.description,
    required this.imageUrl,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(name),
        backgroundColor: Colors.lightBlue[100],
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShoppingCartScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Rating: $rating', style: const TextStyle(fontSize: 16)),
                  Text(
                    price,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Alamat: $address', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              const Text(
                'Deskripsi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 24),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.lightBlue[300],
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    onPressed: () {
                      _showAddToCartDialog(context);
                    },
                    child: const Text(
                      'Order Now',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddToCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddToCartDialog();
      },
    );
  }
}

class AddToCartDialog extends StatefulWidget {
  @override
  _AddToCartDialogState createState() => _AddToCartDialogState();
}

class _AddToCartDialogState extends State<AddToCartDialog> {
  String selectedLaundryOption = '';
  int selectedKG = 1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Center(
        child: Text(
          'Pilih Jenis Laundry',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.lightBlue[800],
          ),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLaundryOption('Cuci Kering Saja', 8000), // Updated price
            _buildLaundryOption('Cuci Kering Setrika', 10000), // Updated price
            SizedBox(height: 16),
            _buildKGSelector(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (selectedLaundryOption.isEmpty || selectedKG <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Pilih jenis laundry dan jumlah KG')),
              );
              return;
            }
            _addToCart(context);
          },
          child: const Text(
            'Add to Cart',
            style: TextStyle(color: Color(0xFF00274D)), // Dark blue color
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue[300],
          ),
        ),
      ],
    );
  }

  Widget _buildLaundryOption(String title, double price) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedLaundryOption = title;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(
              selectedLaundryOption == title
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: Colors.lightBlue[300],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Rp ${price.toStringAsFixed(0)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKGSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Icons.remove, color: Colors.lightBlue[300]),
          onPressed: () {
            setState(() {
              if (selectedKG > 1) {
                selectedKG--;
              }
            });
          },
        ),
        Text(
          '$selectedKG KG',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        IconButton(
          icon: Icon(Icons.add, color: Colors.lightBlue[300]),
          onPressed: () {
            setState(() {
              selectedKG++;
            });
          },
        ),
      ],
    );
  }

  void _addToCart(BuildContext context) {
    final double pricePerKg = selectedLaundryOption == 'Cuci Kering Saja'
        ? 8000
        : 10000; // Updated prices
    OrderItem newItem = OrderItem(
      laundryOption: selectedLaundryOption,
      kg: selectedKG,
      price: pricePerKg * selectedKG,
    );
    cartItems.add(newItem);
    Navigator.pop(context);
    _showSuccessDialog(context);
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Item Ditambahkan',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.lightBlue,
            ),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Item berhasil ditambahkan ke keranjang'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.lightBlue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
