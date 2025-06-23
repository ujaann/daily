import 'package:daily/features/home/navigation_screen.dart';
import 'package:daily/theme/theme_common.dart';
import 'package:flutter/material.dart';

class DailyApp extends StatelessWidget {
  const DailyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NavigationScreen(),
      theme: getApplicationTheme(),
    );
  }
}
