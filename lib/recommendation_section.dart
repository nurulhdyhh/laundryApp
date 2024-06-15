import 'package:flutter/material.dart';
import 'package:flutterdemo/main.dart';
import 'detail_screen.dart';
import 'laundryShop.dart';
import 'service_api.dart';

class RecommendationSection extends StatefulWidget {
  @override
  _RecommendationSectionState createState() => _RecommendationSectionState();
}

class _RecommendationSectionState extends State<RecommendationSection> {
  late Future<List<LaundryShop>> futureLaundries;

  @override
  void initState() {
    super.initState();
    final apiService = ApiService();
    futureLaundries = apiService.fetchLaundries(type: 'Reguler');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LaundryShop>>(
      future: futureLaundries,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<LaundryShop>? laundries = snapshot.data;

          // Batasi jumlah item yang akan ditampilkan menjadi maksimal 4
          int displayCount = (laundries!.length < 4) ? laundries.length : 4;
          List<LaundryShop> displayLaundries =
              laundries.sublist(0, displayCount);

          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  itemCount: displayLaundries.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final laundry = displayLaundries[index];
                    return LaundryCard(
                      name: laundry.name,
                      rating: laundry.rating.toString(),
                      address: laundry.address,
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
                      imageUrl: laundry.imageUrl,
                      category: laundry.type,
                    );
                  },
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
