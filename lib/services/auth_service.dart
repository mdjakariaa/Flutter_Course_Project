import 'package:supabase_flutter/supabase_flutter.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  final SupabaseClient _supabaseClient;

  AuthService(this._supabaseClient);

  /// Get current user
  User? get currentUser => _supabaseClient.auth.currentUser;

  /// Get current user ID
  String? get currentUserId => _supabaseClient.auth.currentUser?.id;

  /// Check if user is authenticated
  bool get isAuthenticated => _supabaseClient.auth.currentUser != null;

  /// Sign up with email and password
  Future<User> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
        throw AuthException('Email, password, and name are required');
      }

      if (password.length < 6) {
        throw AuthException('Password must be at least 6 characters');
      }

      final response = await _supabaseClient.auth.signUp(
        email: email.trim(),
        password: password,
        data: {'full_name': fullName.trim()},
      );

      if (response.user == null) {
        throw AuthException('Sign up failed. Please try again.');
      }

      // Create user profile
      await _createUserProfile(
        userId: response.user!.id,
        email: email.trim(),
        fullName: fullName.trim(),
      );

      return response.user!;
    } on AuthException catch (e) {
      throw AuthException('Sign up error: ${e.message}');
    } catch (e) {
      throw AuthException('Sign up failed: ${e.toString()}');
    }
  }

  /// Login with email and password
  Future<User> login({required String email, required String password}) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw AuthException('Email and password are required');
      }

      final response = await _supabaseClient.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      if (response.user == null) {
        throw AuthException('Login failed. Invalid credentials.');
      }

      return response.user!;
    } on AuthException catch (e) {
      throw AuthException('Login error: ${e.message}');
    } catch (e) {
      throw AuthException('Login failed: ${e.toString()}');
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _supabaseClient.auth.signOut();
    } catch (e) {
      throw AuthException('Logout failed: ${e.toString()}');
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      if (email.isEmpty) {
        throw AuthException('Email is required');
      }

      await _supabaseClient.auth.resetPasswordForEmail(email.trim());
    } catch (e) {
      throw AuthException('Password reset failed: ${e.toString()}');
    }
  }

  /// Get user session
  Session? get session => _supabaseClient.auth.currentSession;

  /// Stream of auth state changes
  Stream<AuthState> get authStateChanges =>
      _supabaseClient.auth.onAuthStateChange;

  /// Create user profile in database
  Future<void> _createUserProfile({
    required String userId,
    required String email,
    required String fullName,
  }) async {
    try {
      await _supabaseClient.from('user_profiles').insert({
        'user_id': userId,
        'email': email,
        'full_name': fullName,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Log error but don't fail sign up if profile creation fails
      print('Warning: Failed to create user profile: $e');
    }
  }

  /// Update user profile
  Future<void> updateProfile({required String fullName}) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw AuthException('User not authenticated');
      }

      await _supabaseClient
          .from('user_profiles')
          .update({
            'full_name': fullName.trim(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId);
    } catch (e) {
      throw AuthException('Update profile failed: ${e.toString()}');
    }
  }

  /// Get user profile
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final userId = currentUserId;
      if (userId == null) return null;

      final response = await _supabaseClient
          .from('user_profiles')
          .select()
          .eq('user_id', userId)
          .single();

      return response;
    } catch (e) {
      print('Warning: Failed to fetch user profile: $e');
      return null;
    }
  }
}
