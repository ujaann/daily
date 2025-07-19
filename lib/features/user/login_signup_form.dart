import 'package:daily/auth/auth_service.dart';
import 'package:daily/entity/user.dart';
import 'package:daily/features/home/navigation_screen.dart';
import 'package:daily/features/user/data/user_repo.dart';
import 'package:daily/util/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Providers for controllers with autoDispose
final _passwordShowProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});
final _confirmPasswordShowProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

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

final _rememberMeProvider = StateProvider.autoDispose<bool>((ref) => false);

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
    final rememberMe = ref.watch(_rememberMeProvider);

    Future<void> submit(WidgetRef ref) async {
      if (_formKey.currentState?.validate() ?? false) {
        if (isLogin) {
          final login = await ref.read(userRepoProvider).login(
              usernameController.text, passwordController.text, rememberMe);
          if (login != null) {
            ref
                .read(authServiceProvider.notifier)
                .storeAuth(username: login.username, rememberMe: rememberMe);
          } else if (context.mounted) {
            showErrorSnackbar(context, "Invalid credentials");
            return;
          }
        } else {
          final user = UserEntity(
            username: usernameController.text,
            email: emailController.text,
            password: passwordController.text,
          );
          final register = await ref.read(userRepoProvider).addUser(user);
          if (register) {
            ref
                .read(authServiceProvider.notifier)
                .storeAuth(username: user.username, rememberMe: rememberMe);
          } else if (context.mounted) {
            showErrorSnackbar(context, "User already exists");
            return;
          }
        }
        if (context.mounted) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => NavigationScreen(),
              ));
          return;
        }
      }
    }

    final passwordShow = ref.watch(_passwordShowProvider);
    final confirmPasswordShow = ref.watch(_confirmPasswordShowProvider);
    return Form(
      key: _formKey,
      child: Column(
        spacing: 12,
        children: [
          const SizedBox(
            height: 12,
          ),
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
          if (!isLogin)
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (isLogin) return null;
                if (value == null || value.trim().isEmpty) {
                  return 'Email is required';
                }
                if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'Enter a valid email';
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
            ),
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                    onPressed: () {
                      ref.read(_passwordShowProvider.notifier).state =
                          !ref.read(_passwordShowProvider);
                    },
                    icon: Icon(
                      passwordShow ? Icons.visibility : Icons.visibility_off,
                    ))),
            obscureText: !passwordShow,
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
              decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  suffixIcon: IconButton(
                      onPressed: () {
                        ref.read(_confirmPasswordShowProvider.notifier).state =
                            !ref.read(_confirmPasswordShowProvider);
                      },
                      icon: Icon(
                        confirmPasswordShow
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ))),
              obscureText: !confirmPasswordShow,
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
                onChanged: (val) =>
                    ref.read(_rememberMeProvider.notifier).state = val ?? false,
              ),
              const Text('Remember me'),
              Spacer(),
              // TextButton(
              //     onPressed: () {
              //       Navigator.pushReplacement(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => NavigationScreen(),
              //           ));
              //     },
              //     child: Text(
              //       "Forgot Password?",
              //       style: TextStyle(decoration: TextDecoration.underline),
              //     )),
            ],
          ),
          ElevatedButton(
            onPressed: () => submit(ref),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
