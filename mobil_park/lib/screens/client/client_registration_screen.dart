import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobil_park/controller/faculty/faculty_registration_controller.dart';
import 'package:mobil_park/model/faculty/faculty_user.dart';
import 'package:mobil_park/screens/client/client_login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF252839),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
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
                  _buildTextField(
                    "Phone number", 
                    _phoneController, 
                    Icons.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ]),
                  SizedBox(height: 16),
                  _buildTextField("Email ID", _emailController, Icons.email,
                      inputType: 
                      TextInputType.emailAddress,
                      ),
                  SizedBox(height: 16),
                  _buildTextField(
                    "Car Number",
                    _carNumberController,
                    Icons.directions_car,
                    hint: "GJ05JD9759",
                    validator: (value) {
                      final regex = RegExp(r'^[A-Z]{2}[0-9]{2}[A-Z]{2}[0-9]{4}$');
                      if (value == null || value.isEmpty) {
                        return "Car number is required";
                      } else if (!regex.hasMatch(value)) {
                        return "Invalid car number format (e.g., GJ05JD9759)";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    "Faculty Employment Number",
                    _facultyEmploymentNumberController,
                    Icons.badge,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Employment number is required";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  _buildPasswordField("Password", _passwordController,
                      _isPasswordVisible, () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  }),
                  SizedBox(height: 16),
                  _buildPasswordField(
                      "Confirm Password",
                      _confirmPasswordController,
                      _isConfirmPasswordVisible, () {
                    setState(() {
                      _isConfirmPasswordVisible =
                          !_isConfirmPasswordVisible;
                    });
                  }),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Form is valid, process data
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
                        _controller.registerUser(userModel, context);
                      }
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
                                  builder: (context) => SignInScreen()),
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
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType inputType = TextInputType.text,
    String? hint,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      inputFormatters: inputFormatters,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey),
        labelStyle: TextStyle(color: Color(0xFFD7B7A5)),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD7B7A5)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        prefixIcon: Icon(icon, color: Color(0xFFD7B7A5)),
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordField(
      String label,
      TextEditingController controller,
      bool isPasswordVisible,
      VoidCallback toggleVisibility) {
    return TextFormField(
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
