// auth_controller.dart
import 'package:flutter/material.dart';
import 'package:mobil_park/model/auth_model.dart';

class AuthController {
  final AuthModel _authModel;
  final BuildContext context;

  AuthController(this.context, this._authModel);

  Future<void> signIn(String email, String password) async {
    if (!_authModel.validateEmail(email)) {
      _showError("Invalid email format.");
      return;
    }

    if (!_authModel.validatePassword(password)) {
      _showError("Password must be at least 6 characters long.");
      return;
    }

    try {
      final user = await _authModel.signInWithEmailAndPassword(email, password);
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login Successful!")),
        );
        // Navigate to home screen or dashboard
      }
    } catch (e) {
      _showError("Error: ${e.toString()}");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
