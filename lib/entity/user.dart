import 'package:hive_ce/hive.dart';

class UserEntity extends HiveObject {
  final String username;
  final String email;
  final String password;

  UserEntity({
    required this.username,
    required this.email,
    required this.password,
  });

  UserEntity copyWith({
    String? username,
    String? email,
    String? password,
  }) {
    return UserEntity(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
