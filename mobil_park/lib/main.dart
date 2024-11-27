import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobil_park/firebase_options.dart';
import 'package:mobil_park/splash_screen.dart';
import 'screens/client/client_login_screen.dart';
import 'screens/client/client_registration_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp(initialRoute: '',));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required String initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MobilPark',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulating an artificial delay to show splash screen
    Future.delayed(const Duration(seconds: 3), () {
      // Navigate to either login or registration screen
      final isLoggedIn = false; // Replace with actual login state logic.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => isLoggedIn
              ?  SignInScreen()
              :  RegisterScreen(),
        ),
      );
    });

    return Scaffold(
      body: Center(
        child: Text(
          'Welcome to MobilPark',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }
}
