import 'package:delleni_app/main.dart';
class AuthService {

  Future<bool> register(String firstname, String lastname, String email, String phonenumber, String address, String password) async {
    try {
      final response = await global.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        final userId = response.user!.id;

        final profileResponse = await global.from('users').insert({
          'id': userId,
          'first_name': firstname,
          'last_name': lastname,
          'email': email,
          'phone_number': phonenumber,
          'address': address,
        });

        if (profileResponse.error != null) {
          throw profileResponse.error!;
        }

        return true; // Registration successful
      } else {
        throw Exception('User registration failed.');
      }
    } catch (e) {
      print('Error during registration: $e');
      return false; // Registration failed
    }
  }

  Future<(bool success, String? message)> login(String email, String password) async {
    try {
      final response = await global.auth.signInWithPassword(
        email: email.trim(),
        password: password.trim(),
      );
      if (response.user != null) {
        return (true, null);
      } else {
        return (false, 'تعذر تسجيل الدخول');
      }
    } catch (e) {
      // Provide clearer error to UI
      final msg = e.toString();
      print('Error during login: $msg');
      return (false, msg);
    }
  }

  Future<(bool success, String? message)> logout() async {
    try {
      await global.auth.signOut();
      return (true, null);
    } catch (e) {
      final msg = e.toString();
      print('Error during logout: $msg');
      return (false, msg);
    }
  }


}