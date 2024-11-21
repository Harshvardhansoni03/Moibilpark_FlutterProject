import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isPasswordVisible = false; // State to toggle password visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF252839), // Background color
      body: Stack(
        children: [
          // Top-left logo
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.directions_car,
                    color: Colors.white,
                    size: 36,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "MobilPark",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Form and main content
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 60), // Add space to avoid overlap with the top logo
                    // Image
                    Container(
                      height: 200,
                      child: Image.asset(
                        'assets/images/car_r.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 32),
                    // Email Field
                    TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.email, color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Password Field
                    TextField(
                      obscureText: !_isPasswordVisible,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.lock, color: Colors.white70),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    // Sign-in Button
                    Container(
                      width: double.infinity, // Button stretches across the screen width
                      height: 50, // Button height
                      decoration: BoxDecoration(
                        color: Color(0xFF939185), // Button background color
                        borderRadius: BorderRadius.circular(10), // Rounded edges
                      ),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            // Handle sign-in logic
                          },
                          child: Text(
                            "Sign-in",
                            style: TextStyle(
                              color: Colors.white, // Text color
                              fontSize: 20, // Text size
                              fontWeight: FontWeight.bold, // Bold text
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Sign-up Text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don’t have an Account?",
                          style: TextStyle(color: Colors.white70),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to Sign-up screen
                          },
                          child: Text(
                            "Sign up",
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
}
