import 'package:flutter/material.dart';
import 'package:flutterdemo/laundryShop.dart';

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
        title: Text('Category - $type'),
      ),
      body: filteredLaundries.isEmpty
          ? Center(child: Text('No laundries found for $type'))
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: filteredLaundries.length,
              itemBuilder: (context, index) {
                final laundry = filteredLaundries[index];
                return Card(
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        laundry.imageUrl,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              laundry.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text('Rating: ${laundry.rating}'),
                            const SizedBox(height: 4),
                            Text(laundry.address),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
