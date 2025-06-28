import 'package:daily/features/home/navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Providers for controllers with autoDispose
final _usernameControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});

final _emailControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});

final _passwordControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});

final _confirmControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});

final rememberMeProvider = StateProvider<bool>((ref) => false);

class LoginFormRiverpod extends ConsumerWidget {
  LoginFormRiverpod({super.key, required this.isLogin});
  final bool isLogin;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameController = ref.watch(_usernameControllerProvider);
    final emailController = ref.watch(_emailControllerProvider);
    final passwordController = ref.watch(_passwordControllerProvider);
    final confirmController = ref.watch(_confirmControllerProvider);
    final rememberMe = ref.watch(rememberMeProvider);
    final rememberMeNotifier = ref.read(rememberMeProvider.notifier);

    void submit() {
      if (_formKey.currentState?.validate() ?? false) {
        print('Username: ${usernameController.text}');
        print('Email: ${emailController.text}');
        print('Password: ${passwordController.text}');
        print('Confirm: ${confirmController.text}');
        print('Remember me: $rememberMe');
      }
    }

    return Form(
      key: _formKey,
      child: Column(
        spacing: 12,
        children: [
          TextFormField(
            controller: usernameController,
            decoration: const InputDecoration(labelText: 'Username'),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Username is required';
              }
              if (value.trim().length < 3) {
                return 'Username must be at least 3 characters';
              }
              return null;
            },
          ),
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email is required';
              }
              if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Enter a valid email';
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
          ),
          TextFormField(
            controller: passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          if (!isLogin)
            TextFormField(
              controller: confirmController,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
              validator: (value) {
                if (isLogin) return null;
                if (value != passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
          Row(
            children: [
              Checkbox(
                value: rememberMe,
                onChanged: (val) => rememberMeNotifier.state = val ?? false,
              ),
              const Text('Remember me'),
              Spacer(),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NavigationScreen(),
                        ));
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(decoration: TextDecoration.underline),
                  )),
            ],
          ),
          ElevatedButton(
            onPressed: submit,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
