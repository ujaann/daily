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

  bool isUsernameTaken(String username) {
    final data = box.values.any(
      (u) => u.username == username,
    );
    return data;
  }

  UserEntity? getUserByUsername(String username) {
    try {
      return box.values.firstWhere((user) => user.username == username);
    } on StateError catch (_) {
      return null;
    }
  }

  bool isEmailTaken(String email) {
    final data = box.values.any(
      (u) => u.email == email,
    );
    return data;
  }

  Future<bool> addUser(UserEntity user) async {
    if (isUsernameTaken(user.username) || isEmailTaken(user.email)) {
      return false;
    }
    await box.add(user);
    return true;
  }

  Future<void> updateUser(
    UserEntity user, {
    String? username,
    String? email,
    String? password,
  }) async {
    final updatedUser = user.copyWith(
      username: username,
      email: email,
      password: password,
    );
    await box.put(user.key, updatedUser);
  }

  Future<void> deleteUser(UserEntity user) async {
    await box.delete(user.key);
  }

  // Login: returns user if credentials match, else null
  Future<UserEntity?> login(
      String username, String password, bool rememberMe) async {
    try {
      final data = box.values
          .where(
            (u) => u.username == username && u.password == password,
          )
          .firstOrNull;

      return data;
    } on Exception catch (_) {
      return null;
    }
  }
}
