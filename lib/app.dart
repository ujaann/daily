import 'package:daily/view/login_signup_screen.dart';
import 'package:flutter/material.dart';

class DailyApp extends StatelessWidget {
  const DailyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginSignupScreen(),
    );
  }
}
