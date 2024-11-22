// controller/register_controller.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobil_park/model/faculty/user.dart';

class RegisterController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser(
    UserModel userModel,
    BuildContext context,
  ) async {
    if (!userModel.isValid()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid input")));
      return;
    }

    try {
      // Register the user in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );

      // Add user details to Firestore
      final userId = userCredential.user?.uid;
      if (userId != null) {
        await _firestore.collection('Faculty_Details').doc(userId).set({
          'Name': userModel.name,
          'Phone no.': userModel.phone,
          'Email': userModel.email,
          'Employ number': userModel.facultyEmploymentNumber,
          'Car number': userModel.carNumber,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registration Successful!")));

      // Navigate to login screen
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }
}
