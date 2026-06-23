import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/hive_constants.dart';
import '../../../../core/storage/hive_storage.dart';
import '../models/user_model.dart';

@injectable
class AuthRemoteDatasource {
  final DioClient _dioClient;
  final HiveStorage _hiveStorage;

  const AuthRemoteDatasource(this._dioClient, this._hiveStorage);

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

    try {
      final response = await _dioClient.dio.get(ApiEndpoints.currentUser);
      final user = UserModel.fromJson(response.data as Map<String, dynamic>);
      final userWithEmail = UserModel(
        id: user.id,
        name: user.name,
        email: email,
        username: user.username,
        phone: user.phone,
        website: user.website,
      );
      await _hiveStorage.write<UserModel>(
          HiveBoxes.auth, HiveKeys.currentUser, userWithEmail);
      return userWithEmail;
    } on DioException catch (e) {
      throw e.appException;
    }
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

    try {
      final response = await _dioClient.dio.get(ApiEndpoints.currentUser);
      final baseUser =
          UserModel.fromJson(response.data as Map<String, dynamic>);
      final newUser = UserModel(
        id: baseUser.id,
        name: name,
        email: email,
        username: email.split('@').first,
        phone: baseUser.phone,
        website: baseUser.website,
      );

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final base64Email = base64Url.encode(utf8.encode(email));
      final fakeToken = 'fake_jwt_${timestamp}_$base64Email';
      await _hiveStorage.write<String>(
          HiveBoxes.auth, HiveKeys.token, fakeToken);
      await _hiveStorage.write<UserModel>(
          HiveBoxes.auth, HiveKeys.currentUser, newUser);

      return newUser;
    } on DioException catch (e) {
      throw e.appException;
    }
  }
}
