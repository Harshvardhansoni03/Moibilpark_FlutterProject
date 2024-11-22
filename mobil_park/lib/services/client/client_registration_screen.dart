import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'client_login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _carNumberController = TextEditingController();
  final _facultyEmploymentNumberController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  // State variables for password visibility
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // OTP Variable
  String? _otp;

  Future<void> _register() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final carNumber = _carNumberController.text.trim();
    final facultyEmploymentNumber = _facultyEmploymentNumberController.text.trim();

    if (!_validateInputs(name, phone, email, password, confirmPassword, carNumber, facultyEmploymentNumber)) return;

    try {


      // Register the user in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add user details to Firestore
      final userId = userCredential.user?.uid;
      if (userId != null) {
        await FirebaseFirestore.instance.collection('Faculty_Details').doc(userId).set({
          'Name': name,
          'Phone no.': phone,
          'Email': email,
          'Employ number': facultyEmploymentNumber,
          'Car number': carNumber,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration Successful!")),
      );

      // Navigate to login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  bool _validateInputs(String name, String phone, String email, String password,
      String confirmPassword, String carNumber, String facultyEmploymentNumber) {
    if (name.isEmpty) {
      _showError("Name is required.");
      return false;
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
      _showError("Phone number must be 10 digits.");
      return false;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _showError("Invalid email format.");
      return false;
    }
    if (password.length < 6) {
      _showError("Password must be at least 6 characters long.");
      return false;
    }
    if (password != confirmPassword) {
      _showError("Passwords do not match.");
      return false;
    }
    if (carNumber.isEmpty) {
      _showError("Car Number is required.");
      return false;
    }
    if (facultyEmploymentNumber.isEmpty) {
      _showError("Faculty Employment Number is required.");
      return false;
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // Generate a random 4-digit OTP
  String _generateOtp() {
    final random = Random();
    return (random.nextInt(9000) + 1000).toString();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF252839),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo and Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.directions_car, color: Color(0xFFD7B7A5), size: 36),
                    SizedBox(width: 8),
                    Text(
                      "MobilPark",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD7B7A5),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                // Input fields
                _buildTextField("Name", _nameController, Icons.person),
                SizedBox(height: 16),
                _buildTextField("Phone number", _phoneController, Icons.phone,
                    inputType: TextInputType.phone),
                SizedBox(height: 16),
                _buildTextField("Email ID", _emailController, Icons.email,
                    inputType: TextInputType.emailAddress),
                SizedBox(height: 16),
                _buildTextField("Car Number", _carNumberController,
                    Icons.directions_car),
                SizedBox(height: 16),
                _buildTextField(
                    "Faculty Employment Number", _facultyEmploymentNumberController, Icons.badge),
                SizedBox(height: 16),
                _buildPasswordField("Password", _passwordController,
                    _isPasswordVisible, () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                }),
                SizedBox(height: 16),
                _buildPasswordField("Confirm Password",
                    _confirmPasswordController, _isConfirmPasswordVisible, () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                }),
                SizedBox(height: 24),
                // Register Button
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD7B7A5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 12.0),
                    child: Text(
                      "Register",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Already have an account? Login
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                    );
                  },
                  child: Text(
                    "Already have an account? Login",
                    style: TextStyle(color: Color(0xFFD7B7A5)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      IconData icon, {TextInputType inputType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Color(0xFFD7B7A5)),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD7B7A5)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        prefixIcon: Icon(icon, color: Color(0xFFD7B7A5)),
      ),
    );
  }

  Widget _buildPasswordField(
      String label,
      TextEditingController controller,
      bool isPasswordVisible,
      VoidCallback toggleVisibility) {
    return TextField(
      controller: controller,
      obscureText: !isPasswordVisible,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Color(0xFFD7B7A5)),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD7B7A5)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        prefixIcon: Icon(Icons.lock, color: Color(0xFFD7B7A5)),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Color(0xFFD7B7A5),
          ),
          onPressed: toggleVisibility,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _carNumberController.dispose();
    _facultyEmploymentNumberController.dispose();
    super.dispose();
  }
}
