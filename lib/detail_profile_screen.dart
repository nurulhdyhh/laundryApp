import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailedProfileScreen extends StatelessWidget {
  final String name;
  final String npm;
  final String email;
  final String phoneNumber;
  final String address;
  final String githubUrl;
  final String imagePath; // Add imagePath parameter

  DetailedProfileScreen({
    required this.name,
    required this.npm,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.githubUrl,
    required this.imagePath, // Initialize imagePath
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Anggota'),
      ),
      body: SingleChildScrollView(
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
                      backgroundImage:
                          AssetImage(imagePath), // Use the imagePath
                    ),
                    SizedBox(height: 8),
                    Text(
                      name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              buildProfileDetail('Nama', name),
              buildProfileDetail('NPM', npm),
              buildProfileDetail('Email', email, isEmail: true),
              buildProfileDetail('Nomor Telepon', phoneNumber),
              buildProfileDetail('Alamat', address),
              buildProfileDetail('URL GitHub', githubUrl, isLink: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileDetail(String title, String detail,
      {bool isLink = false, bool isEmail = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          isLink
              ? buildLinkText(detail)
              : isEmail
                  ? buildEmailLinkText(detail)
                  : Text(detail),
          Divider(),
        ],
      ),
    );
  }

  Widget buildLinkText(String url) {
    return InkWell(
      onTap: () async {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          debugPrint('Could not launch $url');
          throw 'Could not launch $url';
        }
      },
      child: Text(
        url,
        style: TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget buildEmailLinkText(String email) {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    return InkWell(
      onTap: () async {
        if (await canLaunch(emailLaunchUri.toString())) {
          await launch(emailLaunchUri.toString());
        } else {
          debugPrint('Could not launch ${emailLaunchUri.toString()}');
          throw 'Could not launch ${emailLaunchUri.toString()}';
        }
      },
      child: Text(
        email,
        style: TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
