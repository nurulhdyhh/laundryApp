import 'package:flutter/material.dart';

class LaundryDetailScreen extends StatelessWidget {
  final Map<String, dynamic> item;

  const LaundryDetailScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item['title']),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                item['title'],
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Date: ${item['date']}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Price: ${item['price']}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Weight: ${item['weight']}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Pickup: ${item['pickup']}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Delivery: ${item['delivery']}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Description: ${item['description']}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
