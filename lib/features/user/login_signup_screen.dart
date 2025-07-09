import 'package:daily/features/user/login_signup_form.dart';
import 'package:daily/theme/theme_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 14,
            children: [
              Text("Daily",
                  style: FontsDaily.bigHeadline.copyWith(color: Colors.white)),
              SvgPicture.asset(
                'assets/Logo.svg',
                semanticsLabel: "Daily Logo",
                width: 60,
                height: 60,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 14,
            children: [
              Text(toggle ? "Welcome Back" : "Join Us",
                  style: const TextStyle(color: Colors.white)),
              Text(toggle ? "Login to explore" : "Create an account",
                  style: const TextStyle(color: ColorsDaily.white70)),
            ],
          ),
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
