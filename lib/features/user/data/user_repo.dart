import 'package:daily/entity/user.dart';
import 'package:daily/hive/hive_boxes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_repo.g.dart';

@riverpod
Box<UserEntity> _userBox(Ref ref) {
  return Hive.box<UserEntity>(HiveBoxes.userBox);
}

@riverpod
UserRepo userRepo(Ref ref) {
  final box = ref.watch(_userBoxProvider);
  return UserRepo(box);
}

class UserRepo {
  final Box<UserEntity> box;

  UserRepo(this.box);

  List<UserEntity> getAllUsers() {
    return box.values.toList();
  }

  UserEntity? getUserByEmail(String email) {
    return box.values.firstWhere(
      (u) => u.email == email,
    );
  }

  Future<void> addUser(UserEntity user) async {
    await box.add(user);
  }

  Future<void> updateUser(
    UserEntity user, {
    String? username,
    String? email,
    String? password,
    bool? rememberMe,
  }) async {
    final updatedUser = user.copyWith(
      username: username,
      email: email,
      password: password,
      rememberMe: rememberMe,
    );
    await box.put(user.key, updatedUser);
  }

  Future<void> deleteUser(UserEntity user) async {
    await box.delete(user.key);
  }

  // Login: returns user if credentials match, else null
  UserEntity? login(String username, String password) {
    return box.values.firstWhere(
      (u) => u.username == username && u.password == password,
    );
  }

  // Remember toggle
  Future<void> setRememberMe(UserEntity user, bool rememberMe) async {
    await updateUser(user, rememberMe: rememberMe);
  }
}
