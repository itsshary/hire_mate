import 'package:flutter/material.dart';
import 'package:hire_mate/view/software_house/bottom_screen_sh/bottom_screen_sh.dart';
import 'package:hire_mate/view/user_screens/auth_screens/login_screen.dart';
import 'package:hire_mate/view/user_screens/bottom_bar/bottom_navigation.dart';
import 'package:hire_mate/view/user_screens/onboarding_screen/calling_onboarding_screen/calling_onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateUser();
  }

  Future<void> _navigateUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    User? user = FirebaseAuth.instance.currentUser;

    await Future.delayed(const Duration(seconds: 2)); // Simulate loading

    if (!hasSeenOnboarding) {
      await prefs.setBool('hasSeenOnboarding', true);
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
            builder: (context) => const CallingOnboardingScreen()),
      );
    } else if (user == null) {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      _checkUserRole(user.uid);
    }
  }

  Future<void> _checkUserRole(String userId) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      String role = userDoc['role'];
      if (role == 'Hiring for Jobs') {
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const BottomScreenSh()),
        );
      } else {
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const CustomBottomBar()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Image.asset(
        "images/logohr.jpg",
        height: 100,
        width: 100,
      )),
    );
  }
}
