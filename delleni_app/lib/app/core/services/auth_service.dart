import 'package:delleni_app/app/data/models/user_model.dart';
import 'package:delleni_app/app/core/services/supabase_service.dart';

/// Service class for authentication operations
class AuthService {
  final _supabase = SupabaseService.instance;

  /// Register a new user with profile information
  Future<AuthResult> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String address,
    required String password,
  }) async {
    try {
      // 1. Sign up with Supabase Auth
      final authResponse = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        return AuthResult(success: false, error: 'فشل إنشاء حساب المستخدم');
      }

      final userId = authResponse.user!.id;

      // 2. Create user profile in 'users' table
      await _supabase.from('users').insert({
        'id': userId,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone_number': phoneNumber,
        'address': address,
        'created_at': DateTime.now().toIso8601String(),
      });

      return AuthResult(
        success: true,
        userId: userId,
        userEmail: email,
        message: 'تم إنشاء الحساب بنجاح',
      );
    } catch (e) {
      String errorMessage = 'حدث خطأ أثناء التسجيل';

      if (e.toString().contains('User already registered')) {
        errorMessage = 'البريد الإلكتروني مسجل مسبقاً';
      } else if (e.toString().contains('Invalid email')) {
        errorMessage = 'البريد الإلكتروني غير صالح';
      } else if (e.toString().contains('duplicate key')) {
        errorMessage = 'المستخدم مسجل مسبقاً';
      }

      return AuthResult(success: false, error: errorMessage);
    }
  }

  /// Login with email and password
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return AuthResult(
          success: false,
          error: 'البريد الإلكتروني أو كلمة المرور غير صحيحة',
        );
      }

      return AuthResult(
        success: true,
        userId: response.user!.id,
        userEmail: response.user!.email,
        message: 'تم تسجيل الدخول بنجاح',
      );
    } catch (e) {
      String errorMessage = 'حدث خطأ أثناء تسجيل الدخول';

      if (e.toString().contains('Invalid login credentials')) {
        errorMessage = 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
      } else if (e.toString().contains('Email not confirmed')) {
        errorMessage = 'يرجى تأكيد بريدك الإلكتروني أولاً';
      }

      return AuthResult(success: false, error: errorMessage);
    }
  }

  /// Logout current user
  Future<AuthResult> logout() async {
    try {
      await _supabase.auth.signOut();
      return AuthResult(success: true, message: 'تم تسجيل الخروج بنجاح');
    } catch (e) {
      return AuthResult(success: false, error: 'حدث خطأ أثناء تسجيل الخروج');
    }
  }

  /// Get current authenticated user
  User? getCurrentUser() {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    return User(
      id: user.id,
      email: user.email ?? '',
      createdAt: user.createdAt != null
          ? DateTime.parse(user.createdAt!)
          : null,
    );
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return _supabase.auth.currentUser != null;
  }

  /// Get current user ID
  String? getCurrentUserId() {
    return _supabase.auth.currentUser?.id;
  }

  /// Get current user email
  String? getCurrentUserEmail() {
    return _supabase.auth.currentUser?.email;
  }

  /// Get user profile from database
  Future<User?> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      return User.fromMap(response);
    } catch (e) {
      return null;
    }
  }

  /// Update user profile
  Future<AuthResult> updateProfile({
    required String userId,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? address,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (firstName != null) updates['first_name'] = firstName;
      if (lastName != null) updates['last_name'] = lastName;
      if (phoneNumber != null) updates['phone_number'] = phoneNumber;
      if (address != null) updates['address'] = address;
      updates['updated_at'] = DateTime.now().toIso8601String();

      await _supabase.from('users').update(updates).eq('id', userId);

      return AuthResult(success: true, message: 'تم تحديث الملف الشخصي بنجاح');
    } catch (e) {
      return AuthResult(success: false, error: 'فشل تحديث الملف الشخصي');
    }
  }

  /// Get current user with full profile
  Future<User?> getCurrentUserWithProfile() async {
    final user = getCurrentUser();
    if (user == null) return null;

    final profile = await getUserProfile(user.id);
    if (profile == null) return user;

    return user.copyWith(
      firstName: profile.firstName,
      lastName: profile.lastName,
      phoneNumber: profile.phoneNumber,
      address: profile.address,
      updatedAt: profile.updatedAt,
    );
  }
}

/// Result class for authentication operations
class AuthResult {
  final bool success;
  final String? userId;
  final String? userEmail;
  final String? message;
  final String? error;

  AuthResult({
    required this.success,
    this.userId,
    this.userEmail,
    this.message,
    this.error,
  });

  bool get hasError => error != null;
  bool get hasMessage => message != null;
}
