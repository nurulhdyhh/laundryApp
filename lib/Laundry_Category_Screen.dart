import 'package:flutter/material.dart';
import 'laundryShop.dart';
import 'detail_screen.dart';

class LaundryCategoryScreen extends StatelessWidget {
  final String type;
  final List<LaundryShop> laundries;

  const LaundryCategoryScreen({
    Key? key,
    required this.type,
    required this.laundries,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<LaundryShop> filteredLaundries;

    if (type == 'All') {
      filteredLaundries = laundries;
    } else {
      filteredLaundries =
          laundries.where((laundry) => laundry.type == type).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Kategori : $type'),
        backgroundColor: Colors.lightBlue[100], // Soft blue for app bar
      ),
      body: filteredLaundries.isEmpty
          ? Center(child: Text('No laundries found for $type'))
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.75,
              ),
              itemCount: filteredLaundries.length,
              itemBuilder: (context, index) {
                final laundry = filteredLaundries[index];
                return LaundryCard(
                  name: laundry.name,
                  rating: laundry.rating.toString(),
                  address: laundry.address,
                  imageUrl: laundry.imageUrl,
                  category: laundry.type,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(
                          name: laundry.name,
                          rating: laundry.rating.toString(),
                          address: laundry.address,
                          description: laundry.description,
                          imageUrl: laundry.imageUrl,
                          price: laundry.price,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class LaundryCard extends StatelessWidget {
  final String name;
  final String rating;
  final String address;
  final String imageUrl;
  final String category;
  final VoidCallback onTap;

  const LaundryCard({
    Key? key,
    required this.name,
    required this.rating,
    required this.address,
    required this.imageUrl,
    required this.category,
    required this.onTap,
  }) : super(key: key);

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'express':
        return Color(0xFFD7ECFF); // Light blue
      case 'regular':
        return Color(0xFFDAF7A6); // Light green
      default:
        return Color(0xFFEBEBEB); // Light grey
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Color.fromARGB(255, 132, 190, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16.0)),
              child: Image.network(
                imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    height: 160,
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 120,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(221, 3, 38, 57),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Rating: $rating',
                    style: const TextStyle(
                        fontSize: 12, color: Color.fromARGB(221, 3, 38, 57)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    address,
                    style: const TextStyle(
                        fontSize: 12, color: Color.fromARGB(221, 3, 38, 57)),
                  ),
                  const SizedBox(height: 2),
                  Chip(
                    label: Text(category),
                    backgroundColor: _getCategoryColor(category),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
