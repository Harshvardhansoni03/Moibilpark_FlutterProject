import 'package:flutter/material.dart';
import 'package:mobil_park/screens/admin/admin_login.dart';
import 'package:mobil_park/screens/client/client_registration_screen.dart';

void main() {
  runApp(WelcomeScreen());
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MobilPark',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomePage(),
        '/login': (context) => AdminSignInScreen(),
        '/register': (context) => RegisterScreen(),
      },
    );
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2B2B40), // Dark blue background
      body: Stack(
        children: [
          // Logo and name in the top left
          Positioned(
            top: 50,
            left: 20,
            child: Column(
              children: [
                Icon(Icons.directions_car, size: 50, color: Color(0xFFD8B6A4)),
                SizedBox(height: 8),
                Text(
                  'MobilPark',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD8B6A4), // Light pink color
                  ),
                ),
              ],
            ),
          ),
          // Centered buttons
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB4A99E),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: Text(
                    'New User',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB4A99E),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  child: Text(
                    'Admin',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          // Quote at the bottom center
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Park effortlessly, anytime, anywhere!',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFD8B6A4),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Page')),
      body: Center(child: Text('Login Page Content')),
    );
  }
}

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register Page')),
      body: Center(child: Text('Register Page Content')),
    );
  }
}
