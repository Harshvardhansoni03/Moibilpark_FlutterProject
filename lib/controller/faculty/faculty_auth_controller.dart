import 'package:flutter/material.dart';
import 'package:mobil_park/model/faculty/faculty_auth_model.dart';
import 'package:mobil_park/screens/client/client_home_screen.dart';
import 'package:mobil_park/screens/client/client_profile.dart'; // Replace with correct screen after login

class AuthController {
  final AuthModel _authModel;
  final BuildContext context;

  AuthController(this.context, this._authModel);

  Future<void> signIn(String email, String password) async {
    // Validate email and password formats
    if (!_authModel.validateEmail(email)) {
      _showError("Invalid email format.");
      return;
    }

    if (!_authModel.validatePassword(password)) {
      _showError("Password must be at least 6 characters long.");
      return;
    }

    try {
      // Attempt to sign in with the provided email and password
      final user = await _authModel.signInWithEmailAndPassword(email, password);
      if (user != null) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login Successful!")),
        );

        // Navigate to ClientHomeScreen (or whichever screen you need after login)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ParkingHomePage()), // Navigate to Home screen
        );
      } else {
        _showError("Invalid login credentials.");
      }
    } catch (e) {
      _showError("Error: ${e.toString()}");
    }
  }

  // Helper method to display error messages
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
//added comment only 