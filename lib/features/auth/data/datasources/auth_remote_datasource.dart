import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_exception.dart';
import '../models/user_model.dart';

/// Auth datasource that delegates all authentication to the Supabase Auth SDK.
/// The SDK stores the JWT in flutter_secure_storage (Android Keystore / iOS Keychain)
/// and handles token refresh automatically. Do NOT store JWT in Hive manually.
@injectable
class AuthRemoteDatasource {
  final _auth = Supabase.instance.client.auth;

  /// Register a new user — creates account in Supabase Auth.
  /// Supabase sends a confirmation email unless disabled in Auth settings.
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await _auth.signUp(
      email: email,
      password: password,
      data: {'name': name}, // stored in user_metadata
    );
    if (response.user == null) {
      throw const ServerException('Registration failed. Please try again.');
    }
    return UserModel.fromSupabase(response.user!);
  }

  /// Login — returns a session containing the access token (JWT).
  /// JWT is stored internally by the SDK, not returned to the caller.
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

  /// Logout — clears JWT from flutter_secure_storage.
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Returns the currently authenticated Supabase [User], or null.
  /// Reads from the in-memory session managed by the SDK.
  User? get currentUser => _auth.currentUser;

  /// Stream of auth state changes — used by AuthBloc to react to sign-in/out/refresh.
  Stream<AuthState> get authStateChanges => _auth.onAuthStateChange;
}
