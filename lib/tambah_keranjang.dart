import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutterdemo/detail_screen.dart';
// ignore: unused_import
import 'package:flutterdemo/keranjang_belanja.dart';

class CartItem {
  final String laundryOption;
  final double kg;
  final double price;

  CartItem({
    required this.laundryOption,
    required this.kg,
    required this.price,
  });
}

List<CartItem> cartItems = [];

class AddToCartScreen extends StatefulWidget {
  @override
  _AddToCartScreenState createState() => _AddToCartScreenState();
}

class _AddToCartScreenState extends State<AddToCartScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _laundryOption;
  double? _kg;
  double? _price;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah ke Keranjang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _laundryOption,
                items: [
                  DropdownMenuItem(
                    child: Text('Cuci Kering Saja'),
                    value: 'Cuci Kering Saja',
                  ),
                  DropdownMenuItem(
                    child: Text('Cuci Setrika'),
                    value: 'Cuci Setrika',
                  ),
                  // Tambahkan opsi lainnya
                ],
                onChanged: (value) {
                  setState(() {
                    _laundryOption = value;
                    _price = value == 'Cuci Kering Saja'
                        ? 6000
                        : 10000; // Contoh harga
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Jenis Laundry',
                  hintText: 'Pilih jenis laundry',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih jenis laundry';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Jumlah KG',
                  hintText: 'Masukkan jumlah kilogram',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan jumlah kilogram';
                  }
                  final kg = double.tryParse(value);
                  if (kg == null || kg <= 0) {
                    return 'Jumlah kilogram harus lebih dari 0';
                  }
                  return null;
                },
                onSaved: (value) {
                  _kg = double.tryParse(value!);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    cartItems.add(CartItem(
                      laundryOption: _laundryOption!,
                      kg: _kg!,
                      price: _price! * _kg!,
                    ));
                    Navigator.pop(context);
                  }
                },
                child: Text('Tambah ke Keranjang'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
