import 'package:flutter/material.dart';
import 'package:flutterdemo/main.dart';
import 'detail_screen.dart';
import 'laundryShop.dart';
import 'service_api.dart';

class CategoryResults extends StatelessWidget {
  final String category;

  const CategoryResults({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();
    final Future<List<LaundryShop>> futureLaundries =
        apiService.fetchLaundries(type: category);

    return Scaffold(
      appBar: AppBar(
        title: Text('Kategori : $category'),
      ),
      body: FutureBuilder<List<LaundryShop>>(
        future: futureLaundries,
        // Di dalam builder FutureBuilder<List<LaundryShop>>
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No results found'));
          } else {
            List<LaundryShop> laundries = snapshot.data!;
            if (category != 'All') {
              laundries = laundries
                  .where((laundry) => laundry.type == category)
                  .toList();
            }
            if (laundries.isEmpty) {
              return const Center(
                  child: Text('No results found for this category'));
            }
            return GridView.builder(
              itemCount: laundries.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final laundry = laundries[index];
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
            );
          }
        },
      ),
    );
  }
}
