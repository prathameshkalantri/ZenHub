import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zenhub/signin_page.dart';
import 'package:zenhub/signup_page.dart';
import 'package:zenhub/home_page.dart';
import 'package:zenhub/setting_page.dart';
import 'package:zenhub/workout_page.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tz.initializeTimeZones();
  await NotificationService().initNotification();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AuthChecker(), // Use AuthChecker as the home page
      routes: {
        '/signin': (context) => SignInPage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/setting': (context) => SettingPage(), // Add SettingPage route
        '/workout': (context) => WorkoutPage(), // Add WorkoutPage route
      },
    );
  }
}

class AuthChecker extends StatefulWidget {
  @override
  _AuthCheckerState createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  @override
  void initState() {
    super.initState();
    // Defer the checkAuthStatus function call until after the build phase
    WidgetsBinding.instance!.addPostFrameCallback((_) => checkAuthStatus());
  }

  Future<void> checkAuthStatus() async {
    // Get the current user
    final User? user = FirebaseAuth.instance.currentUser;

    // Navigate to the appropriate page based on user authentication status
    if (user != null) {
      // User is signed in, navigate to home page
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // User is not signed in, navigate to sign in page
      Navigator.pushReplacementNamed(context, '/signin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
