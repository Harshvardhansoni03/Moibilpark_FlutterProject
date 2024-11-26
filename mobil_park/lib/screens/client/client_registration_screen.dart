import 'package:flutter/material.dart';
import 'package:mobil_park/controller/faculty/faculty_registration_controller.dart';
import 'package:mobil_park/model/faculty/faculty_user.dart';
import 'package:mobil_park/screens/client/client_login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _isHoveringLogin = false;

  @override
  void initState() {
    super.initState();
    _loadUserDetails(); // Load saved user details during initialization
  }

  Future<void> _saveUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text.trim());
    await prefs.setString('phone', _phoneController.text.trim());
    await prefs.setString('email', _emailController.text.trim());
    await prefs.setString('carNumber', _carNumberController.text.trim());
    await prefs.setString(
        'facultyEmploymentNumber', _facultyEmploymentNumberController.text.trim());
  }

  Future<void> _loadUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? '';
      _phoneController.text = prefs.getString('phone') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
      _carNumberController.text = prefs.getString('carNumber') ?? '';
      _facultyEmploymentNumberController.text =
          prefs.getString('facultyEmploymentNumber') ?? '';
    });
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.directions_car,
                        color: Color(0xFFD7B7A5), size: 36),
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
                _buildTextField("Faculty Employment Number",
                    _facultyEmploymentNumberController, Icons.badge),
                SizedBox(height: 16),
                _buildPasswordField(
                    "Password", _passwordController, _isPasswordVisible, () {
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
                  onPressed: () async {
                    final userModel = UserModel(
                      name: _nameController.text.trim(),
                      phone: _phoneController.text.trim(),
                      email: _emailController.text.trim(),
                      password: _passwordController.text,
                      confirmPassword: _confirmPasswordController.text,
                      carNumber: _carNumberController.text.trim(),
                      facultyEmploymentNumber:
                          _facultyEmploymentNumberController.text.trim(),
                    );
                    // Save to Shared Preferences
                    await _saveUserDetails();
                    _controller.registerUser(userModel, context);
                  },
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ",
                        style: TextStyle(color: Color(0xFFD7B7A5))),
                    MouseRegion(
                      onEnter: (_) => setState(() => _isHoveringLogin = true),
                      onExit: (_) => setState(() => _isHoveringLogin = false),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _isHoveringLogin
                                ? Color(0xFFD7B7A5)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: _isHoveringLogin
                                  ? Colors.black
                                  : Color(0xFFD7B7A5),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      IconData icon,
      {TextInputType inputType = TextInputType.text}) {
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
