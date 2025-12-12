import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delleni_app/app/data/repositories/auth_repository.dart';
import 'package:delleni_app/app/data/models/user_model.dart';
import 'package:delleni_app/app/core/utils/validators.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  // Observable state
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool rememberMe = false.obs;

  // Form controllers (for views to bind to)
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    checkCurrentUser();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  /// Check if user is already logged in
  Future<void> checkCurrentUser() async {
    isLoading.value = true;
    try {
      final user = await _authRepository.getCurrentUser();
      currentUser.value = user;
    } finally {
      isLoading.value = false;
    }
  }

  /// Login with email and password
  Future<bool> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    // Validate inputs
    final emailError = Validators.validateEmail(email);
    final passwordError = Validators.validatePassword(password);

    if (emailError != null || passwordError != null) {
      Get.snackbar('خطأ', emailError ?? passwordError ?? '');
      return false;
    }

    isLoading.value = true;
    try {
      final user = await _authRepository.login(email, password);
      if (user != null) {
        currentUser.value = user;
        Get.snackbar('نجاح', 'تم تسجيل الدخول بنجاح');
        return true;
      } else {
        Get.snackbar('خطأ', 'البريد الإلكتروني أو كلمة المرور غير صحيحة');
        return false;
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء تسجيل الدخول');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Register new user
  Future<bool> register() async {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final address = addressController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // Validate inputs
    final errors = <String>[];

    if (firstName.isEmpty) errors.add('الاسم الأول مطلوب');
    if (lastName.isEmpty) errors.add('اسم العائلة مطلوب');

    final emailError = Validators.validateEmail(email);
    if (emailError != null) errors.add(emailError);

    final phoneError = Validators.validatePhone(phone);
    if (phoneError != null) errors.add(phoneError);

    final passwordError = Validators.validatePassword(password);
    if (passwordError != null) errors.add(passwordError);

    final confirmError = Validators.validateConfirmPassword(
      confirmPassword,
      password,
    );
    if (confirmError != null) errors.add(confirmError);

    if (errors.isNotEmpty) {
      Get.snackbar('خطأ', errors.join('\n'));
      return false;
    }

    isLoading.value = true;
    try {
      final user = await _authRepository.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phone,
        address: address,
        password: password,
      );

      if (user != null) {
        currentUser.value = user;
        Get.snackbar('نجاح', 'تم إنشاء الحساب بنجاح');
        return true;
      } else {
        Get.snackbar('خطأ', 'فشل إنشاء الحساب');
        return false;
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء إنشاء الحساب');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    isLoading.value = true;
    try {
      await _authRepository.logout();
      currentUser.value = null;
      clearForm();
      Get.offAllNamed('/login');
      Get.snackbar('نجاح', 'تم تسجيل الخروج بنجاح');
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء تسجيل الخروج');
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Toggle remember me
  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  /// Clear all form fields
  void clearForm() {
    emailController.clear();
    passwordController.clear();
    firstNameController.clear();
    lastNameController.clear();
    phoneController.clear();
    addressController.clear();
    confirmPasswordController.clear();
  }

  /// Check if user is authenticated
  bool get isAuthenticated => _authRepository.isAuthenticated();

  /// Get current user ID
  String? get currentUserId => _authRepository.getCurrentUserId();
}
