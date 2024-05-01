import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hotelhub/components/bottnavbar.dart';
import 'package:hotelhub/screens/login_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottNavBar()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logohotel.png',
              width: 300,
              height: 300,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
