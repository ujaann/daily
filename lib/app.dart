import 'package:daily/auth/auth_service.dart';
import 'package:daily/features/home/navigation_screen.dart';
import 'package:daily/features/user/login_signup_screen.dart';
import 'package:daily/theme/theme_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DailyApp extends ConsumerWidget {
  const DailyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(authServiceProvider);

    return MaterialApp(
      home: (user != null && user.rememberMe)
          ? NavigationScreen()
          : LoginSignupScreen(),
      theme: getApplicationTheme(),
    );
  }
}
