import 'dart:async';
import 'package:flutter/material.dart';
import 'home_screen.dart'; 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to Home after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor, 
      body: const Center(
        child: Text(
          "Laza",
          style: TextStyle(
            color: Colors.white,
            fontSize: 42,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto', // Default Android font looks clean
          ),
        ),
      ),
    );
  }
}