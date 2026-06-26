import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_exception.dart';
import '../models/user_model.dart';

@injectable
class AuthRemoteDatasource {
  final _auth = Supabase.instance.client.auth;

  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await _auth.signUp(
      email: email,
      password: password,
      data: {'name': name},
    );
    if (response.user == null) {
      throw const ServerException('Registration failed. Please try again.');
    }
    return UserModel.fromSupabase(response.user!);
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.user == null) {
      throw const UnauthorizedException('Invalid email or password.');
    }
    return UserModel.fromSupabase(response.user!);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;

  Stream<AuthState> get authStateChanges => _auth.onAuthStateChange;
}
