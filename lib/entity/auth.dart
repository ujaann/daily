import 'package:hive_ce/hive.dart';

class AuthEntity extends HiveObject {
  final String username;
  final bool rememberMe;

  AuthEntity({required this.username, required this.rememberMe});
}
