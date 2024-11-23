import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobil_park/screens/admin/admin_home.dart';
import 'package:mobil_park/screens/admin/admin_login.dart';
import 'package:mobil_park/screens/client/client_login_screen.dart';
import 'package:mobil_park/screens/client/client_registration_screen.dart';
import 'package:mobil_park/screens/admin/admin_registration.dart';
import 'package:mobil_park/services/location_service.dart';

void main() => runApp(MobilParkApp());

class MobilParkApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Animation setup
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 200, end: 250).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Navigate to the next screen after 3 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminSignInScreen()), // Replace with the screen you want
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2F3F),
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Animated concentric circles
                ...List.generate(3, (index) {
                  double factor = 1.35 - (index * 0.2); // Reduces size for inner circles
                  return Container(
                    width: _animation.value * factor,
                    height: _animation.value * factor,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1 * (index + 1)),
                      shape: BoxShape.circle,
                    ),
                  );
                }),
                // Centered logo and text
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.directions_car,
                        size: 60,
                        color: const Color(0xFFEC7357),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Text
                    const Text(
                      'MobilPark',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

