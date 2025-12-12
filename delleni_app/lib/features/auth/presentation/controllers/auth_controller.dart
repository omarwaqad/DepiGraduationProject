import 'package:delleni_app/features/auth/domain/usecases/login.dart';
import 'package:delleni_app/features/auth/domain/usecases/logout.dart';
import 'package:delleni_app/features/auth/domain/usecases/register.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  AuthController({required this.loginUseCase, required this.logoutUseCase, required this.registerUseCase});

  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final RegisterUseCase registerUseCase;

  final isLoading = false.obs;

  Future<(bool, String?)> login(String email, String password) async {
    try {
      isLoading.value = true;
      final res = await loginUseCase(email: email, password: password);
      final user = res.user;
      if (user != null) return (true, null);
      return (false, 'تعذر تسجيل الدخول');
    } catch (e) {
      return (false, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<(bool, String?)> logout() async {
    try {
      await logoutUseCase();
      return (true, null);
    } catch (e) {
      return (false, e.toString());
    }
  }

  Future<(bool, String?)> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String address,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      final res = await registerUseCase(
        email: email,
        password: password,
        profile: {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'phone_number': phone,
          'address': address,
        },
      );
      if (res.user != null) return (true, null);
      return (false, 'تعذر إنشاء الحساب');
    } catch (e) {
      return (false, e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
