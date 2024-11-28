// auth_controller.dart
import 'package:flutter/material.dart';
import 'package:mobil_park/model/admin/admin_auth_model.dart';

class AuthController {
  final AuthModel _authModel;
  final BuildContext context;

  AuthController(this.context, this._authModel);

  Future<bool> signInAsAdmin(String username, String password) async {
    if (!_authModel.validateEmail(username)) {
      _showError("Invalid email format.");
      return false;
    }

    if (!_authModel.validatePassword(password)) {
      _showError("Password must be at least 6 characters long.");
      return false;
    }

    try {
      final user = await _authModel.signInWithEmailAndPassword(username, password);
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login Successful!")),
        );
        return true; // Successful login
      }
    } catch (e) {
      _showError("Error: ${e.toString()}");
    }
    return false; // Login failed
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}