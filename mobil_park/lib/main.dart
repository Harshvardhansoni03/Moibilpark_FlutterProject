import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobil_park/firebase_options.dart';
import 'package:mobil_park/splash_screen.dart';
import 'screens/client/client_login_screen.dart';
import 'screens/client/client_registration_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  final hasSeenSplash = prefs.getBool('hasSeenSplash') ?? false;
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(
    initialRoute: hasSeenSplash
        ? (isLoggedIn ? '/login' : '/register')
        : '/splash',
  ));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MobilPark',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      routes: {
        '/splash': (context) => SplashScreen(),
        '/register': (context) => RegisterScreen(),
        '/login': (context) => SignInScreen(),
      },
    );
  }
}
