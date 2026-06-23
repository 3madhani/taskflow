import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/storage/hive_constants.dart';
import '../../../../core/storage/hive_storage.dart';
import '../models/user_model.dart';

@injectable
class AuthRemoteDatasource {
  final HiveStorage _hiveStorage;

  const AuthRemoteDatasource(this._hiveStorage);

  UserModel? getCachedUser() {
    return _hiveStorage.read<UserModel>(HiveBoxes.auth, HiveKeys.currentUser);
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      throw const ValidationException('Please enter a valid email address.');
    }
    if (password.length < 6) {
      throw const ValidationException(
          'Password must be at least 6 characters.');
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final base64Email = base64Url.encode(utf8.encode(email));
    final fakeToken = 'fake_jwt_${timestamp}_$base64Email';

    await _hiveStorage.write<String>(HiveBoxes.auth, HiveKeys.token, fakeToken);

    final user = UserModel(
      id: 1,
      name: email.split('@').first,
      email: email,
      username: email.split('@').first,
      phone: '1-770-736-8031',
      website: 'hildegard.org',
    );
    await _hiveStorage.write<UserModel>(
        HiveBoxes.auth, HiveKeys.currentUser, user);
    return user;
  }

  Future<void> logout() async {
    await _hiveStorage.delete(HiveBoxes.auth, HiveKeys.token);
    await _hiveStorage.delete(HiveBoxes.auth, HiveKeys.currentUser);
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (name.trim().length < 2) {
      throw const ValidationException('Name must be at least 2 characters.');
    }
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      throw const ValidationException('Please enter a valid email address.');
    }
    if (password.length < 6) {
      throw const ValidationException(
          'Password must be at least 6 characters.');
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final base64Email = base64Url.encode(utf8.encode(email));
    final fakeToken = 'fake_jwt_${timestamp}_$base64Email';
    await _hiveStorage.write<String>(
        HiveBoxes.auth, HiveKeys.token, fakeToken);

    final newUser = UserModel(
      id: 1,
      name: name,
      email: email,
      username: email.split('@').first,
      phone: '1-770-736-8031',
      website: 'hildegard.org',
    );

    await _hiveStorage.write<UserModel>(
        HiveBoxes.auth, HiveKeys.currentUser, newUser);
    return newUser;
  }
}
