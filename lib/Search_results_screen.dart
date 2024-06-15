import 'package:flutter/material.dart';
import 'package:flutterdemo/detail_screen.dart';
import 'package:flutterdemo/main.dart';
import 'laundryShop.dart';

class SearchResultsScreen extends StatelessWidget {
  final List<LaundryShop> searchResults;

  const SearchResultsScreen(this.searchResults, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: searchResults.isEmpty
          ? const Center(child: Text('No results found'))
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1, // Adjusted aspect ratio for better fit
                ),
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final result = searchResults[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            name: result.name,
                            rating: result.rating.toString(),
                            address: result.address,
                            description: result.description,
                            imageUrl: result.imageUrl,
                            price: result.price,
                          ),
                        ),
                      );
                    },
                    child: LaundryCard(
                      name: result.name,
                      rating: result.rating.toString(),
                      address: result.address,
                      imageUrl: result.imageUrl,
                      category: result.type,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(
                              name: result.name,
                              rating: result.rating.toString(),
                              address: result.address,
                              description: result.description,
                              imageUrl: result.imageUrl,
                              price: result.price,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
