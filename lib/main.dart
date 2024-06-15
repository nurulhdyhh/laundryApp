// ignore_for_file: duplicate_import, unused_import
import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/Category_Results.dart';
import 'package:flutterdemo/Laundry_Category_Screen.dart';
import 'package:flutterdemo/Search_results_screen.dart';
import 'package:flutterdemo/laundryShop.dart';
import 'package:flutterdemo/laundry_detail_sceen.dart';
import 'package:flutterdemo/registration_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'recommendation_section.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutterdemo/login_screen.dart';
import 'user_home_screen.dart';
import 'admin_home_screen.dart'; // Halaman Admin
import 'package:flutterdemo/keranjang_belanja.dart';
import 'profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tambahkan penanganan untuk pengecekan pengguna yang sudah masuk
    User? user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'D’Oembah',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        hintColor: Colors.lightGreen,
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.teal,
              width: 2,
            ),
          ),
          labelStyle: TextStyle(
            color: Colors.teal,
          ),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.teal,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      home: user != null ? HomePage(user: user) : LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegistrationScreen(),
        '/user-home': (context) => HomePage(user: user),
        '/admin-home': (context) => AdminHomeScreen(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  final User? user;

  const HomePage({Key? key, this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Deklarasi _selectedIndex di sini

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      const HomeScreen(),
      LaundryScreen(),
      ProfileScreen(user: widget.user!),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_laundry_service),
            label: 'Laundry',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'D’Oembah',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlue[100], // Soft blue for app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SearchBar(),
              const CategoryTabs(),
              const SizedBox(height: 16),
              const Text(
                'Promo',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              PromoSection(),
              const SizedBox(height: 16),
              const Text(
                'Rekomendasi',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                height: 400,
                child: RecommendationSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 45,
      child: TextField(
        textInputAction: TextInputAction.search,
        onSubmitted: (String keyword) {
          _performSearch(context, keyword);
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'Search',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  void _performSearch(BuildContext context, String keyword) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/laundries/search?keyword=$keyword'),
      );
      if (response.statusCode == 200) {
        final List<LaundryShop> searchResults =
            (json.decode(response.body) as List)
                .map((data) => LaundryShop.fromJson(data))
                .toList();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchResultsScreen(searchResults),
          ),
        );
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to perform search'),
        ),
      );
    }
  }
}

class CategoryTabs extends StatelessWidget {
  const CategoryTabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CategoryTab(
              title: 'All', onTap: () => _navigateToCategory(context, 'All')),
          CategoryTab(
              title: 'Regular',
              onTap: () => _navigateToCategory(context, 'Regular')),
          CategoryTab(
              title: 'Express',
              onTap: () => _navigateToCategory(context, 'Express')),
        ],
      ),
    );
  }

  void _navigateToCategory(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryResults(category: category),
      ),
    );
  }
}

class CategoryTab extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CategoryTab({Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(title),
        backgroundColor: Colors.blue[100],
      ),
    );
  }
}

class PromoSection extends StatefulWidget {
  @override
  _PromoSectionState createState() => _PromoSectionState();
}

class _PromoSectionState extends State<PromoSection> {
  late PageController _pageController;
  // ignore: unused_field
  int _currentPage = 0;

  final List<String> promoImages = [
    'assets/laundry1.jpg',
    'assets/laundry2.jpg',
    'assets/laundry3.jpg',
  ];

  final List<String> promoNames = [
    'Luxury Laundry',
    'Clean & Bright Laundry',
    'Fresh Laundry Services',
  ];

  final List<String> promoPrices = [
    'Rp 15.000/Kg',
    'Rp 20.000/Kg',
    'Rp 18.000/Kg',
  ];

  final List<String> promoDiscountPrices = [
    'Rp 12.000/Kg',
    'Rp 15.000/Kg',
    'Rp 13.000/Kg',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 120,
      child: PageView.builder(
        controller: _pageController,
        itemCount: promoImages.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(promoImages[index]),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [Colors.black54, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        promoNames[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            promoPrices[index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.red,
                              decorationThickness: 2,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            promoDiscountPrices[index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
        return Colors.blue[100]!;
      case 'regular':
        return Colors.green[100]!;
      default:
        return Colors.grey[100]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240, // Sesuaikan dengan kebutuhan
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 4,
          child: SingleChildScrollView(
            // Tambahkan SingleChildScrollView
            child: Column(
              mainAxisSize: MainAxisSize.min, // Atur MainAxisSize
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16.0)),
                  child: Image.network(
                    imageUrl,
                    height: 110,
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
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Rating: $rating',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black87),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        address,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black87),
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
        ),
      ),
    );
  }
}

class LaundryScreen extends StatefulWidget {
  @override
  _LaundryScreenState createState() => _LaundryScreenState();
}

class _LaundryScreenState extends State<LaundryScreen> {
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref().child('orders');
  List<Map<String, dynamic>> laundryItems = [];

  @override
  void initState() {
    super.initState();
    _loadLaundryItems();
  }

  void _loadLaundryItems() {
    databaseReference.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          laundryItems = data.entries
              .map((entry) =>
                  {'key': entry.key, ...Map<String, dynamic>.from(entry.value)})
              .toList();
        });
      }
    });
  }

  // void updateOrderStatus(String orderKey, String newStatus) {
  //   databaseReference.child(orderKey).update({'status': newStatus}).then((_) {
  //     print("Status updated successfully!");
  //   }).catchError((error) {
  //     print("Failed to update status: $error");
  //   });
  // }

  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredLaundryItems = selectedCategory == 'All'
        ? laundryItems
        : laundryItems
            .where((item) => item['status'] == selectedCategory)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laundry Services'),
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                _buildCategoryItem('All'),
                _buildCategoryItem('Pickup'),
                _buildCategoryItem('Queue'),
                _buildCategoryItem('Process'),
                _buildCategoryItem('Washing'),
                _buildCategoryItem('Dried'),
                _buildCategoryItem('Ironed'),
                _buildCategoryItem('Done'),
              ],
            ),
          ),
          Expanded(
            child: filteredLaundryItems.isEmpty
                ? Center(
                    child: Text(
                      'No items found in this category.',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredLaundryItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredLaundryItems[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LaundryDetailScreen(item: item),
                            ),
                          );
                        },
                        child: Card(
                          child: ListTile(
                            title: Text('Order ${index + 1}'),
                            subtitle: Text(
                                'Total: Rp ${item['totalAmount']} - Status: ${item['status']}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // _buildStatusButton(item['status']),
                                // IconButton(
                                //   icon: Icon(Icons.edit),
                                //   onPressed: () {
                                //     _showStatusUpdateDialog(
                                //         item['key'], item['status']);
                                //   },
                                // ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String category) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: selectedCategory == category
              ? Colors.blueAccent
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            category,
            style: TextStyle(
              color: selectedCategory == category ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusButton(String status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pickup':
        return Colors.orange;
      case 'Queue':
        return Colors.blue;
      case 'Process':
        return Colors.yellow;
      case 'Washing':
        return Colors.green;
      case 'Dried':
        return Colors.lightGreen;
      case 'Ironed':
        return Colors.purple;
      case 'Done':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  // void _showStatusUpdateDialog(String orderKey, String currentStatus) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       String newStatus = currentStatus;
  //       return AlertDialog(
  //         title: Text('Update Status'),
  //         content: DropdownButton<String>(
  //           value: newStatus,
  //           onChanged: (String? value) {
  //             if (value != null) {
  //               setState(() {
  //                 newStatus = value;
  //               });
  //             }
  //           },
  //           items: <String>[
  //             'Pickup',
  //             'Queue',
  //             'Process',
  //             'Washing',
  //             'Dried',
  //             'Ironed',
  //             'Done'
  //           ].map<DropdownMenuItem<String>>((String value) {
  //             return DropdownMenuItem<String>(
  //               value: value,
  //               child: Text(value),
  //             );
  //           }).toList(),
  //         ),
  //         actions: [
  //           TextButton(
  //             child: Text('Cancel'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           ElevatedButton(
  //             child: Text('Update'),
  //             onPressed: () {
  //               updateOrderStatus(orderKey, newStatus);
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}

class LaundryDetailScreen extends StatelessWidget {
  final Map<String, dynamic> item;

  const LaundryDetailScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pesanan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tanggal: ${item['timestamp']}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Total Harga: Rp ${item['totalAmount']}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Biaya Pengiriman: Rp ${item['deliveryCharge']}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Total Pembayaran: Rp ${item['totalPayable']}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Status: ${item['status']}',
                style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
