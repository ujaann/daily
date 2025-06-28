import 'package:daily/features/user/login_signup_form.dart';
import 'package:daily/theme/theme_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _isLoginProvider = StateProvider<bool>((ref) {
  return true;
});

class LoginSignupScreen extends ConsumerWidget {
  const LoginSignupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toggle = ref.watch(_isLoginProvider);
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text("Daily",
              style: TextStyle(color: ColorsDaily.white, fontSize: 32)),
          const SizedBox(height: 8),
          Text(toggle ? "Welcome Back" : "Join Us",
              style: const TextStyle(color: ColorsDaily.white70)),
          const SizedBox(height: 8),
          Text(toggle ? "Login to explore" : "Create an account",
              style: const TextStyle(color: ColorsDaily.white70)),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            height: 480,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Column(
              spacing: 16,
              children: [
                ToggleLoginSignup(),
                Expanded(
                    child: SingleChildScrollView(
                        child: LoginFormRiverpod(isLogin: toggle))),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ToggleLoginSignup extends ConsumerWidget {
  const ToggleLoginSignup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toggle = ref.watch(_isLoginProvider);
    return ToggleButtons(
        isSelected: [toggle, !toggle],
        onPressed: (index) {
          ref.read(_isLoginProvider.notifier).state = index == 0;
        },
        borderRadius: BorderRadius.circular(12),
        borderWidth: 4,
        borderColor: Colors.grey.shade300,
        selectedColor: ColorsDaily.cream,
        fillColor: ColorsDaily.purple,
        color: ColorsDaily.black,
        constraints: const BoxConstraints(minWidth: 120, minHeight: 40),
        children: [Text("Log In"), Text("Sign Up")]);
  }
}

// TextField(
//                   decoration: InputDecoration(
//                     labelText: "Email",
//                   ),
//                 ),
//                 TextField(
//                   decoration: InputDecoration(
//                     labelText: "Username",
//                   ),
//                 ),
//                 TextField(
//                   decoration: InputDecoration(
//                     labelText: "Password",
//                   ),
//                   obscureText: !ref.watch(_passwordVisibleProvider),
//                 ),
//                 Visibility(
//                   visible: !toggle,
//                   maintainAnimation: true,
//                   maintainSize: true,
//                   maintainState: true,
//                   child: TextField(
//                     decoration: InputDecoration(
//                       labelText: "Confirm Password",
//                     ),
//                     obscureText: !ref.watch(_passwordVisibleProvider),
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Checkbox(value: false, onChanged: (_) {}),
//                     Text("Remember me"),
//                     Spacer(),
//                     TextButton(
//                         onPressed: () {},
//                         child: Text(
//                           "Forgot Password?",
//                           style:
//                               TextStyle(decoration: TextDecoration.underline),
//                         )),
//                   ],
//                 ),
//                 ElevatedButton(
//                     onPressed: () {}, child: Text(toggle ? "Login" : "Signup"))
