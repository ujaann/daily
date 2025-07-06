import 'package:hive_ce/hive.dart';

class UserEntity extends HiveObject {
  final String username;
  final String email;
  final String password;
  final bool rememberMe;

  UserEntity({
    required this.username,
    required this.email,
    required this.password,
    required this.rememberMe,
  });

  UserEntity copyWith({
    String? username,
    String? email,
    String? password,
    bool? rememberMe,
  }) {
    return UserEntity(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }
}
