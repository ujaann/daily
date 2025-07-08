import 'package:daily/entity/auth.dart';
import 'package:daily/hive/hive_boxes.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_service.g.dart';

@riverpod
class AuthService extends _$AuthService {
  final authBox = Hive.box<AuthEntity>(HiveBoxes.authBox);
  @override
  AuthEntity? build() {
    final user = authBox.get('session');
    return user;
  }

  Future<void> clear() async {
    print(await authBox.clear());
  }

  Future<void> storeAuth(
      {required String username, required bool rememberMe}) async {
    await authBox.put(
        'session', AuthEntity(username: username, rememberMe: rememberMe));
  }
}
