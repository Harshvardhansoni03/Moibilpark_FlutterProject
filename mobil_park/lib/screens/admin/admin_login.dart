import 'package:flutter/material.dart';
import 'package:mobil_park/controller/admin/admin_auth_controller.dart';
import 'package:mobil_park/model/admin/auth_model.dart';
import 'package:mobil_park/screens/admin/admin_registration.dart';
import 'package:mobil_park/screens/admin/admin_home.dart';

class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthModel _authModel = AuthModel();
  late AuthController _authController;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _authController = AuthController(context, _authModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF252839),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.admin_panel_settings,
                      color: Color(0xFFD7B7A5), size: 36),
                  SizedBox(width: 8),
                  Text(
                    "Admin Login",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD7B7A5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(height: 60),
                    Container(
                      height: 200,
                      child: Image.asset(
                        'assets/images/car_r.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 32),
                    _buildTextField(
                      controller: _usernameController,
                      hintText: "Admin Username",
                      icon: Icons.person,
                    ),
                    SizedBox(height: 16),
                    _buildPasswordField(),
                    SizedBox(height: 24),
                    GestureDetector(
                      onTap: () {
                        _authController.signInAsAdmin(
                          _usernameController.text.trim(),
                          _passwordController.text.trim(),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFF939185),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Admin Sign-In",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.white70),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminRegisterScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(color: Color(0xFFB5A96B)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Color(0xFFD7B7A5)),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD7B7A5)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD7B7A5)),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "Password",
        hintStyle: TextStyle(color: Colors.white70),
        prefixIcon: Icon(Icons.lock, color: Colors.white70),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.white70,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD7B7A5)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
