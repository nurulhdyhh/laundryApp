import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'login_screen.dart'; // Pastikan untuk mengimpor LoginScreen

class ProfileAdminScreen extends StatelessWidget {
  final User user;

  const ProfileAdminScreen({Key? key, required this.user}) : super(key: key);

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 158, 219, 255),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(162, 6, 37, 83)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(162, 6, 37, 83),
          ),
        ),
      ),
      body: FutureBuilder<DatabaseEvent>(
        future: FirebaseDatabase.instance
            .ref()
            .child('users')
            .child(user.uid)
            .once(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            final userData =
                snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            final username =
                userData['username']; // Ambil username dari database
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage('assets/nurfil.jpg'),
                            ),
                            SizedBox(height: 8),
                            Text(
                              username ?? '', // Tampilkan username
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(user.email ?? ''),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Card(
                        elevation: 4,
                        color: Colors
                            .lightBlue[100], // Light blue color for the card
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Role: Admin dapat melakukan update status laundry disetiap orderan hingga distatus done',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 0, 51,
                                      102), // Dark blue color for the text
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      onPressed: () => _logout(context),
                      icon: Icon(Icons.logout, color: Colors.white),
                      label: Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(
                            255, 62, 114, 188), // Button background color
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return Center(child: Text('Failed to load profile data'));
        },
      ),
    );
  }
}
