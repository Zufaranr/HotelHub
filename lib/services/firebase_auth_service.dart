import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService {
  FirebaseAuth _authService = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailandPassowrd(String username, phonenumber, email,
      password, BuildContext context) async {
    try {
      UserCredential credential = await _authService
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = credential.user;

      await _firestore.collection('Users').doc(user?.uid).set({
        'username': username,
        'phoneNumber': phonenumber,
      });

      return credential.user;
    } catch (e) {
      final String errorMessage = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<User?> loginWithEmailandPassword(
      String email, password, BuildContext context) async {
    try {
      UserCredential credential = await _authService.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      final String errorMessage = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
