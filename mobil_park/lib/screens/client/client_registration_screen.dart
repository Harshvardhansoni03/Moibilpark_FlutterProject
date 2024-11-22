// view/register_screen.dart
import 'package:flutter/material.dart';
import 'package:mobil_park/controller/faculty/registration_controller.dart';
import 'package:mobil_park/model/faculty/user.dart';
import 'package:mobil_park/screens/client/client_login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _controller = RegisterController();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _carNumberController = TextEditingController();
  final _facultyEmploymentNumberController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

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
                _buildTextField("Faculty Employment Number", _facultyEmploymentNumberController, Icons.badge),
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
                ElevatedButton(
                  onPressed: () {
                    final userModel = UserModel(
                      name: _nameController.text.trim(),
                      phone: _phoneController.text.trim(),
                      email: _emailController.text.trim(),
                      password: _passwordController.text,
                      confirmPassword: _confirmPasswordController.text,
                      carNumber: _carNumberController.text.trim(),
                      facultyEmploymentNumber: _facultyEmploymentNumberController.text.trim(),
                    );
                    _controller.registerUser(userModel, context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD7B7A5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
                    child: Text(
                      "Register",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                  Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );                  },
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
}
