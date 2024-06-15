import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'detail_profile_screen.dart';
import 'login_screen.dart'; // Import the login screen

class ProfileScreen extends StatefulWidget {
  final User user; // Add user parameter

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child('users').child(widget.user.uid);
    final DatabaseEvent event = await dbRef.once();
    if (event.snapshot.value != null) {
      final userData = event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        username = userData['username'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage(
                                'assets/profile.jpg'), // Add your profile image to assets
                          ),
                          SizedBox(height: 8),
                          Text(
                            username ??
                                'Loading...', // Display username if available
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(widget.user.email ?? ''), // Display email
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.all(8.0), // Reduce the padding
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30, // Reduce the size of the avatar
                                  backgroundImage: AssetImage(
                                      'assets/profile.jpg'), // Add your profile image to assets
                                ),
                                SizedBox(
                                    width:
                                        8), // Reduce the space between avatar and text
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Ketua Kelompok',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                          height:
                                              4), // Reduce the space between lines
                                      Text(
                                        'Nama: Nurul Hidayatul Hasanah',
                                        style: TextStyle(
                                            fontSize:
                                                12), // Reduce the font size
                                      ),
                                      Text(
                                        'NPM: 22082010013',
                                        style: TextStyle(
                                            fontSize:
                                                12), // Reduce the font size
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetailedProfileScreen(
                                          name: 'Nurul Hidayatul Hasanah',
                                          npm: '22082010013',
                                          email: 'Nurulhidayatul@gmail.com',
                                          phoneNumber: '085769883212',
                                          address: 'Asarama Putri UPN',
                                          githubUrl:
                                              'https://github.com/nurulhdyhh',
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Lihat Detail',
                                    style: TextStyle(
                                        fontSize: 12), // Reduce the font size
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.all(8.0), // Reduce the padding
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30, // Reduce the size of the avatar
                                  backgroundImage: AssetImage(
                                      'assets/profile.jpg'), // Add your profile image to assets
                                ),
                                SizedBox(
                                    width:
                                        8), // Reduce the space between avatar and text
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Anggota Kelompok',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                          height:
                                              4), // Reduce the space between lines
                                      Text(
                                        'Nama: Filda Dwi Meirina',
                                        style: TextStyle(
                                            fontSize:
                                                12), // Reduce the font size
                                      ),
                                      Text(
                                        'NPM: 22082010025',
                                        style: TextStyle(
                                            fontSize:
                                                12), // Reduce the font size
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetailedProfileScreen(
                                          name: 'Filda Dwi Meirina',
                                          npm: '22082010025',
                                          email: 'fildadwimeirina@gmail.com',
                                          phoneNumber: '085278654312',
                                          address: 'Perum IKIP Blok A-14',
                                          githubUrl:
                                              'https://github.com/Anndafildaa',
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Lihat Detail',
                                    style: TextStyle(
                                        fontSize: 12), // Reduce the font size
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Logout'),
                        content: Text('Are you sure you want to logout?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Perform logout
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                              );
                            },
                            child: Text('Logout'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Arial', // Set to any available font
                    letterSpacing: 1.2, // Optional: Adds space between letters
                    shadows: [
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 2.0,
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
