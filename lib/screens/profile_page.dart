import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotelhub/screens/login_page.dart';
import 'package:hotelhub/screens/settings_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late User? _user;
  String _username = "", _phoneNumber = "";
  File? _image; // Variable to hold the selected image file
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _loadPhoneNumber();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    String? imagePath = _prefs.getString('profile_image');
    if (imagePath != null && imagePath.isNotEmpty) {
      setState(() {
        _image = File(imagePath);
      });
    }
  }

  Future<void> _loadPhoneNumber() async {
    if (_user != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
            await _firestore.collection('Users').doc(_user!.uid).get();

        if (userSnapshot.exists) {
          setState(() {
            _username = userSnapshot.get('username') ?? "";
            _phoneNumber = userSnapshot.get('phoneNumber') ?? "";
          });
        }
      } catch (e) {
        print("Error loading phone number: $e");
      }
    }
  }

  // Method to open camera and select image
  Future<void> openCamera() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedImage == null) {
      return;
    }
    setState(() {
      _image = File(pickedImage.path);
    });

    _saveImage(pickedImage.path);
  }

  Future<void> _saveImage(String imagePath) async {
    await _prefs.setString('profile_image', imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar Section
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                GestureDetector(
                  onTap: () {
                    openCamera();
                  },
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                      image: _image != null
                          ? DecorationImage(
                              image: FileImage(_image!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _image == null
                        ? Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: IconButton(
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        openCamera();
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              _username,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                leading: Icon(Icons.email),
                title: Text('${_user?.email}'),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ListTile(
                leading: Icon(Icons.phone),
                title: Text(_phoneNumber),
              ),
            ),
            ProfileMenuItem(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
            ProfileMenuItem(
              icon: Icons.exit_to_app,
              title: 'Logout',
              onTap: () {
                _auth.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              size: 28,
              color: Colors.blue,
            ),
            SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
