import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/client/client_login_screen.dart';
import 'screens/client/client_registration_screen.dart';

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
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 200, end: 250).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _checkNavigation();
  }

  Future<void> _checkNavigation() async {
    final prefs = await SharedPreferences.getInstance();

    // Save splash screen visit state
    await prefs.setBool('hasSeenSplash', true);

    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Navigate to login or register screen after splash
    Timer(Duration(milliseconds: 3000), () {
      Navigator.pushReplacementNamed(
          context, isLoggedIn ? '/login' : '/register');
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
