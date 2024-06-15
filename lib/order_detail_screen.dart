import 'package:flutter/material.dart';

class OrderDetailScreen extends StatelessWidget {
  final String name;
  final List<OrderDetailItemData> items;
  final double subtotal;
  final double shipping;
  final double total;
  final String status;
  final String estimatedDelivery;

  const OrderDetailScreen({
    Key? key,
    required this.name,
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.total,
    required this.status,
    required this.estimatedDelivery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Detail Order'),
        backgroundColor: Colors.lightBlue[100], // Soft blue for app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            OrderSummary(
              name: name,
              items: items,
              subtotal: subtotal,
              shipping: shipping,
              total: total,
            ),
            const Spacer(),
            OrderStatus(
              status: status,
              estimatedDelivery: estimatedDelivery,
            ),
          ],
        ),
      ),
    );
  }
}

class OrderSummary extends StatelessWidget {
  final String name;
  final List<OrderDetailItemData> items;
  final double subtotal;
  final double shipping;
  final double total;

  const OrderSummary({
    Key? key,
    required this.name,
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...items.map((item) => OrderDetailItem(
                  title: item.title,
                  description: item.description,
                  price: item.price,
                )),
            const Divider(),
            OrderDetailItem(
              title: 'Subtotal',
              description: '',
              price: 'Rp ${subtotal.toStringAsFixed(3)}',
            ),
            OrderDetailItem(
              title: 'Ongkir',
              description: '',
              price: 'Rp ${shipping.toStringAsFixed(3)}',
            ),
            OrderDetailItem(
              title: 'Total',
              description: '',
              price: 'Rp ${total.toStringAsFixed(3)}',
            ),
          ],
        ),
      ),
    );
  }
}

class OrderDetailItem extends StatelessWidget {
  final String title;
  final String description;
  final String price;

  const OrderDetailItem({
    Key? key,
    required this.title,
    required this.description,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (description.isNotEmpty)
                Text(
                  description,
                  style: const TextStyle(color: Colors.grey),
                ),
            ],
          ),
          Text(price),
        ],
      ),
    );
  }
}

class OrderStatus extends StatelessWidget {
  final String status;
  final String estimatedDelivery;

  const OrderStatus({
    Key? key,
    required this.status,
    required this.estimatedDelivery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              status,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              estimatedDelivery,
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }
}

class OrderDetailItemData {
  final String title;
  final String description;
  final String price;

  OrderDetailItemData({
    required this.title,
    required this.description,
    required this.price,
  });
}
