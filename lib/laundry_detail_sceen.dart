import 'package:flutter/material.dart';
// ignore: unused_import
import 'order_item.dart'; // Impor kelas model

class LaundryDetailScreen extends StatelessWidget {
  final Map<String, dynamic> item;

  const LaundryDetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(255, 21, 59, 111)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Pesanan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 21, 59, 111),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 97, 205, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Card(
              color: Colors.lightBlue[50], // Soft blue color for card
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDetailRow('Tanggal', item['timestamp'] ?? 'N/A'),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                        'Total Harga', 'Rp ${item['totalAmount'] ?? '0'}'),
                    const SizedBox(height: 8),
                    _buildDetailRow('Biaya Pengiriman',
                        'Rp ${item['deliveryCharge'] ?? '0'}'),
                    const SizedBox(height: 8),
                    _buildDetailRow('Total Pembayaran',
                        'Rp ${item['totalPayable'] ?? '0'}'),
                    const SizedBox(height: 8),
                    _buildDetailRow('Berat',
                        '${item['totalKg'] ?? '0'} kg'), // Menggunakan totalKg
                    const SizedBox(height: 8),
                    _buildDetailRow('Status', item['status'] ?? 'N/A'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 21, 59, 111),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color.fromARGB(255, 21, 59, 111),
          ),
        ),
      ],
    );
  }
}
